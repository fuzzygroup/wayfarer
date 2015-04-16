require "spec_helpers"

describe Schablone::Page do
  subject(:page) { fetch_page(test_app("/links/links.html")) }

  describe "#parsed_document" do
    it "returns a parsed HTML document" do
      expect(page.parsed_document).to be_a Nokogiri::HTML::Document
    end
  end

  describe "#links" do
    context "without matcher hash" do
      it "returns all links" do
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

    context "with matcher hash" do
      it "returns targeted links" do
        expect(page.links(css: "ul li:first-child a").map(&:to_s)).to eq %w(
          http://0.0.0.0:9876/foo
        )
      end
    end
  end
end
