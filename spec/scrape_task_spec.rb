require "spec_helpers"

describe Scrapespeare::ScrapeTask do

  describe "#run" do
    let(:result) { Result.new }
    let(:uri)    { URI("http://0.0.0.0:8080/links/links.html") }

    it "works" do
      scrape_task = ScrapeTask.new(uri, result)
      scrape_task.join

      expect(result).to eq({ foo: "lel" }) 
    end
  end

end
