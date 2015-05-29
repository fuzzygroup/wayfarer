require "spec_helpers"

describe Schablone::Task do

  subject(:task) { Task }

  describe "::router" do
    it "works" do
      router = nil
      task = Class.new(Task) { router = self.router }
      expect(task.router).to be router
    end
  end

end