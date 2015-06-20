require "spec_helpers"

describe Schablone::Scraper do
  let!(:processor)  { Celluloid::Actor[:processor] = Processor.new }
  let!(:navigator)  { Celluloid::Actor[:navigator] = Navigator.new }
  subject(:scraper) { Scraper.new }

  describe "#scrape" do
    it "caches URIs" do
      uri = URI(test_app("/hello_world"))
      scraper.scrape(uri, Task)
      expect(navigator.cached_uris.include?(uri)).to be true
    end

    it "stages URIs" do
      task_class = Class.new(Task) do
        def foo; visit("http://example.com"); end
        route.draw(:foo, path: "/hello_world")
      end

      uri = test_app("/hello_world")
      scraper.scrape(uri, task_class)
      expect(navigator.staged_uris).to include(URI("http://example.com"))
    end
  end
end
