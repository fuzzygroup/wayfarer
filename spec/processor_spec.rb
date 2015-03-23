require "spec_helpers"

describe Schablone::Processor do

  let(:entry_uri) { URI("http://0.0.0.0:9876/graph/index.html") }
  let(:scraper) { Scraper.new { css :title, "title" } }
  let(:router) do
    router = Router.new
    router.allow.host("0.0.0.0")
    router
  end

  subject(:processor) { Processor.new(entry_uri, scraper, router) }

  describe "#initialize" do
    it "sets the entry URI as current" do
      expect(processor.current_uris).to eq [entry_uri]
    end
  end

  describe "#cache_uri" do
    it "caches the URI" do
      uri = URI("http://example.com")
      expect {
        processor.send(:cache_uri, uri)
      }.to change { processor.cached_uris.count }.by(1)
    end
  end

  describe "#stage_uri" do
    context "with URI allowed by Router given" do
      let(:uri) { URI("http://0.0.0.0/foo") }

      it "stages the URI" do
        expect {
          processor.send(:stage_uri, uri)
        }.to change { processor.staged_uris.count }.by(1)
      end

      it "does not stage the same URI twice" do
        processor.send(:stage_uri, uri)
        processor.send(:stage_uri, uri)
        expect(processor.staged_uris.count).to be 1
      end

      it "does not stage current URIs" do
        processor.instance_variable_set(:@current_uris, [uri])
        processor.send(:stage_uri, uri)
        expect(processor.staged_uris).to be_empty
      end
    end

    context "with URI forbidden by Router given" do
      let(:uri) { URI("http://example.com") }

      it "does not stage the URI" do
        expect {
          processor.send(:stage_uri, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end

    context "with already cached URI given" do
      let(:uri) { URI("http://example.com") }
      before { processor.send(:cache_uri, uri) }

      it "does not stage the URI" do
        expect {
          processor.send(:stage_uri, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end
  end

  describe "#next_uri" do
    let(:uri) { URI("http://example.com") }
    before { processor.instance_variable_set(:@current_uris, [uri]) }

    it "pops the next current URI" do
      expect(processor.send(:next_uri)).to eq uri
      expect(processor.current_uris).to be_empty
    end
  end

  describe "#has_next_uri?" do
    context "with current URIs present" do
      let(:uri) { URI("http://example.com") }

      before do
        processor.instance_variable_set(:@current_uris, [uri])
      end

      it "returns `true`" do
        expect(processor.send(:has_next_uri?)).to be true
      end
    end

    context "without current URIs present" do
      before { processor.instance_variable_set(:@current_uris, []) }

      context "with staged URIs present" do
        let(:uri) { URI("http://0.0.0.0/foo") }
        before { processor.send(:stage_uri, uri) }

        it "returns `true`" do
          expect(processor.send(:has_next_uri?)).to be true
        end

        it "cycles" do
          expect(processor.send(:has_next_uri?)).to be true
          expect(processor.current_uris).to eq [uri]
          expect(processor.staged_uris).to be_empty
        end
      end

      context "without staged URIS present" do
        it "returns `false`" do
          expect(processor.send(:has_next_uri?)).to be false
        end
      end
    end
  end

  describe "#cycle" do
    let(:uri) { URI("http://0.0.0.0/foo") }
    before { processor.send(:stage_uri, uri) }

    it "sets the former staged URIs as current" do
      processor.send(:cycle)
      expect(processor.current_uris).to eq [uri]
    end

    it "empties the staged URIs" do
      processor.send(:cycle)
      expect(processor.staged_uris).to be_empty
    end
  end

  describe "#step" do
    before { processor.step }

    it "processes the current URI" do
      expect(processor.current_uris).to be_empty
    end

    it "stages the linked URIs" do
      expected_uris = %w(
        http://0.0.0.0:9876/graph/details/a.html
        http://0.0.0.0:9876/graph/details/b.html
        http://0.0.0.0:9876/status_code/400
        http://0.0.0.0:9876/status_code/403
        http://0.0.0.0:9876/status_code/404
      ).map { |str| URI(str) }
      expect(processor.staged_uris).to eq expected_uris
    end

    it "caches the processed URI" do
      expect(processor.cached_uris).to eq [entry_uri]
    end

    it "appends to `@result`" do
      expect(processor.result.count).to be 1
    end
  end

  describe "#run" do
    it "works" do
      processor.run
      expect(processor.result).to eq [
        { title: "Index" },
        { title: "Detail A" },
        { title: "Detail B" },
      ]
    end
  end

end
