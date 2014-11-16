require "spec_helpers"

module Scrapespeare
  describe Extractable do

    subject { Object.new.extend(Scrapespeare::Extractable) }

    describe "#extractors" do
      context "with @extractors set" do
        before { subject.instance_variable_set(:@extractors, 42) }

        it "exposes @extractors" do
          expect(subject.extractors).to be 42
        end
      end

      context "without @extractors set" do
        it "sets @extractors to an empty list" do
          expect(subject.extractors).to eq []
        end
      end
    end

  end
end
