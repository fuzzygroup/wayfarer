require "spec_helpers"

describe Scrapespeare::Page do

  subject(:page) do
    uri = URI("http://0.0.0.0:8080/links/links.html")
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
        http://0.0.0.0:8080/foo
        http://0.0.0.0:8080/bar
        http://0.0.0.0:8080/baz
        http://0.0.0.0:8080/links/foo
        http://0.0.0.0:8080/links/bar
        http://0.0.0.0:8080/links/baz
        http://google.com
        http://yahoo.com
        http://aol.com
      )
    end
  end

  describe "#internal_links" do
    it "returns an Array of all internal links" do
      expect(page.internal_links.map(&:to_s)).to eq %w(
        http://0.0.0.0:8080/foo
        http://0.0.0.0:8080/bar
        http://0.0.0.0:8080/baz
        http://0.0.0.0:8080/links/foo
        http://0.0.0.0:8080/links/bar
        http://0.0.0.0:8080/links/baz
      )
    end
  end

  describe "#external_links" do
    it "returns an Array of all external links" do
    end
  end

end