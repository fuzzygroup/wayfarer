require "spec_helpers"

describe Schablone::Worker do

  let(:scraper)       { -> () { :success } }
  let(:scraper_table) { { foo: scraper } }
  let(:router)        { Router.new(scraper_table) }
  let(:navigator)     { Navigator.new(router) }
  let(:fetcher)       { Fetcher.new }
  subject(:worker)    { Worker.new(navigator, router, fetcher) }

  before { router.map(:foo) { host("0.0.0.0") } }

  describe "#process" do
    let(:uri) { URI("http://0.0.0.0:9876/graph/index.html") }
    before { worker.send(:process, uri) }

    it "works" do
      expect(worker.result).to eq [:success]
    end

    it "stages the expected URIs" do
      expect(worker.navigator.staged_uris).to eq %w(
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
      expect(worker.navigator.cached_uris).to eq [
        URI("http://0.0.0.0:9876/graph/index.html")
      ]
    end
  end
end
