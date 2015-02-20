require "spec_helpers"

module Scrapespeare
  describe AlterableURI do

    let(:uri) do
      AlterableURI.new(URI("http://example.com"))
    end

    describe "#method_missing" do
      it "proxies method calls to the wrapped URI" do
        expect(uri.host).to eq "example.com"
      end
    end

  end
end
