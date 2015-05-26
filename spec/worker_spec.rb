require "spec_helpers"

describe Schablone::Worker do
  let(:router)     { Router.new }
  let(:processor)  { Processor.new(router) }
  let(:uri_queue)  { Queue.new }
  subject(:worker) { Worker.new(processor, uri_queue, router) }

  describe "#scrape" do
    this = nil

    it "allows accessing the current page" do
      router.register_payload(:foo) { this = page }
      router.draw(:foo) { host("example.com") }
      worker.send(:scrape, URI("http://example.com"))
      expect(this).to be_a Page
    end

    it "allows accessing the params" do
      router.register_payload(:foo) { this = params }
      router.draw(:foo) { path "/{foo}/{bar}" }
      worker.send(:scrape, URI("http://example.com/alpha/beta"))
      expect(this).to eq({
        "foo" => "alpha", "bar" => "beta"
      })
    end

    it "allows staging links" do
      router.register_payload(:foo) { visit page.links }
      router.draw(:foo) { host "example.com" }
      worker.send(:scrape, URI("http://example.com"))
      expect(processor.navigator.staged_uris.count).to be 1
    end

    it "caches scraped URIs" do
      router.register_payload(:foo) {}
      router.draw(:foo) { host "example.com" }
      worker.send(:scrape, URI("http://example.com"))
      expect(processor.navigator.cached_uris).to eq [URI("http://example.com")]
    end
  end
end
