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
    let(:extractor) { Extractor.new(:foo, { css: "#foo" }, "href") }

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
        proc = -> (nodes) {}
        extractor = Extractor.new(:foo, css: "#foo", &proc)
        expect(extractor.evaluator).to be proc
      end
    end
  end

  describe "#extract" do
    context "without nested Extractables" do
      let(:extractor) { Extractor.new(:foo, css: "#foo") }

      it "evaluates matched Elements' contents" do
        result = extractor.extract(doc)
        expect(result).to eq({ foo: "Foo" })
      end
    end

    context "with nested Extractables" do
      let(:extractor) { Extractor.new(:alphas, css: ".alpha") }
      before { extractor.css(:betas, ".beta") }

      it "evaluates nested Extractables" do
        result = extractor.extract(doc)
        expect(result).to eq({
          alphas: [
            { betas: ["Lorem", "Ipsum"] },
            { betas: ["Dolor", "Sit"] },
            { betas: ["Amet", "Consetetur"] }
          ]
        })
      end
    end
  end

  describe "#evaluate" do
    let(:extractor) { Extractor.new(:beta_count, css: ".beta") }

    context "when @evaluator is a Proc" do
      let(:evaluator) do
        -> (matched_nodes, *target_attrs) { matched_nodes.count }
      end

      before { extractor.evaluator = evaluator }

      it "evaluates the matched NodeSet by calling the Proc" do
        result = extractor.extract(doc)
        expect(result).to eq({ beta_count: 6 })
      end
    end

    context "when @evaluator is not a Proc" do
      let(:evaluator) { spy() }

      before { extractor.evaluator = evaluator }

      it "calls #evaluate on @evaluator" do
        result = extractor.extract(doc)
        expect(evaluator).to have_received :evaluate
      end
    end
  end

end
