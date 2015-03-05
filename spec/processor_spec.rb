require "spec_helpers"

describe Scrapespeare::Processor do

  let(:uri)           { URI("http://0.0.0.0:8080/links/links.html") }
  let(:scraper)       { Scraper.new.css(:title, "title") }
  subject(:processor) { Processor.new(uri, scraper) }

  describe "#process" do
    it "stages the expected URIs" do
      processor.process
      expect(processor.staged.map(&:to_s)).to eq %w(
        http://0.0.0.0:8080/foo
        http://0.0.0.0:8080/bar
        http://0.0.0.0:8080/baz
        http://0.0.0.0:8080/links/foo
        http://0.0.0.0:8080/links/bar
        http://0.0.0.0:8080/links/baz
      )
    end

    it "caches the processed URI" do
      processor.process
      expect(processor.cached.map(&:to_s)).to eq [
        "http://0.0.0.0:8080/links/links.html"
      ]
    end
  end

end
