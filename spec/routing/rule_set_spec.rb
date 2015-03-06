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

end
