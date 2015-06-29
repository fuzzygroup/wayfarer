require "spec_helpers"

describe Schablone::Processor do
  subject!(:processor) { Celluloid::Actor[:processor] = Processor.new }

  describe "#handle_future" do
    it "returns if #halted? returns true" do
      
    end
  end
end
