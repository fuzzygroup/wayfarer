require "spec_helpers"

describe URI do

  let(:uri) { URI("http://example.com/?a=b&c=d#e=f") }

  describe "#parsed_query" do
    it "returns the parsed query string" do
      expect(uri.parsed_query).to eq({
        "a" => ["b"],
        "c" => ["d"]
      })
    end
  end

  describe "#parsed_query" do
    it "returns the parsed fragment string" do
      expect(uri.parsed_fragment).to eq({
        "e" => ["f"]
      })
    end
  end

end
