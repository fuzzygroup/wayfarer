require "spec_helpers"

describe Schablone::Extraction::Scraper do

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

  describe "#initialize" do
    context "with Proc of arity 0 given" do
      it "evaluates the Proc in its instance context" do
        this = nil
        Scraper.new { this = self }
        expect(this).to be_a Scraper
      end
    end

    context "with Proc of arity 1 given" do
      it "stores the Proc as its `@evaluator`" do
        proc = -> (nodes) {}
        scraper = Scraper.new(&proc)
        expect(scraper.evaluator).to be proc
      end
    end
  end

  describe "#extract" do
    context "with Proc of arity 0 given" do
      let(:scraper) do
        Scraper.new do
          css(:foo, "#foo")
          css(:betas, ".beta")
        end
      end

      it "returns the expected Hash structure" do
        result = scraper.extract(doc)

        expect(result).to eq({
          foo: "Foo",
          betas: %w(Lorem Ipsum Dolor Sit Amet Consetetur)
        })
      end

      it "returns a tainted Object" do
        result = scraper.extract(doc)
        expect(result).to be_tainted
      end
    end
  end

end