require "spec_helpers"

describe Schablone::Extraction::Extractor do
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
    subject(:extractor) { Extractor.new(:foo, { css: "#foo" }, "href") }

    it "sets its @key" do
      expect(extractor.key).to be :foo
    end

    it "initializes its @matcher" do
      expect(extractor.matcher.type).to be :css
      expect(extractor.matcher.expression).to eq "#foo"
    end

    it "sets its @target_attrs" do
      expect(extractor.target_attrs).to eq ["href"]
    end
  end

  describe "#extract" do
    context "without nested Extractables" do
      subject(:extractor) { Extractor.new(:foo, css: "#foo") }

      it "evaluates matched Elements' contents" do
        extract = extractor.extract(doc)
        expect(extract).to eq(foo: "Foo")
      end
    end

    context "with nested Extractables" do
      subject(:extractor) do
        extractor = Extractor.new(:alphas, css: ".alpha")
        extractor.css(:betas, ".beta")
        extractor
      end

      it "evaluates nested Extractables" do
        extract = extractor.extract(doc)
        expect(extract).to eq(alphas: [
          { betas: %w(Lorem Ipsum) },
          { betas: %w(Dolor Sit) },
          { betas: %w(Amet Consetetur) }
        ])
      end
    end
  end
end
