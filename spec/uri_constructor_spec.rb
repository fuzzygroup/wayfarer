require "spec_helpers"

module Scrapespeare
  describe URIConstructor do

    let(:constructor) { URIConstructor }

    describe ".construct" do
      let(:base_uri) { "http://example.com" }

      it "returns an URI" do
        constructor.construct(base_uri, )
      end
    end

  end
end
