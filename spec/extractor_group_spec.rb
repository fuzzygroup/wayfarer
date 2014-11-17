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

      context "without nested Extractors" do
        it "returns the expected Hash structure" do
          result = extractor_group.extract
          expect(result).to eq({
            foobar: ""
          })
        end
      end
    end

  end
end
