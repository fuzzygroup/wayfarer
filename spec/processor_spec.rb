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
      expect {
        processor.send(:stage, uri)
      }.to change { processor.staged_uris.count }.by(1)
    end

    context "with cached URI" do
      before { processor.instance_variable_set(:@cached_uris, [uri]) }

      it "does not stage the URI" do
        expect {
          processor.send(:stage, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end

    context "with staged URI" do
      before { processor.send(:stage, uri) }

      it "does not stage the URI again" do
        expect {
          processor.send(:stage, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end

    context "with URI forbidden by `@router`" do
      before { router.forbid.host("example.com") }

      it "does not stage the URI" do
        expect {
          processor.send(:stage, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end
  end

  describe "#cache" do
    let(:uri) { URI("http://example.com") }

    it "caches a URI" do
      expect {
        processor.send(:cache, uri)
      }.to change { processor.cached_uris.count }.by(1)
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

  describe "#staged?" do
    let(:uri) { URI("http://example.com") }

    context "with staged URI" do
      before { processor.send(:stage, uri) }

      it "returns `true`" do
        expect(processor.send(:staged?, uri)).to be true
      end
    end

    context "with non-staged URI" do
      it "returns `false`" do
        expect(processor.send(:staged?, uri)).to be false
      end
    end
  end

  describe "#cached?" do
    let(:uri) { URI("http://example.com") }

    context "with processed URI" do
      before { processor.instance_variable_set(:@cached_uris, [uri]) }

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
    before do
      processor.instance_variable_set(:@staged_uris, [:staged])
      processor.send(:cycle)
    end

    it "sets `@current_uris` to `@staged_uris`" do
      expect(processor.current_uris).to eq [:staged]
    end

    it "sets `@staged_uris` to an empty list" do
      expect(processor.staged_uris).to eq []
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
        http://0.0.0.0:9876/redirect_loop
      ).map { |str| URI(str) }
    end

    it "caches processed URIs" do
      expect(processor.cached_uris).to eq [
        URI("http://0.0.0.0:9876/graph/index.html")
      ]
    end
  end

  describe "#run" do
    it "works" do
      processor.run
      expect(processor.result).to eq 5
    end
  end

end
