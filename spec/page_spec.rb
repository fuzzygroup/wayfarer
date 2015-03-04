require "spec_helpers"

describe Scrapespeare::Page do

  subject(:page) do
    uri = URI("http://0.0.0.0:8080/links/only_externals.html")
    Fetcher.new.fetch(uri)
  end

  describe "#parsed_document" do
    it "returns a parsed HTML document" do
      expect(page.parsed_document).to be_a Nokogiri::HTML::Document
    end
  end

end