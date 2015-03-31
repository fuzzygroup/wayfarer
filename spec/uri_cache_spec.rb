require "spec_helpers"

describe Schablone::URICache do
  subject(:cache) { URICache.new }

  describe "#include?" do
    context "with cached URI" do
      let(:uri) { URI("http://example.com") }
      before { cache << uri }

      it "returns `true`" do
        expect(cache).to include uri
      end
    end

    context "with non-cached URI" do
      let(:uri) { URI("http://example.com") }

      it "returns `false`" do
        expect(cache).not_to include uri
      end
    end
  end
end
