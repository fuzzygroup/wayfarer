require "spec_helpers"

describe Schablone::Worker do
  let(:processor) { Object.new }
  let(:navigator) { Navigator.new }
  let(:uri_queue) { Queue.new }
  let(:router)    { Router.new }

  subject(:worker) do
    Worker.new(processor, navigator, uri_queue, router)
  end

  describe "#process" do
    this = nil

    it "allows accessing the current page" do
      router.register_scraper(:foo) { this = page }
      router.draw(:foo) { host("example.com") }
      worker.send(:scrape, URI("http://example.com"))
      expect(this).to be_a Page
    end

    it "allows accessing the params" do
      router.register_scraper(:foo) { this = params }
      router.draw(:foo) { path "/{foo}/{bar}" }
      worker.send(:scrape, URI("http://example.com/alpha/beta"))
      expect(this).to eq({
        "foo" => "alpha", "bar" => "beta"
      })
    end

    it "allows staging links" do
      router.register_scraper(:foo) { visit page.links }
      router.draw(:foo) { host "example.com" }
      worker.send(:scrape, URI("http://example.com"))
      expect(navigator.staged_uris.count).to be 1
    end
  end
end
