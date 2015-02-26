require "spec_helpers"

module Scrapespeare
  describe DOMPaginator do

    let(:paginator) { DOMPaginator.new(scraper, matcher_hash) }

    describe "#paginate" do
      let(:scraper) { Scraper.new.css(:title, "title") }
      let(:matcher_hash) { { css: "li.next a" } }
      let(:uri) { URI("http://0.0.0.0:8080/paginate?page=1") }

      it "works" do
        yielded = []

       paginator.paginate(uri) do |result|
         yielded << result
       end

      
      end
    end

  end
end