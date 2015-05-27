require "spec_helpers"

describe Schablone::Page do
  subject(:page) { fetch_page(test_app("/links/links.html")) }

  describe "#parsed_document" do
    context "when Content-Type is HTML" do
      it "returns a Nokogiri::HTML::Document" do
        expect(page.parsed_document).to be_a Nokogiri::HTML::Document
      end
    end

    context "when Content-Type is XML" do
      subject(:page) { fetch_page(test_app("/xml/dummy.xml")) }

      it "returns a Nokogiri::XML::Document" do
        expect(page.parsed_document).to be_a Nokogiri::XML::Document
      end
    end

    context "when Content-Type is JSON" do
      subject(:page) { fetch_page(test_app("/json/dummy.json")) }

      it "returns an OpenStruct" do
        expect(page.parsed_document).to be_an OpenStruct
      end
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

  describe "#pismo" do
    context "with Pismo required" do
      it "returns a Pismo::Document" do
        expect(page.send(:pismo)).to be_a Pismo::Document
      end
    end
  end
end
