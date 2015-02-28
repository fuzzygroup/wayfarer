require "spec_helpers"

module Scrapespeare
  describe DOMPaginator do

    let(:paginator) { DOMPaginator.new(scraper, matcher_hash) }

    describe "#paginate" do
      let(:scraper) { Scraper.new.css(:title, "title") }
      let(:matcher_hash) { { css: "li.next a" } }
      let(:uri) { URI("http://0.0.0.0:8080/pagination?page=1") }

      it "yields the expected extracts" do
        extracts = []
        paginator.paginate(uri) { |extract| extracts << extract }

        expect(extracts).to eq [
          { title: "Employee listing | Page 1" },
          { title: "Employee listing | Page 2" },
          { title: "Employee listing | Page 3" }
        ]
      end

      it "keeps track of visited URIs" do
        paginator.paginate(uri) { |extract| }
        expect(paginator.history).to eq %w(
          http://0.0.0.0:8080/pagination?page=1
          http://0.0.0.0:8080/pagination?page=2
          http://0.0.0.0:8080/pagination?page=3
        )
      end
    end

  end
end