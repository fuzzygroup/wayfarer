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

    it "sets `@key`" do
      expect(extractor.key).to be :foo
    end

    it "initializes `@matcher`" do
      matcher = extractor.matcher
      expect(matcher.type).to be :css
      expect(matcher.expression).to eq "#foo"
    end

    it "sets `@target_attrs`" do
      expect(extractor.target_attrs).to eq ["href"]
    end

    context "with Proc of arity 0 given" do
      it "evaluates the Proc in its instance context" do
        this = nil
        Extractor.new(:foo, css: "#foo") { this = self }
        expect(this).to be_an Extractor
      end

      it "stores `Schablone::Extraction::Evaluator` as its `@evaluator`" do
        expect(extractor.evaluator).to be Evaluator
      end
    end

    context "with Proc of arity 1 given" do
      it "stores the Proc as its `@evaluator`" do
        proc = -> (_nodes) {}
        extractor = Extractor.new(:foo, css: "#foo", &proc)
        expect(extractor.evaluator).to be proc
      end
    end
  end

  describe "#extract" do
    context "without nested Extractables" do
      subject(:extractor) { Extractor.new(:foo, css: "#foo") }

      it "evaluates matched Elements' contents" do
        result = extractor.extract(doc)
        expect(result).to eq(foo: "Foo")
      end
    end

    context "with nested Extractables" do
      subject(:extractor) do
        extractor = Extractor.new(:alphas, css: ".alpha")
        extractor.css(:betas, ".beta")
        extractor
      end

      it "evaluates nested Extractables" do
        result = extractor.extract(doc)
        expect(result).to eq(alphas: [
          { betas: %w(Lorem Ipsum) },
          { betas: %w(Dolor Sit) },
          { betas: %w(Amet Consetetur) }
        ])
      end
    end
  end

  describe "#evaluate" do
    let(:extractor) { Extractor.new(:beta_count, css: ".beta") }

    context "when `@evaluator` is a Proc" do
      let(:proc) { -> (matched_nodes) { matched_nodes.count } }
      subject(:extractor) { Extractor.new(:alpha_count, css: ".alpha", &proc) }

      it "calls `@evaluator` and returns its value" do
        result = extractor.extract(doc)
        expect(result).to eq(alpha_count: 3)
      end
    end
  end
end
