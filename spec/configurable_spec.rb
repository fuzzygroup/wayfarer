require "spec_helpers"

module Scrapespeare
  describe Configurable do

    let(:configurable) { Object.new.extend(Configurable) }

    describe "#config" do
      context "with @config set" do
        before { configurable.instance_variable_set(:@config, :foo) }

        it "exposes @config" do
          expect(configurable.config).to eq :foo
        end
      end

      context "without @config set" do
        it "returns a Hashie::Mash" do
          expect(configurable.config).to be_a Hashie::Mash
        end
      end

      it "allows method access" do
        configurable.config.foo = :bar
        expect(configurable.config.foo).to be :bar
      end
    end

    describe "#set" do
      it "sets keys and values" do
        configurable.set(:foo, :bar)
        expect(configurable.config.foo).to eq :bar
      end

      context "when called without a value" do
        it "sets the value to `true`" do
          configurable.set(:foo)
          expect(configurable.config.foo).to be true
        end
      end

      context "when value is a Hash" do
        it "merges @config with the Hash" do
          defaults = { alpha: 1, beta: 2, gamma: 3 }
          configurable.set(defaults)

          config = { alpha: 9, beta: 8 }
          configurable.set(config)

          expect(configurable.config.alpha).to be 9
          expect(configurable.config.beta).to be 8
          expect(configurable.config.gamma).to be 3
        end
      end
    end

  end
end
