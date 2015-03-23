require "spec_helpers"

describe Schablone::Routing::URIRule do

  subject(:rule) { URIRule.new("http://example.com/foo/bar") }

  describe "#===" do
    context "with matching URI" do
      let(:uri) { URI("http://example.com/foo/bar") }

      it "returns `true`" do
        expect(rule === uri).to be true
      end
    end

    context "with mismatching URI" do
      let(:uri) { URI("http://example.com/foo/qux") }

      it "returns `false`" do
        expect(rule === uri).to be false
      end
    end
  end

end
