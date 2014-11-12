require "spec_helpers"

describe Scrapespeare::Configurable do

  let(:configurable) { Object.new.extend(Scrapespeare::Configurable) }

  describe "#options" do
    it "exposes @options" do
      configurable.set(:foo, "bar")
      expect(configurable.options[:foo]).to eq "bar"
    end
  end

  describe "#set" do
    it "sets key and value on @options" do
      configurable.set(:foo, "bar")
      expect(configurable.options[:foo]).to eq "bar"
    end

    context "when called without a value" do
      it "sets the value to `true` as a default" do
        configurable.set(:foo)
        expect(configurable.options[:foo]).to be true
      end
    end

    context "when key is a Hash" do
      it "merges the Hash with @options" do
        defaults = { alpha: 1, beta: 2, gamma: 3 }
        configurable.set(defaults)

        options = { alpha: 9, beta: 8 }
        configurable.set(options)

        expect(configurable.options[:alpha]).to be 9
        expect(configurable.options[:beta]).to be 8
        expect(configurable.options[:gamma]).to be 3
      end
    end
  end

end
