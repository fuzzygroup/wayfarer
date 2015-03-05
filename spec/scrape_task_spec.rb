require "spec_helpers"

describe Scrapespeare::ScrapeTask do

  describe "#run" do
    let(:uri)      { URI("http://0.0.0.0:8080/links/links.html") }
    let(:scraper)  { Scraper.new.css(:title, "title") }
    let(:result)   { Result.new }
    subject(:task) { ScrapeTask.new(uri, scraper, result) }

    before { task.join }

    it "works" do
      expect(result.to_h).to eq({ title: "Things" }) 
    end
  end

end
