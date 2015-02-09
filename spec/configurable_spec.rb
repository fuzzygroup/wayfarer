require "spec_helpers"

module Scrapespeare
  describe Configurable do

    let(:configurable) { Object.new.extend(Scrapespeare::Configurable) }

    describe "#options" do
      context "with @options set" do
        before { configurable.instance_variable_set(:@options, "set") }

        it "exposes @options" do
          expect(configurable.options).to eq "set"
        end
      end

      context "without @options set" do
        it "sets @extractables to an empty Hash" do
          expect(configurable.options).to eq({})
        end
      end

      it "allows method access to values" do
        configurable.options.foo = :bar
        expect(configurable.options.foo).to be :bar
      end
    end

    describe "#set" do
      it "sets key and value on @options" do
        configurable.set(:foo, "bar")
        expect(configurable.options[:foo]).to eq "bar"
      end

      context "when called without a value" do
        it "sets the value to `true`" do
          configurable.set(:foo)
          expect(configurable.options[:foo]).to be true
        end
      end

      context "when value is a Hash" do
        it "merges the @options with the Hash" do
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
end
