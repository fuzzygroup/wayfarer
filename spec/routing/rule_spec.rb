require "spec_helpers"

describe Schablone::Routing::Rule do
  subject(:rule) { Rule.new }

  describe "#initialize" do
    it "evaluates the given Proc in its instance context" do
      this = nil
      rule = Rule.new { this = self }
      expect(this).to be rule
    end
  end

  describe "#params" do
    let(:uri) { URI("http://example.com/foo/bar") }

    context "when Rule responds to :pattern" do
      subject(:rule) { Rule.new.path("/{alpha}/{beta}") }

      it "returns the expected Hash" do
        expect(rule.params(uri)).to eq({
          "alpha" => "foo", "beta" => "bar"
        })
      end
    end

    context "when Rule does not respond to :pattern" do
      subject(:rule) { Rule.new }

      it "returns an empty Hash" do
        expect(rule.params(uri)).to eq({})
      end
    end
  end

  describe "#leaf?" do
    let(:uri) { URI("http://example.com") }

    context "when Rule has child Rules" do
      subject(:rule) { Rule.new { host "example.com" } }

      it "returns false" do
        expect(rule.leaf?).to be false
      end
    end

    context "when Rule does not have child Rules" do
      subject(:rule) { Rule.new }

      it "returns true" do
        expect(rule.leaf?).to be true
      end
    end
  end

  describe "#matching_rule_chain" do
    let(:uri) { URI("http://example.com/foo/bar") }

    context "with matching Rule" do
      let(:host_rule_a) { HostRule.new("example.com") }
      let(:host_rule_b) { HostRule.new("google.com") }
      let(:path_rule_a) { PathRule.new("/{alpha}/{beta}") }
      let(:path_rule_b) { PathRule.new("/{gamma}/{delta}") }

      before do
        host_rule_a.append_child_rule(path_rule_a)
        host_rule_a.append_child_rule(path_rule_b)

        host_rule_b.append_child_rule(path_rule_a)
        host_rule_b.append_child_rule(path_rule_b)
      end

      subject(:rule) do
        rule = Rule.new
        rule.append_child_rule(host_rule_a)
        rule.append_child_rule(host_rule_b)
        rule
      end

      it "returns the expected Array" do
        expect(rule.matching_rule_chain(uri)).to eq [
          rule, host_rule_a, path_rule_a
        ]
      end
    end

    context "without matching Rule" do
      subject(:rule) do
        rule = Rule.new
        rule.host("yahoo.com")
        rule.host("google.com")
        rule
      end

      it "returns an empty Array" do
        expect(rule.matching_rule_chain(uri)).to eq []
      end
    end
  end

  describe "#params_from_rule_chain" do
    let(:uri) { URI("http://example.com/foo/bar") }

    context "with matching Rule" do
      subject(:rule_chain) do
        rule = Rule.new
        rule.host("example.com").path("/{alpha}/{beta}")
        rule.host("example.com").path("/{foo}/{bar}")
        rule.matching_rule_chain(uri)
      end

      it "returns the expected URI parameters" do
        expect(rule.params_from_rule_chain(rule_chain, uri)).to eq({
          "alpha" => "foo", "beta" => "bar"
        })
      end
    end
  end

  describe "#=~" do
    let(:uri) { URI("http://example.com/foo/bar") }

    context "with matching Rule" do
      subject(:rule) do
        rule = Rule.new
        rule.host("example.com").path("/{alpha}/{beta}")
        rule
      end

      it "returns a truthy value" do
        expect(rule =~ uri).to be_truthy
      end

      it "returns the URI parameters" do
        _, params = rule =~ uri
        expect(params).to eq({ "alpha" => "foo", "beta" => "bar" })
      end
    end

    context "with mismatching Rule" do
      subject(:rule) do
        rule = Rule.new
        rule.host("google.com").path("/{alpha}/{beta}")
        rule
      end

      it "returns false" do
        expect(rule =~ uri).to be false
      end
    end
  end

  describe "#append_uri_sub_rule, #uri" do
    it "adds a URIRule as a sub-rule" do
      rule.append_uri_sub_rule("http://example.com/foo/bar")
      expect(rule.child_rules.first).to be_a URIRule
    end

    it "returns the added URIRule" do
      expect(rule.uri("http://example.com/foo/bar")).to be_a URIRule
    end
  end

  describe "#append_host_sub_rule, #host" do
    it "adds a HostRule as a sub-rule" do
      rule.append_host_sub_rule("example.com")
      expect(rule.child_rules.first).to be_a HostRule
    end

    it "returns the added HostRule" do
      expect(rule.host("example.com")).to be_a HostRule
    end
  end

  describe "#append_path_sub_rule, #path" do
    it "adds a PathRule as a sub-rule" do
      rule.append_path_sub_rule("/foo/bar")
      expect(rule.child_rules.first).to be_a PathRule
    end

    it "returns the added PathRule" do
      expect(rule.path("/foo/bar")).to be_a PathRule
    end
  end

  describe "#append_query_sub_rule, #query" do
    it "adds a QueryRule as a sub-rule" do
      rule.append_query_sub_rule(foo: "bar")
      expect(rule.child_rules.first).to be_a QueryRule
    end

    it "returns the added QueryRule" do
      expect(rule.query(foo: "bar")).to be_a QueryRule
    end
  end

  describe "#append_child_rule_from_options" do
    subject(:rule) do
      rule = Rule.new
      rule.send(:append_child_rule_from_options, opts)
      rule
    end

    context "with `:path` option present" do
      let(:opts) { Hash[path: "/foo"] }

      it "adds a PathRule as a sub-rule" do
        expect(rule.child_rules.first).to be_a PathRule
      end
    end

    context "with `:query` option present" do
      let(:opts) { Hash[query: { bar: "qux" }] }

      it "adds a QueryRule as a sub-rule" do
        expect(rule.child_rules.first).to be_a QueryRule
      end
    end

    context "with `:host` option present" do
      let(:opts) { Hash[host: "example.com"] }

      it "adds a HostRule as a sub-rule" do
        expect(rule.child_rules.first).to be_a HostRule
      end
    end

    context "with multiple options present" do
      let(:opts) do
        Hash[host: "example.com", path: "/foo", query: { bar: "qux" }]
      end

      it "adds chained sub-rules" do
        first  = rule.child_rules.first
        second = first.child_rules.first
        third  = second.child_rules.first

        expect(first).to be_a HostRule
        expect(second).to be_a PathRule
        expect(third).to be_a QueryRule
      end
    end
  end
end
