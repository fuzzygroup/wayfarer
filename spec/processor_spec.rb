require "spec_helpers"

describe Wayfarer::Processor do
  subject!(:processor) { Processor.new }

  describe "#frontier" do
    context "when MemoryFrontier is used" do
      let(:config) do
        config = Configuration.new[:frontier] = :memory
      end

      it "returns a MemoryFrontier" do
        
      end
    end
  end
end
