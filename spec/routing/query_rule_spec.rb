require "spec_helpers"

describe Scrapespeare::Routing::QueryRule do

  subject(:rule) { QueryRule.new(constraints) }

  describe "String matching constraints" do
    let(:constraints) { Hash[arg: "foo"]  }

    context "with matching query field value" do
      let(:uri) { URI("http://example.com?arg=foo") }

      it "returns `true`" do
        expect(rule.matches?(uri)).to be true
      end
    end

    context "with mismatching query field value" do
      let(:uri) { URI("http://example.com?arg=bar") }

      it "returns `false`" do
        expect(rule.matches?(uri)).to be false
      end
    end
  end

  describe "RegExp constraints" do
    let(:constraints) { Hash[arg: /foo/]  }

    context "with matching query field value" do
      let(:uri) { URI("http://example.com?arg=foo") }

      it "returns `true`" do
        expect(rule.matches?(uri)).to be true
      end
    end

    context "with mismatching query field value" do
      let(:uri) { URI("http://example.com?arg=bar") }

      it "returns `false`" do
        expect(rule.matches?(uri)).to be false
      end
    end
  end

  describe "Range constraints" do
    let(:constraints) { Hash[arg: 1..10]  }

    context "with matching query field value" do
      let(:uri) { URI("http://example.com?arg=5") }

      it "returns `true`" do
        expect(rule.matches?(uri)).to be true
      end
    end

    context "with mismatching query field value" do
      let(:uri) { URI("http://example.com?arg=11") }

      it "returns `false`" do
        expect(rule.matches?(uri)).to be false
      end
    end

    context "with non-numeric query field value" do
      let(:uri) { URI("http://example.com?arg=foo") }

      it "returns `false`" do
        expect(rule.matches?(uri)).to be false
      end
    end
  end

end
