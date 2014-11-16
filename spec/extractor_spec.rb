require "spec_helpers"

module Scrapespeare
  describe Extractor do

    let(:html) do
      <<-html
        <h1>Employees</h1>
        <a href="/signup" class="sign-up">Sign up today!</a>
        <ul class="employees">
          <li class="employee" id="albert">
            <span class="name">Albert</span>
            <span class="age">18</span>
          </li>
          <li class="employee" id="bertolt">
            <span class="name">Bertolt</span>
            <span class="age">20</span>
          </li>
        </ul>
      html
    end

    let(:document) { Nokogiri::HTML(html) }

    describe "#initialize" do
      let(:extractor) do
        Scrapespeare::Extractor.new(:heading, { css: "h1" }, "class")
      end

      it "sets @identifier" do
        expect(extractor.identifier).to be :heading
      end

      it "sets @matcher" do
        matcher = extractor.matcher
        expect(matcher.type).to be :css
        expect(matcher.expression).to eq "h1"
      end

      it "sets @target_attributes" do
        expect(extractor.target_attributes).to eq ["class"]
      end

      it "sets @options to an empty Hash" do
        expect(extractor.options).to eq({})
      end

      it "references Scrapespeare::Evaluator as @evaluator" do
        evaluator = extractor.instance_variable_get(:@evaluator)
        expect(evaluator).to be Scrapespeare::Evaluator
      end

      it "evaluates the given block in its instance context" do
        context = nil

        extractor = Scrapespeare::Extractor.new(:heading, { css: "h1" }) do
          context = self
        end

        expect(context).to be extractor
      end
    end

    describe "#extract" do
      let(:extractor) do
        Scrapespeare::Extractor.new(:employees, { css: ".employee" })
      end

      context "with 1 extractor and 1 nested Extractor" do
        before do
          extractor.send(:add_extractor, :name, { css: ".name" })
        end

        it "returns the expected data structure" do
          result = extractor.extract(document)
          expect(result).to eq({
            :employees => [
              { :name => "Albert" },
              { :name => "Bertolt" },
            ]
          })
        end
      end

      context "with 1 extractor and 2 nested Extractors" do
        before do
          extractor.send(:add_extractor, :name, { css: ".name" })
          extractor.send(:add_extractor, :age, { css: ".age" })
        end

        it "returns the expected data structure" do
          result = extractor.extract(document)
          expect(result).to eq({
            :employees => [
              { :name => "Albert", :age => "18" },
              { :name => "Bertolt", :age => "20" },
            ]
          })
        end
      end

      context "with 1 extractor and deep-nested nested Extractors" do
        let(:extractor) do
          extractor = Scrapespeare::Extractor.new(
            :employees, { css: ".employees" }
          )
        end

        before do
          extractor.send(:add_extractor, :albert, { css: "#albert" })

          nested_extractor = extractor.extractors.first
          nested_extractor.send(:add_extractor, :name, { css: ".name" })
          nested_extractor.send(:add_extractor, :age, { css: ".age" })
        end

        it "returns the expected data structure" do
          result = extractor.extract(document)
          expect(result).to eq({
            :employees => [
              :albert => [
                { name: "Albert", age: "18" }
              ]
            ]
          })
        end
      end
    end

    describe "#query" do
      let(:extractor) { Scrapespeare::Extractor.new(:heading, { css: "h1" }) }
      let(:matcher) { spy("matcher") }

      before do
        extractor.instance_variable_set(:@matcher, matcher)
      end

      it "calls #match on @matcher and passes its argument" do
        extractor.send(:query, document)
        expect(matcher).to have_received(:match).with(document)
      end
    end

    describe "#evaluate" do
      let(:extractor) { Scrapespeare::Extractor.new(:heading, { css: "h1" }) }
      let(:nodes) { node_set "<em class='greeting'>Hello!</em>" }

      it "calls @evaluator#evaluate" do
        evaluator = spy("evaluator")
        extractor.instance_variable_set(:@evaluator, evaluator)

        extractor.send(:evaluate, nodes)

        expect(evaluator).to have_received(:evaluate)
      end

      it "passes @target_attributes to @evaluator" do
        extractor = Scrapespeare::Extractor.new(
          :heading, { css: "h1" }, "class"
        )

        evaluator = spy("evaluator")
        extractor.instance_variable_set(:@evaluator, evaluator)

        extractor.send(:evaluate, nodes)

        expect(evaluator).to have_received(:evaluate).with(
          nodes, "class"
        )
      end
    end

  end
end
