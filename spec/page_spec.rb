require "spec_helpers"

describe Scrapespeare::Page do

  subject(:page) do
    uri = URI("http://0.0.0.0/links.html")
    Fetcher.new.fetch()
  end

  describe "#parsed_document" do
    it "returns a parsed HTML document" do

    end
  end

end