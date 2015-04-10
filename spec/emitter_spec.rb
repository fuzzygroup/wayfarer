require "spec_helpers"

describe Schablone::Emitter do

  subject(:emitter) { Emitter.new }

  describe "#emit" do
    it "yields arbitrary `Object`s" do
      emitted = nil

      emitter.emit(:foo, :bar) do |a, b|
        emitted = [a, b]
      end

      expect(emitted).to eq [:foo, :bar]
    end
  end

end
