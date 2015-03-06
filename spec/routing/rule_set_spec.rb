require "spec_helpers"

describe Scrapespeare::Routing::RuleSet do

  subject(:rule_set) { RuleSet.new }

  describe "#<<" do
    let(:rule) { Rule.new("/foo") }

    it "stores a Rule" do
      expect {
        rule_set << rule
      }.to change{ rule_set.rules.count }.by(1)
    end
  end

  describe "#allowed?" do
    let(:uri) { URI("http://example.com/foo/bar") }

    it "works" do
      expect(rule_set.allowed?(uri)).to be false
    end
  end

end
