require "spec_helpers"

describe Scrapespeare::Routing::Rule do

  subject(:rule) { Class.new(Rule).new }

  describe "#initialize" do
    it "evaluates the given Proc in its instance context" do
      this = nil
      rule = Rule.new { this = self }
      expect(this).to be rule
    end
  end

  describe "#host" do
    it "adds a HostRule as a sub-rule" do
      rule.host "example.com"
      expect(rule.sub_rules.first).to be_a HostRule
    end
  end

  describe "#path" do
    it "adds a PathRule as a sub-rule" do
      rule.path "foo/bar"
      expect(rule.sub_rules.first).to be_a PathRule
    end
  end

  describe "#query" do
    it "adds a QueryRule as a sub-rule" do
      rule.query foo: "bar"
      expect(rule.sub_rules.first).to be_a QueryRule
    end
  end

  describe "#add_sub_rules_from_options" do
    context "with `:path` option present" do
      it "adds a PathRule as a sub-rule" do
        rule = Rule.new(path: "/foo")
        expect(rule.sub_rules.first).to be_a PathRule
      end
    end

    context "with `:query` option present" do
      it "adds a QueryRule as a sub-rule" do
        rule = Rule.new(query: { foo: "bar", baz: 42 })
        expect(rule.sub_rules.first).to be_a QueryRule
      end
    end
  end

end
