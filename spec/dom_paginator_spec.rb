require "spec_helpers"

module Scrapespeare
  describe DOMPaginator do

    let(:paginator) { DOMPaginator.new(scraper, matcher_hash) }

    describe "#paginate" do
      let(:scraper) { Scraper.new.css(:title, "title") }
      let(:matcher_hash) { { css: "li.next a" } }

      context "with non-circular pagination" do
        let(:uri) { URI("http://0.0.0.0:8080/pagination/page_1.html") }

        it "yields the expected extracts" do
          extracts = []
          paginator.paginate(uri) { |extract| extracts << extract }

          expect(extracts).to eq [
            { title: "Employee listing | Page 1" },
            { title: "Employee listing | Page 2" },
            { title: "Employee listing | Page 3" }
          ]
        end

        it "visits the expected URIs" do
          paginator.paginate(uri) { |extract| }
          expect(paginator.history.map(&:to_s)).to eq %w(
            http://0.0.0.0:8080/pagination/page_1.html
            http://0.0.0.0:8080/pagination/page_2.html
            http://0.0.0.0:8080/pagination/page_3.html
          )
        end

        it "sets the correct halt cause" do
          paginator.paginate(uri) { |extract| }
          expect(paginator.halt_cause).to be :no_pagination_element
        end
      end

      context "with circular pagination" do
        let(:uri) { URI("http://0.0.0.0:8080/pagination_circular/page_1.html") }

        it "yields the expected extracts" do
          extracts = []
          paginator.paginate(uri) { |extract| extracts << extract }

          expect(extracts).to eq [
            { title: "Employee listing | Page 1" },
            { title: "Employee listing | Page 2" },
            { title: "Employee listing | Page 3" }
          ]
        end

        it "visits the expected URIs" do
          paginator.paginate(uri) { |extract| }
          expect(paginator.history.map(&:to_s)).to eq %w(
            http://0.0.0.0:8080/pagination_circular/page_1.html
            http://0.0.0.0:8080/pagination_circular/page_2.html
            http://0.0.0.0:8080/pagination_circular/page_3.html
          )
        end

        it "sets the correct halt cause" do
          paginator.paginate(uri) { |extract| }
          expect(paginator.halt_cause).to be :uri_already_visited
        end
      end

      context "with pagination that points to dead links" do
        let(:uri) { URI("http://0.0.0.0:8080/pagination_dead/page_1.html") }

        it "yields the expected extracts" do
          extracts = []
          paginator.paginate(uri) { |extract| extracts << extract }

          expect(extracts).to eq [
            { title: "Employee listing | Page 1" },
            { title: "Employee listing | Page 2" },
            { title: "Employee listing | Page 3" }
          ]
        end

        it "visits the expected URIs" do
          paginator.paginate(uri) { |extract| }
          expect(paginator.history.map(&:to_s)).to eq %w(
            http://0.0.0.0:8080/pagination_dead/page_1.html
            http://0.0.0.0:8080/pagination_dead/page_2.html
            http://0.0.0.0:8080/pagination_dead/page_3.html
            http://0.0.0.0:8080/pagination_dead/page_4.html
          )
        end

        it "sets the correct halt cause" do
          paginator.paginate(uri) { |extract| }
          expect(paginator.halt_cause).to be :followed_dead_link
        end
      end

      context "with ambiguous pagination element matcher" do
        let(:matcher_hash) { { css: "a" } }
        let(:uri) { URI("http://0.0.0.0:8080/pagination/page_1.html") }

        it "yields the expected extracts" do
          extracts = []
          paginator.paginate(uri) { |extract| extracts << extract }

          expect(extracts).to eq [
            { title: "Employee listing | Page 1" },
            { title: "Employee listing | Page 2" }
          ]
        end

        it "visits the expected URIs" do
          paginator.paginate(uri) { |extract| }
          expect(paginator.history.map(&:to_s)).to eq %w(
            http://0.0.0.0:8080/pagination/page_1.html
            http://0.0.0.0:8080/pagination/page_2.html
          )
        end

        it "sets the correct halt cause" do
          paginator.paginate(uri) { |extract| }
          expect(paginator.halt_cause).to be :ambiguous_pagination_element
        end
      end
    end

  end
end