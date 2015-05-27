require "spec_helpers"

describe Schablone::Routing::PathRule do
  subject(:rule) { PathRule.new("/foo/bar") }

  describe "#===" do
    context "with matching URI" do
      let(:uri) { URI("http://example.com/foo/bar") }

      it "returns true" do
        expect(rule === uri).to be true
      end
    end

    context "with mismatching URI" do
      let(:uri) { URI("http://example.com/foo") }

      it "returns false" do
        expect(rule === uri).to be false
      end
    end
  end

  describe "#params" do
    it "returns no parameters" do
      uri = URI("http://example.com/foo/bar")
      expect(rule.params(uri)).to eq({})
    end
  end
end
