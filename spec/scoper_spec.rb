require "spec_helpers"

module Scrapespeare
  describe Scoper do

    describe "#initialize" do
      let(:scoper) do
        Scoper.new(css: ".foo")
      end

      it "sets @matcher" do
        matcher = scoper.matcher
        expect(matcher.type).to be :css
        expect(matcher.expression).to eq ".foo"
      end

      it "evaluates the given block in its instance context" do
        context = nil

        scoper = Scoper.new(css: ".foo") do
          context = self
        end

        expect(context).to be scoper
      end
    end

    describe "#extract" do
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

      let(:document) do
        html_fragment <<-html
          <p>Foo</p>
          <p>Bar</p>
          <div id="scope">
            <p>Baz</p>
          </div>
        html
      end

      context "without nested Extractables" do
        it "evaluates to an empty String" do
          result = Scoper.new(css: ".foo").extract(document)
          expect(result).to eq ""
        end
      end

      context "with nested Extractables" do
        it "calls its Extractables with the correct NodeSet" do
          expected_node_set = document.css("#scope")

          scoper = Scoper.new(css: "#scope")
          scoper.instance_variable_set(
            :@extractables, [extractor_a, extractor_b]
          )

          scoper.extract(document)

          expect(extractor_a).to have_received(:extract).with(expected_node_set)
          expect(extractor_b).to have_received(:extract).with(expected_node_set)
        end
      end
    end

  end
end
