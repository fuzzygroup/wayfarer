require "spec_helpers"

describe Schablone::Emitter do

  subject(:emitter) { Emitter.new }

  describe "#subscribe" do
    it "registers a listener" do
      expect {
        emitter.subscribe(&-> () {})
      }.to change { emitter.listeners.count }.by(1)
    end
  end

  describe "#emit" do
    it "calls its listeners with arbitrary arguments" do
      emitted = nil

      emitter.subscribe { |a, b| emitted = [a, b] }
      emitter.emit(:foo, :bar)

      expect(emitted).to eq [:foo, :bar]
    end
  end

end
