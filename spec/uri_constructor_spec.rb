require "spec_helpers"

module Scrapespeare
  describe URIConstructor do

    let(:constructor) { URIConstructor }

    describe ".construct" do
      let(:base_uri) { URI("http://example.com") }

      it "returns an URI" do
        returned = constructor.construct(base_uri, "page_2")
        expect(returned.to_s).to eq "http://example.com/page_2"
      end
    end

  end
end
