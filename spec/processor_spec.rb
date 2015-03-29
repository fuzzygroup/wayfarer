require "spec_helpers"

describe Schablone::Processor do
  let(:entry_uri) { URI("http://example.com/entry") }
  let(:scraper) do
    scraper = Scraper.new
    scraper.css(:title, "title")
    scraper
  end

  let(:router) do
    router = Router.new
    router.allow.host("example.com")
    router
  end

  subject(:processor) { Processor.new(entry_uri, scraper, router) }

  describe "#initialize" do
    it "appends `entry_uri` to `@current_uris`" do
      expect(processor.current_uris).to eq [entry_uri]
    end

    it "sets `@staged_uris` to an empty list" do
      expect(processor.staged_uris).to eq []
    end

    it "sets `@cached_uris` to an empty list" do
      expect(processor.cached_uris).to eq []
    end
  end

  describe "#stage" do
    let(:uri) { URI("http://example.com") }

    it "stages a URI" do
      expect do
        processor.send(:stage, uri)
      end.to change { processor.staged_uris.count }.by(1)
    end

    it "removes fragment identifier from URIs" do
      uri = URI("http://example.com/foo#bar")
      processor.send(:stage, uri)
      expect(processor.staged_uris.last.to_s).to eq "http://example.com/foo"
    end
  end

  describe "#cache" do
    let(:uri) { URI("http://example.com") }

    it "caches a URI" do
      expect do
        processor.send(:cache, uri)
      end.to change { processor.cached_uris.count }.by(1)
    end
  end

  describe "#current?" do
    let(:uri) { URI("http://example.com") }

    context "with current URI" do
      before { processor.instance_variable_set(:@current_uris, [uri]) }

      it "returns `true`" do
        expect(processor.send(:current?, uri)).to be true
      end
    end

    context "with non-current URI" do
      it "returns `false`" do
        expect(processor.send(:current?, uri)).to be false
      end
    end
  end

  describe "#cached?" do
    let(:uri) { URI("http://example.com") }

    context "with processed URI" do
      before { processor.send(:cache, uri) }

      it "returns `true`" do
        expect(processor.send(:cached?, uri)).to be true
      end
    end

    context "with unprocessed URI" do
      it "returns `false`" do
        expect(processor.send(:cached?, uri)).to be false
      end
    end
  end

  describe "#cycle" do
    let(:uri) { URI("http://example.com") }
    before do
      processor.send(:stage, uri)
      processor.send(:cycle)
    end

    it "sets `@current_uris` to `@staged_uris`" do
      expect(processor.current_uris).to eq [uri]
    end

    it "sets `@staged_uris` to an empty list" do
      expect(processor.staged_uris).to eq []
    end
  end

  describe "#current_uri_queue" do
    it "returns a `Queue` of the correct size" do
      processor.instance_variable_set(:@current_uris, [1, 2, 3])
      expect(processor.send(:current_uri_queue).size).to be 3
    end
  end

  describe "#filter_staged_uris" do
    let(:uri) { URI("http://example.com") }
    before do
      router.allow.host("example.com")
    end

    it "filters duplicate URIs" do
      processor.send(:stage, uri)
      processor.send(:stage, uri)
      expect {
        processor.send(:filter_staged_uris)
      }.to change { processor.staged_uris.count }.by(-1)
    end

    it "filters URIs included in `@current_uris`" do
      processor.instance_variable_set(:@current_uris, [uri])
      processor.send(:stage, uri)
      expect {
        processor.send(:filter_staged_uris)
      }.to change { processor.staged_uris.count }.by(-1)
    end

    it "filters URIs included in `@cached_uris`" do
      processor.send(:cache, uri)
      processor.send(:stage, uri)
      expect {
        processor.send(:filter_staged_uris)
      }.to change { processor.staged_uris.count }.by(-1)
    end

    it "filters URIs forbidden by `@router`" do
      router.forbid.host("example.com")
      processor.send(:stage, uri)
      expect {
        processor.send(:filter_staged_uris)
      }.to change { processor.staged_uris.count }.by(-1)
    end
  end

  describe "#remove_fragment_identifier" do
    it "works" do
      uris = %w(
        http://example.com
        http://example.com#foo
        http://example.com#/foo
        http://example.com/foo#bar
        http://example.com/foo?bar=qux#quux
      ).map { |str| URI(str) }

      cleaned = uris.map do |uri|
        processor.send(:remove_fragment_identifier, uri)
      end

      expect(cleaned).to eq %w(
        http://example.com
        http://example.com
        http://example.com
        http://example.com/foo
        http://example.com/foo?bar=qux
      ).map { |str| URI(str) }
    end
  end

  describe "#process" do
    let(:uri) { URI("http://0.0.0.0:9876/graph/index.html") }
    before { router.allow.host("0.0.0.0") }
    before { processor.send(:process, uri) }

    it "works" do
      expect(processor.result).to eq [{ title: "Index" }]
    end

    it "stages the expected URIs" do
      expect(processor.staged_uris).to eq %w(
        http://0.0.0.0:9876/graph/details/a.html
        http://0.0.0.0:9876/graph/details/b.html
        http://0.0.0.0:9876/status_code/400
        http://0.0.0.0:9876/status_code/403
        http://0.0.0.0:9876/status_code/404
        http://bro.ken
        http://0.0.0.0:9876/redirect_loop
      ).map { |str| URI(str) }
    end

    it "caches processed URIs" do
      expect(processor.cached_uris).to eq [
        "http://0.0.0.0:9876/graph/index.html"
      ]
    end
  end

  describe "#run" do
    let(:entry_uri) { URI("http://0.0.0.0:9876/graph/index.html") }
    before { router.allow.host("0.0.0.0") }
    before { Schablone.config.log_level = Logger::INFO }
    after { Schablone.config.reset! }

    it "works" do
      processor.run
      expect(processor.result.count).to be 6
    end
  end
end
