require "spec_helpers"

describe Scrapespeare::Routing::PathRule do

  subject(:rule) { PathRule.new("/foo/bar") }

  describe "#applies_to?" do
    context "with matching URI" do
      let(:uri) { URI("http://example.com/foo/bar") }

      it "returns `true`" do
        expect(rule.applies_to?(uri)).to be true
      end
    end

    context "with mismatching URI" do
      let(:uri) { URI("http://example.com/bar/qux") }

      it "returns `false`" do
        expect(rule.applies_to?(uri)).to be false
      end
    end
  end

end
