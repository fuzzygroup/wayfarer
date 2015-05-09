require "spec_helpers"

describe Schablone::Worker do
  let(:processor)     { Object.new }
  let(:uri_queue)     { Queue.new }
  let(:router)        { Router.new }
  let(:navigator)     { Navigator.new(router) }

  subject(:worker) do
    Worker.new(processor, navigator, uri_queue, router)
  end

  describe "#process" do
    this = nil

    it "calls the Proc in a Context's instance" do
      router.register_scraper(:foo) { this = self }
      router.draw(:foo) { host("example.com") }
      worker.send(:process, URI("http://example.com"))
      expect(this).to be_a Context
    end

    it "allows accessing the current Page" do
      router.register_scraper(:foo) { this = page }
      router.draw(:foo) { host("example.com") }
      worker.send(:process, URI("http://example.com"))
      expect(this).to be_a Page
    end

    it "allows accessing the params" do
      router.register_scraper(:foo) { this = params }
      router.draw(:foo) { path "/{foo}/{bar}" }
      worker.send(:process, URI("http://example.com/alpha/beta"))
      expect(this).to eq({
        "foo" => "alpha", "bar" => "beta"
      })
    end

    it "allows staging links" do
      router.register_scraper(:foo) { visit page.links }
      router.draw(:foo) { host "example.com" }
      worker.send(:process, URI("http://example.com"))
      expect(navigator.staged_uris.count).to be 1
    end
  end
end
