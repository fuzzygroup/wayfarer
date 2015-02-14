require "spec_helpers"

module Scrapespeare
  describe URIConstructor do

    let(:constructor) { URIConstructor }

    describe ".construct" do
      it "returns an URI" do
        base_uri = URI("http://example.com")
        returned = constructor.construct(base_uri, "page_2")
        expect(returned.to_s).to eq "http://example.com/page_2"
      end

      it "returns an URI" do
        base_uri = URI("http://example.com")
        returned = constructor.construct(base_uri, "page_2&foo=bar")
        expect(returned.to_s).to eq "http://example.com/page_2&foo=bar"
      end

      it "returns an URI" do
        base_uri = URI("http://example.com/alpha/beta")
        returned = constructor.construct(base_uri, "/gamma")
        expect(returned.to_s).to eq "http://example.com/gamma"
      end

      it "returns an URI" do
        base_uri = URI("http://example.com/alpha/beta")
        returned = constructor.construct(base_uri, "/gamma?foo=bar")
        expect(returned.to_s).to eq "http://example.com/gamma?foo=bar"
      end

      it "returns an URI" do
        base_uri = URI("http://example.com")
        returned = constructor.construct(base_uri, "http://example.org")
        expect(returned.to_s).to eq "http://example.org"
      end
    end

  end
end
