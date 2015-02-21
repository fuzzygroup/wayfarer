require "spec_helpers"

describe URI do

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

  describe "#increment_query_param" do
    context "without query parameter present" do
      let(:uri) { URI("http://example.com") }

      it "appends the query parameter with value `2`" do
        uri.increment_query_param("page")
        expect(uri.to_s).to eq "http://example.com?page=2"
      end
    end

    context "when parameter value can be converted to an Integer" do
      let(:uri) { URI("http://example.com/?page=42") }

      it "increments the parameter value" do
        uri.increment_query_param("page")
        expect(uri.to_s).to eq "http://example.com/?page=43"
      end

      it "accepts a custom increment value" do
        uri.increment_query_param("page", 5)
        expect(uri.to_s).to eq "http://example.com/?page=47"
      end
    end

    context "when parameter value can not be converted to an Integer" do
      let(:uri) { URI("http://example.com/?page=foobar") }

      it "raises an ArgumentError" do
        expect {
          uri.increment_query_param("page")
        }.to raise_error(ArgumentError)
      end
    end
  end

end
