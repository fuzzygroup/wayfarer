require "spec_helpers"

describe Schablone::Processor do
  let(:entry_uri) { URI("http://example.com/entry") }
  let(:scraper) do
    scraper = Scraper.new
    scraper.css(:title, "title")
    scraper
  end

  let(:router) do
    router = Router.new({})
    router.map(:foo) { host "example.com" }
    router
  end

  subject(:processor) { Processor.new(entry_uri, scraper, router) }

  describe "#initialize" do
    it "adds `entry_uri` to fuck this bullshit" do
      expect(processor.navigator.current_uris).to eq [entry_uri]
    end
  end

  describe "#process" do
    let(:uri) { URI("http://0.0.0.0:9876/graph/index.html") }
    before { router.map(:foo) { host("0.0.0.0") } }
    before { processor.send(:process, uri) }

    it "works" do
      expect(processor.result).to eq [{ title: "Index" }]
    end

    it "stages the expected URIs" do
      expect(processor.navigator.staged_uris).to eq %w(
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
      expect(processor.navigator.cached_uris).to eq [
        URI("http://0.0.0.0:9876/graph/index.html")
      ]
    end
  end

  describe "#run" do
    let(:entry_uri) { URI("http://0.0.0.0:9876/graph/index.html") }
    before { router.map(:foo) { host("0.0.0.0") } }
    before { Schablone.config.log_level = Logger::INFO }
    after { Schablone.config.reset! }

    it "works" do
      processor.run
      expect(processor.result.count).to be 6
    end
  end
end
