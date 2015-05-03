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

  describe "#params_for" do
    let(:uri) { URI("http://example.com/foo/bar") }

    subject(:rule) do
      Rule.new do
        host "example.com" do
          path "/{alpha}/{beta}"
        end
      end 
    end

    it "works" do
      expect(rule.params_for(uri)).to eq({
        "alpha" => "foo", "beta" => "bar"
      })
    end
  end

  describe "#append_uri_sub_rule, #uri" do
    it "adds a URIRule as a sub-rule" do
      rule.append_uri_sub_rule("http://example.com/foo/bar")
      expect(rule.sub_rules.first).to be_a URIRule
    end

    it "returns the added URIRule" do
      expect(rule.uri("http://example.com/foo/bar")).to be_a URIRule
    end
  end

  describe "#append_host_sub_rule, #host" do
    it "adds a HostRule as a sub-rule" do
      rule.append_host_sub_rule("example.com")
      expect(rule.sub_rules.first).to be_a HostRule
    end

    it "returns the added HostRule" do
      expect(rule.host("example.com")).to be_a HostRule
    end
  end

  describe "#append_path_sub_rule, #path" do
    it "adds a PathRule as a sub-rule" do
      rule.append_path_sub_rule("/foo/bar")
      expect(rule.sub_rules.first).to be_a PathRule
    end

    it "returns the added PathRule" do
      expect(rule.path("/foo/bar")).to be_a PathRule
    end
  end

  describe "#append_query_sub_rule, #query" do
    it "adds a QueryRule as a sub-rule" do
      rule.append_query_sub_rule(foo: "bar")
      expect(rule.sub_rules.first).to be_a QueryRule
    end

    it "returns the added QueryRule" do
      expect(rule.query(foo: "bar")).to be_a QueryRule
    end
  end

  describe "#append_sub_rule_from_options" do
    subject(:rule) do
      rule = Rule.new
      rule.send(:append_sub_rule_from_options, opts)
      rule
    end

    context "with `:path` option present" do
      let(:opts) { Hash[path: "/foo"] }

      it "adds a PathRule as a sub-rule" do
        expect(rule.sub_rules.first).to be_a PathRule
      end
    end

    context "with `:query` option present" do
      let(:opts) { Hash[query: { bar: "qux" }] }

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
      let(:opts) do
        Hash[host: "example.com", path: "/foo", query: { bar: "qux" }]
      end

      it "adds chained sub-rules" do
        first  = rule.sub_rules.first
        second = first.sub_rules.first
        third  = second.sub_rules.first

        expect(first).to be_a HostRule
        expect(second).to be_a PathRule
        expect(third).to be_a QueryRule
      end
    end
  end
end
