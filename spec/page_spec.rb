# frozen_string_literal: true
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

  describe "Forwarding" do
    it "forwards calls to Pismo" do
      Pismo::Document::ATTRIBUTE_METHODS.each do |method|
        expect(page).to respond_to(method)
      end
    end
  end
end
