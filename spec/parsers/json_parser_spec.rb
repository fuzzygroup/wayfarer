require "spec_helpers"

describe Wayfarer::Parsers::JSONParser do
  subject(:parser) { Parsers::JSONParser }

  describe ".parse" do
    it "returns a Hash" do
      json_str = <<-json
        {
          "id": 1,
          "name": "Foo",
          "price": 123,
          "tags": [
            "Bar",
            "Eek"
          ],
          "stock": {
            "warehouse": 300,
            "retail": 20
          }
        }
      json

      doc = parser.parse(json_str)

      expect(doc).to be_a Hash
    end
  end
end
