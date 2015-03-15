require "spec_helpers"

describe Scrapespeare::Processor do

  let(:entry_uri) { URI("http://0.0.0.0:9876/graph/index.html") }
  let(:scraper) { Scraper.new { css :title, ".title" } }
  let(:scraper_table) { Hash[foo: scraper, catch_all: scraper] }
  let(:router) do
    router = Router.new
    router.register("/foo", :foo)
    router
  end

  subject(:processor) { Processor.new(entry_uri, scraper_table, router) }

  describe "#next_uri" do
    it "returns the next URI" do
      returned = processor.send(:next_uri)
      expect(returned).to be entry_uri
    end
  end

  describe "#stage_uris" do
    it "stages the URIs for processing" do
      uris = %w(
        http://example.com/foo
        http://example.com/bar
      ).map { |str| URI(str) }

      processor.send(:stage_uris, uris)
      expect(processor.instance_variable_get(:@staged_uris)).to eq uris
    end
  end

  describe "#cache_uri" do
    it "caches a URI" do
      uri = URI("http://example.com")
      processor.send(:cache_uri, uri)
      expect(processor.cached_uris).to eq [uri]
    end
  end

  describe "#cycle" do
    before { processor.instance_variable_set(:@staged_uris, [1, 2, 3]) }

    it "sets the staged URIs as current" do
      processor.send(:cycle)
      expect(processor.current_uris).to eq [1, 2, 3]
    end

    it "empties the staged URIs" do
      processor.send(:cycle)
      expect(processor.staged_uris).to be_empty
    end

    it "increments `@depth`" do
      processor.send(:cycle)
      expect(processor.depth).to be 1
    end
  end

  describe "#recognized_links" do
    it "filters all URIs not recognized by the Router" do
      uris = %w(
        http://example.com/foo
        http://example.com/baz
        http://example.com/qux
      ).map { |str| URI(str) }

      returned = processor.send(:recognized_links, uris)
      expect(returned).to eq [URI("http://example.com/foo")]
    end
  end

end
