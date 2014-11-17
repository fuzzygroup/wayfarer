require "spec_helpers"

module Scrapespeare
  describe ExtractorGroup do

    describe "#initialize" do
      let(:extractor_group) do
        Scrapespeare::ExtractorGroup.new(:foobar)
      end

      it "sets @identifier" do
        expect(extractor_group.identifier).to be :foobar
      end

      it "evaluates the given block in its instance context" do
        context = nil

        extractor_group = Scrapespeare::ExtractorGroup.new(:foobar) do
          context = self
        end

        expect(context).to be extractor_group
      end
    end

    describe "#extract" do
      let(:extractor_group) do
        Scrapespeare::ExtractorGroup.new(:foobar)
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

      let(:document) { Nokogiri::HTML("<h1>Hello!</h1>") }

      context "without nested Extractors" do
        it "returns the expected Hash structure" do
          result = extractor_group.extract(document)
          expect(result).to eq({
            foobar: ""
          })
        end
      end

      context "with 1 nested Extractor" do
        before do
          extractor_group.instance_variable_set(:@extractors, [extractor_a])
        end

        it "returns the expected Hash structure" do
          result = extractor_group.extract(document)
          expect(result).to eq({
            foobar: {
              alpha: "one"
            }
          })
        end
      end

      context "with > 1 nested Extractors" do
        before do
          extractor_group.instance_variable_set(
            :@extractors, [extractor_a, extractor_b]
          )
        end

        it "returns the expected Hash structure" do
          result = extractor_group.extract(document)
          expect(result).to eq({
            foobar: {
              alpha: "one",
              beta: "two"
            }
          })
        end
      end
    end

  end
end
