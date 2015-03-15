require "spec_helpers"

describe Scrapespeare::Routing::Rule do

  describe "#initialize" do
    it "initializes the given Proc in its instance context" do
      this = nil
      rule = Rule.new { this = self }
      expect(this).to be rule
    end
  end

end
