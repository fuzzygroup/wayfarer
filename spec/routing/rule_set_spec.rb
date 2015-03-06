require "spec_helpers"

describe Scrapespeare::Routing::RuleSet do

  subject(:rule_set) { RuleSet.new }

  describe "#<<" do
    it "stores a Rule" do
      expect {
        rule_set << "/foo"
      }.to change{ rule_set.rules.count }.by(1)
    end
  end

  describe "#allowed?" do
    before { rule_set << "/foo" }

    context "with matching URI path given" do
      it "returns `true`" do
        uri = URI("http://google.com/foo")
        expect(rule_set.allowed?(uri)).to be true
      end
    end

    context "with mismatching URI path given" do
      it "returns `true`" do
        uri = URI("http://google.com/bar")
        expect(rule_set.allowed?(uri)).to be false
      end
    end
  end

end
