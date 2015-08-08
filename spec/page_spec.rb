require "spec_helpers"

describe Wayfarer::Page do
  subject(:page) { fetch_page(test_app("/links/links.html")) }

  describe "#doc" do
    context "when Content-Type is HTML" do
      it "returns a Nokogiri::HTML::Document" do
        expect(page.doc).to be_a Nokogiri::HTML::Document
      end
    end

    context "when Content-Type is XML" do
      subject(:page) { fetch_page(test_app("/xml/dummy.xml")) }

      it "returns a Nokogiri::XML::Document" do
        expect(page.doc).to be_a Nokogiri::XML::Document
      end
    end

    context "when Content-Type is JSON" do
      subject(:page) { fetch_page(test_app("/json/dummy.json")) }

      it "returns an OpenStruct" do
        expect(page.doc).to be_an OpenStruct
      end
    end
  end

  describe "#links" do
    context "without path" do
      it "returns all links" do
        expect(page.links("a").map(&:to_s)).to eq %w(
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

    context "with paths" do
      it "returns selected links" do
        expect(page.links("ul li:nth-child(3) a").map(&:to_s)).to eq %w(
          http://0.0.0.0:9876/baz
        )
      end
    end
  end

  describe "#pismo", mri: true do
    it "returns a Pismo::Document" do
      expect(page.send(:pismo)).to be_a Pismo::Document
    end
  end
end
