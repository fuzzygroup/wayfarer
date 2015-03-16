require "spec_helpers"

describe Scrapespeare::Routing::Rule do

  subject(:rule) { Class.new(Rule).new }

  describe "#initialize" do
    it "evaluates the given Proc in its instance context" do
      this = nil
      rule = Rule.new { this = self }
      expect(this).to be rule
    end

    describe "Options" do
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

      context "with `:host` option present" do
        it "adds a HostRule as a sub-rule" do
          rule = Rule.new(host: "example.com")
          expect(rule.sub_rules.first).to be_a HostRule
        end
      end
    end
  end

  describe "#add_host_sub_rule" do
    it "adds a HostRule as a sub-rule" do
      rule.add_host_sub_rule "example.com"
      expect(rule.sub_rules.first).to be_a HostRule
    end

    it "returns the added HostRule" do
      expect(rule.host("example.com")).to be_a HostRule
    end
  end

  describe "#add_path_sub_rule" do
    it "adds a PathRule as a sub-rule" do
      rule.add_path_sub_rule "/foo/bar"
      expect(rule.sub_rules.first).to be_a PathRule
    end

    it "returns the added PathRule" do
      expect(rule.path("/foo/bar")).to be_a PathRule
    end
  end

  describe "#add_query_sub_rule" do
    it "adds a QueryRule as a sub-rule" do
      rule.add_query_sub_rule foo: "bar"
      expect(rule.sub_rules.first).to be_a QueryRule
    end

    it "returns the added QueryRule" do
      expect(rule.query(foo: "bar")).to be_a QueryRule
    end
  end

end
