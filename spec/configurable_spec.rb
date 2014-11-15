require "spec_helpers"

module Scrapespeare
  describe Configurable do

    subject { Object.new.extend(Scrapespeare::Configurable) }

    describe "#options" do
      it "exposes @options" do
        subject.set(:foo, "bar")
        expect(subject.options[:foo]).to eq "bar"
      end
    end

    describe "#set" do
      it "sets key and value on @options" do
        subject.set(:foo, "bar")
        expect(subject.options[:foo]).to eq "bar"
      end

      context "when called without a value" do
        it "sets the value to `true` as a default" do
          subject.set(:foo)
          expect(subject.options[:foo]).to be true
        end
      end

      context "when key is a Hash" do
        it "merges the Hash with @options" do
          defaults = { alpha: 1, beta: 2, gamma: 3 }
          subject.set(defaults)

          options = { alpha: 9, beta: 8 }
          subject.set(options)

          expect(subject.options[:alpha]).to be 9
          expect(subject.options[:beta]).to be 8
          expect(subject.options[:gamma]).to be 3
        end
      end
    end

  end
end
