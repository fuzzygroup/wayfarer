require "spec_helpers"

describe Scrapespeare::Routing::Rule do

  subject(:rule) { Rule.new }

  describe "#initialize" do
    it "evaluates the given Proc in its instance context" do
      this = nil
      rule = Rule.new { this = self }
      expect(this).to be rule
    end
  end

  describe "#add_uri_sub_rule, #uri" do
    it "adds a URIRule as a sub-rule" do
      rule.add_uri_sub_rule("http://example.com/foo/bar")
      expect(rule.sub_rules.first).to be_a URIRule
    end

    it "returns the added URIRule" do
      expect(rule.uri("http://example.com/foo/bar")).to be_a URIRule
    end
  end

  describe "#add_host_sub_rule, #host" do
    it "adds a HostRule as a sub-rule" do
      rule.add_host_sub_rule("example.com")
      expect(rule.sub_rules.first).to be_a HostRule
    end

    it "returns the added HostRule" do
      expect(rule.host("example.com")).to be_a HostRule
    end
  end

  describe "#add_path_sub_rule, #path" do
    it "adds a PathRule as a sub-rule" do
      rule.add_path_sub_rule("/foo/bar")
      expect(rule.sub_rules.first).to be_a PathRule
    end

    it "returns the added PathRule" do
      expect(rule.path("/foo/bar")).to be_a PathRule
    end
  end

  describe "#add_query_sub_rule, #query" do
    it "adds a QueryRule as a sub-rule" do
      rule.add_query_sub_rule(foo: "bar")
      expect(rule.sub_rules.first).to be_a QueryRule
    end

    it "returns the added QueryRule" do
      expect(rule.query(foo: "bar")).to be_a QueryRule
    end
  end

  describe "#add_sub_rule_from_options" do
    subject(:rule) do
      rule = Rule.new
      rule.send(:add_sub_rule_from_options, opts)
      rule
    end 

    context "with `:path` option present" do
      let(:opts) { Hash[path: "/foo"] }

      it "adds a PathRule as a sub-rule" do
        expect(rule.sub_rules.first).to be_a PathRule
      end
    end

    context "with `:query` option present" do
      let(:opts) { Hash[query: { foo: "bar" }] }

      it "adds a QueryRule as a sub-rule" do
        expect(rule.sub_rules.first).to be_a QueryRule
      end
    end

    context "with `:host` option present" do
      let(:opts) { Hash[host: "example.com"] }

      it "adds a HostRule as a sub-rule" do
        expect(rule.sub_rules.first).to be_a HostRule
      end
    end

    context "with multiple options present" do
    end
  end

end
