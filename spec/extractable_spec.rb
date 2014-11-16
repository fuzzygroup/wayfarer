require "spec_helpers"

module Scrapespeare
  describe Extractable do

    subject { Object.new.extend(Scrapespeare::Extractable) }

    describe "#extractors" do
      it "exposes @extractors" do
        subject.instance_variable_set(:@extractors, 42)
        expect(subject.extractors).to be 42
      end
    end

  end
end
