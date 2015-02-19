require "spec_helpers"

module Scrapespeare
  describe Extractor do

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
      let(:extractor) do
        Scrapespeare::Extractor.new(:foo, { css: "#foo" }, "href")
      end

      it "sets @identifier" do
        expect(extractor.identifier).to be :foo
      end

      it "sets @matcher" do
        matcher = extractor.matcher
        expect(matcher.type).to be :css
        expect(matcher.expression).to eq "#foo"
      end

      it "sets @target_attrs" do
        expect(extractor.target_attrs).to eq ["href"]
      end

      it "sets @evaluator to Scrapespeare::Evaluator" do
        expect(extractor.evaluator).to be Evaluator
      end
    end

    describe "#extract" do
      context "without nested Extractables" do
        let(:extractor) do
          Scrapespeare::Extractor.new(:foo, { css: "#foo" })
        end

        it "evaluates matched Elements' contents" do
          result = extractor.extract(doc)
          expect(result).to eq({ foo: "Foo" })
        end
      end

      context "with nested Extractables" do
        let(:extractor) do
          Scrapespeare::Extractor.new(:alphas, { css: ".alpha" })
        end

        before { extractor.css(:betas, ".beta") }

        it "evaluates nested Extractables" do
          result = extractor.extract(doc)
          expect(result).to eq({
            alphas: [
              {
                betas: ["Lorem", "Ipsum"]
              },
              {
                betas: ["Dolor", "Sit"]
              },
              {
                betas: ["Amet", "Consetetur"]
              }
            ]
          })
        end
      end
    end

    describe "#evaluate" do
      let(:extractor) do
        Scrapespeare::Extractor.new(:beta_count, { css: ".beta" })
      end

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
end
