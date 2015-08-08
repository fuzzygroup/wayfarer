require "spec_helpers"

describe Wayfarer::Routing::ParameterizedPathRule, mri: true do
  subject(:rule) { ParameterizedPathRule.new("/{alpha}/{beta}") }

  describe "#===" do
    context "with matching URI" do
      let(:uri) { URI("http://example.com/foo/bar") }

      it "returns true" do
        expect(rule === uri).to be true
      end
    end
  end

  context "with mismatching URI" do
    let(:uri) { URI("http://example.com/foo") }

    it "returns false" do
      expect(rule === uri).to be false
    end
  end

  describe "#params" do
    it "returns the expected parameters" do
      uri = URI("http://example.com/foo/bar")
      expect(rule.params(uri)).to eq({ "alpha" => "foo", "beta" => "bar" })
    end
  end
end
