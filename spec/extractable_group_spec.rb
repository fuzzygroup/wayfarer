require "spec_helpers"

module Scrapespeare
  describe ExtractableGroup do

    describe "#initialize" do
      let(:extractor_group) do
        Scrapespeare::ExtractableGroup.new(:foo)
      end

      it "sets @identifier" do
        expect(extractor_group.identifier).to be :foo
      end
    end

    describe "#extract" do
      let(:document) { html_fragment("<h1>Hello!</h1>") }

      let(:extractor_group) do
        Scrapespeare::ExtractableGroup.new(:foo)
      end

      let(:extractor_a) do
        extractor = double()
        allow(extractor).to receive(:extract).and_return({ alpha: "one"})
        extractor
      end

      let(:extractor_b) do
        extractor = double()
        allow(extractor).to receive(:extract).and_return({ beta: "two"})
        extractor
      end

      context "without nested Extractables" do
        it "returns a Hash with an empty value" do
          result = extractor_group.extract(document)
          expect(result).to eq({ foo: "" })
        end
      end

      context "with nested Extractables" do
        before do
          extractor_group.instance_variable_set(
            :@extractables, [extractor_a, extractor_b]
          )
        end

        it "evaluates nested Extractables" do
          result = extractor_group.extract(document)
          expect(result).to eq({
            foo: {
              alpha: "one",
              beta: "two"
            }
          })
        end
      end
    end

  end
end
