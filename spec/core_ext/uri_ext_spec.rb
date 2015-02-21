require "spec_helpers"

describe URIExt do

  let(:uri) { URI("http://example.com/?a=b&c=d") }

  describe "#parsed_query" do
    it "returns the parsed query string" do
      expect(uri.parsed_query).to eq({
        "a" => "b",
        "c" => "d"
      })
    end
  end

  describe "#set_query_param" do
    it "returns the query parameter's value" do
      returned = uri.set_query_param("a", "foo")
      expect(returned).to eq "foo"
    end

    context "with query parameter present" do
      it "overrides the query parameter's value" do
        uri.set_query_param("a", "foo")
        expect(uri.to_s).to eq "http://example.com/?a=foo&c=d"
      end
    end

    context "without query parameter present" do
      it "appends the query parameter" do
        uri.set_query_param "e", "f"
        expect(uri.to_s).to eq "http://example.com/?a=b&c=d&e=f"
      end
    end
  end

  describe "#get_query_param" do
    context "with query parameter present" do
      it "returns the query parameter's value" do
        expect(uri.get_query_param("a")).to eq "b"
      end
    end

    context "without query parameter present" do
      it "returns `nil`" do
        expect(uri.get_query_param("x")).to be nil
      end
    end
  end

end
