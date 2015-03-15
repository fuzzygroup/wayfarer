require "spec_helpers"

describe Scrapespeare::Routing::QueryRule do

  subject(:rule) { QueryRule.new(constraints) }

  describe "RegExp" do
    let(:constraints) { Hash[arg: /foo/]  }

    context "with matching query field value" do
      let(:uri) { URI("http://example.com?arg=foo") }

      it "returns `true`" do
        expect(rule.matches?(uri)).to be true
      end
    end
  end

end
