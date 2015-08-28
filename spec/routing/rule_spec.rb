require "spec_helpers"

describe Wayfarer::Routing::Rule do
  subject(:rule) { Rule.new }

  describe "#initialize" do
    it "evaluates the Proc in its instance context" do
      this = nil
      rule = Rule.new { this = self }
      expect(this).to be rule
    end

    it "builds the expected Rule chain from options" do
      rule = Rule.new(host: "example.com", query: { bar: 42 })

      first  = rule.child_rules.first
      second = first.child_rules.first
      third  = second.child_rules.first

      expect(first).to be_a HostRule
      expect(second).to be_a QueryRule
    end
  end

  describe "#params" do
    it "returns an empty Hash" do
      expect(rule.params(URI("http://example.com"))).to eq({})
    end
  end

  describe "#matching_rule_chain" do
    let(:uri) { URI("http://example.com/foo/bar") }

    context "with matching Rule" do
      let(:host_rule_a) { HostRule.new("example.com") }
      let(:host_rule_b) { HostRule.new("google.com") }
      let(:path_rule_a) { ParameterizedPathRule.new("/{alpha}/{beta}") }
      let(:path_rule_b) { ParameterizedPathRule.new("/{gamma}/{delta}") }

      before do
        host_rule_a.send(:append_child_rule, path_rule_a)
        host_rule_a.send(:append_child_rule, path_rule_b)

        host_rule_b.send(:append_child_rule, path_rule_a)
        host_rule_b.send(:append_child_rule, path_rule_b)
      end

      subject(:rule) do
        rule = Rule.new
        rule.send(:append_child_rule, host_rule_a)
        rule.send(:append_child_rule, host_rule_b)
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
        expect(rule.send(:params_from_rule_chain, rule_chain, uri)).to eq("alpha" => "foo", "beta" => "bar")
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
        expect(params).to eq("alpha" => "foo", "beta" => "bar")
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

  describe "#uri" do
    it "adds a URIRule as a sub-rule" do
      rule.uri("http://example.com/foo/bar")
      expect(rule.child_rules.first).to be_a URIRule
    end

    it "returns the added URIRule" do
      expect(rule.uri("http://example.com/foo/bar")).to be_a URIRule
    end
  end

  describe "#host" do
    it "adds a HostRule as a sub-rule" do
      rule.host("example.com")
      expect(rule.child_rules.first).to be_a HostRule
    end

    it "returns the added HostRule" do
      expect(rule.host("example.com")).to be_a HostRule
    end
  end

  describe "#path" do
    context "when Mustermann is required" do
      it "adds a ParameterizedPathRule as a sub-rule" do
        rule.path("/foo/bar")
        expect(rule.child_rules.first).to be_a ParameterizedPathRule
      end

      it "returns the added Parameterized" do
        expect(rule.path("/foo/bar")).to be_a ParameterizedPathRule
      end
    end

    context "when Mustermann is not required" do
      it "adds a PathRule as a sub-rule" do
        hide_const(Mustermann) do
          rule.path("/foo/bar")
          expect(rule.child_rules.first).to be_a PathRule
        end
      end

      it "returns the added PathRule" do
        hide_const(Mustermann) do
          expect(rule.path("/foo/bar")).to be_a PathRule
        end
      end
    end
  end

  describe "#query" do
    it "adds a QueryRule as a sub-rule" do
      rule.query(foo: "bar")
      expect(rule.child_rules.first).to be_a QueryRule
    end

    it "returns the added QueryRule" do
      expect(rule.query(foo: "bar")).to be_a QueryRule
    end
  end

  describe "#build_child_rule_chain_from_options" do
    subject(:rule) do
      rule = Rule.new
      rule.build_child_rule_chain_from_options(opts)
      rule
    end

    describe ":path option" do
      let(:opts) { { path: "/foo" } }

      it "adds a PathRule/Parameter" do
        expect(rule.child_rules.first).to be_a ParameterizedPathRule
      end
    end

    describe ":query option" do
      let(:opts) { { query: { bar: "qux" } } }

      it "adds a QueryRule" do
        expect(rule.child_rules.first).to be_a QueryRule
      end
    end

    describe ":host option" do
      let(:opts) { { host: "example.com" } }

      it "adds a HostRule" do
        expect(rule.child_rules.first).to be_a HostRule
      end
    end

    context "with multiple options present" do
      let(:opts) do
        { host: "example.com", path: "/foo", query: { bar: "qux" } }
      end

      it "adds chained sub-rules" do
        first  = rule.child_rules.first
        second = first.child_rules.first
        third  = second.child_rules.first

        expect(first).to be_a HostRule
        expect(second).to be_a ParameterizedPathRule
        expect(third).to be_a QueryRule
      end
    end
  end
end
