require "spec_helpers"

describe Schablone::Extraction::Scraper do
  subject(:scraper) { Scraper.new }

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
    context "without `@evaluator` Proc present" do
      let(:scraper) do
        Scraper.new do
          css(:foo, "#foo")
          css(:betas, ".beta")
        end
      end

      it "returns the expected Hash structure" do
        result = scraper.extract(doc)

        expect(result).to eq(foo: "Foo",
                             betas: %w(Lorem Ipsum Dolor Sit Amet Consetetur))
      end
    end

    context "with `@evaluator` Proc present" do
      let(:scraper) { Scraper.new { |doc| doc.css(".alpha").count } }

      it "returns the expected extract" do
        result = scraper.extract(doc)
        expect(result).to eq(3)
      end
    end
  end
end
