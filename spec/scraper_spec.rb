require "spec_helpers"

module Scrapespeare
  describe Scraper do

    let(:scraper) { Scraper.new }

    describe "#scrape" do
      let(:html) {
        <<-html
        <span class="foo">Foo</span>
        <span id="bar">Bar</span>
        html
      }

      let(:parsed_document) { Nokogiri::HTML(html) }

      it "reduces its Extractors' returned #extracts to a Hash" do
        scraper.css :foo, ".foo"
        scraper.css :bar, "#bar"

        result = scraper.scrape(parsed_document)

        expect(result).to eq({
          foo: "Foo",
          bar: "Bar"
        })
      end

      it "returns a tainted Object" do
        result = scraper.scrape("http://example.com")
        expect(result).to be_tainted
      end
    end

  end
end