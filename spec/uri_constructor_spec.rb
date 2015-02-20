require "spec_helpers"

module Scrapespeare
  describe URIConstructor do

    let(:constructor) { URIConstructor }

    describe ".absolute_path" do
      let(:base_uri) { "http://example.com" }

      context "with absolute path given" do
        it "returns the absolute path" do
          uri = constructor.absolute_uri(base_uri, "http://mozilla.org")
          expect(uri).to eq "http://mozilla.org"
        end
      end

      context "with relative path given" do
        it "returns the absolute path" do
          uri = constructor.absolute_uri(base_uri, "http://mozilla.org")
          expect(uri).to eq "http://mozilla.org"
        end
      end
    end

  end
end
