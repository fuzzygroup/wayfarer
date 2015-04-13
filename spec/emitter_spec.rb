require "spec_helpers"

describe Schablone::Emitter do

  subject(:emitter) { Emitter.new }

  describe "#subscribe" do
    it "registers a listener" do
      expect {
        emitter.subscribe(:foo, &Proc.new {})
      }.to change { emitter.listeners.count }.by(1)
    end
  end

  describe "#emit" do
    it "calls the expected listener with arbitrary arguments" do
      emitted = nil

      emitter.subscribe(:foo) { |a, b, c| emitted = [a, b, c] }
      emitter.emit(:foo, 1, 2, 3)

      expect(emitted).to eq [1, 2, 3]
    end
  end

end
