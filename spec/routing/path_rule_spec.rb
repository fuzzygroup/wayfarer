require "spec_helpers"

describe Schablone::Routing::PathRule do
  subject(:rule) { PathRule.new("/foo/bar") }

  describe "#===" do
    context "when Mustermann is required" do
      context "with matching URI" do
        let(:uri) { URI("http://example.com/foo/bar") }

        it "returns true" do
          expect(rule === uri).to be true
        end
      end
    end

    context "with mismatching URI" do
      let(:uri) { URI("http://example.com/bar/qux") }

      it "returns false" do
        expect(rule === uri).to be false
      end
    end
  end

  describe "#params" do
    context "when Mustermann is required" do
      require "mustermann"

      it "returns the expected parameters" do
        rule = PathRule.new("/{alpha}/{beta}")
        uri = URI("http://example.com/foo/bar")
        expect(rule.params(uri)).to eq({ "alpha" => "foo", "beta" => "bar" })
      end
    end
  end
end
