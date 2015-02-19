require "spec_helpers"

module Scrapespeare
  describe Scraper do

    let(:scraper) { Scraper.new }

    let(:doc) do
      Nokogiri::HTML <<-html
        <span id="foo">Foo</span>
        <span id="bar">Bar</span>

        <div class="alpha">
          <span class="beta">Lorem</span>
          <span class="beta">Ipsum</span>
        </div>

        <div class="alpha">
          <span class="beta">Dolor</span>
          <span class="beta">Sit</span>
        </div>

        <div class="alpha">
          <span class="beta">Amet</span>
          <span class="beta">Consetetur</span>
        </div>
      html
    end

    describe "#extract" do
      it "returns the expected Hash structure" do
        scraper.css(:foo, "#foo")
        scraper.css(:betas, ".beta")

        result = scraper.extract(doc)

        expect(result).to eq({
          foo: "Foo",
          betas: %w(Lorem Ipsum Dolor Sit Amet Consetetur)
        })
      end

      it "returns a tainted Object" do
        result = scraper.extract("http://example.com")
        expect(result).to be_tainted
      end
    end

  end
end