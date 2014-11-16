require "spec_helpers"

module Scrapespeare
  describe Extractable do

    let(:extractable) { Object.new.extend(Scrapespeare::Extractable) }

    describe "#extractors" do
      context "with @extractors set" do
        before { extractable.instance_variable_set(:@extractors, 42) }

        it "exposes @extractors" do
          expect(extractable.extractors).to be 42
        end
      end

      context "without @extractors set" do
        it "sets @extractors to an empty list" do
          expect(extractable.extractors).to eq []
        end
      end
    end

    describe "#add_extractor" do
      it "adds an Extractor to @nested_extractors" do
        expect {
          extractable.send(:add_extractor, :foo, { css: ".bar" })
        }.to change { extractable.extractors.count }.by(1)
      end
    end

  end
end
