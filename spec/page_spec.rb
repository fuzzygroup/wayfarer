require "spec_helpers"

describe Scrapespeare::Page do

  subject(:page) do
    uri = URI("http://0.0.0.0:9876/links/links.html")
    Fetcher.new.fetch(uri)
  end

  describe "#parsed_document" do
    it "returns a parsed HTML document" do
      expect(page.parsed_document).to be_a Nokogiri::HTML::Document
    end
  end

  describe "#links" do
    it "returns an Array of all links" do
      expect(page.links.map(&:to_s)).to eq %w(
        http://0.0.0.0:9876/foo
        http://0.0.0.0:9876/bar
        http://0.0.0.0:9876/baz
        http://0.0.0.0:9876/links/foo
        http://0.0.0.0:9876/links/bar
        http://0.0.0.0:9876/links/baz
        http://google.com
        http://yahoo.com
        http://aol.com
      )
    end
  end

end