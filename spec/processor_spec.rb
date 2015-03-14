require "spec_helpers"

describe Scrapespeare::Processor do

  let(:entry_uri) { URI("http://0.0.0.0:9876/graph/index.html") }
  let(:scraper) { Scraper.new { css :title, ".title" } }
  let(:scraper_table) { Hash[foo: scraper, catch_all: scraper] }
  let(:router) do
    router = Router.new
    router.register("/foo", :foo)
    router.register("/*catch_all", :catch_all)
    router
  end

  subject(:processor) { Processor.new(entry_uri, scraper_table, router) }

  describe "#next_uri" do
    context "with current URIs present" do
      it "returns the next URI" do
        returned = processor.send(:next_uri)
        expect(returned).to be entry_uri
      end
    end
  end

end
