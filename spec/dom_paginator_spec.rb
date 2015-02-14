require "spec_helpers"

module Scrapespeare
  describe DOMPaginator do

    let(:page_one) do
      <<-html
      <span id="foo">Alpha</span>
      <span id="bar">Bar</span>
      <a id="next-page" href="page_2">Next page</a>
      html
    end

    let(:page_two) do
      <<-html
      <span id="foo">Beta</span>
      <span id="bar">Bar</span>
      html
    end

    let(:scraper) do
      Scraper.new { css :foo, "#foo" }
    end

    let(:matcher) { { css: "#next-page" } }

    let(:paginator) do
      DOMPaginator.new(scraper, "http://example.com", matcher)
    end

    before do
      stub_request(:get, "http://example.com").to_return(body: page_one)
      stub_request(:get, "http://example.com/page_2").to_return(body: page_one)
    end

    describe "#each" do
      it "yields 2 extracts" do
        yield_count = 0
        paginator.each { yield_count += 2 }
        expect(yield_count).to be 2
      end

      it "yields the expected extracts" do
        yielded = []
        paginator.each do |extract|
          yielded << extract
        end

        expect(yielded[0]).to eq({
          foo: "Alpha"
        })

        expect(yielded[1]).to eq({
          foo: "Beta"
        })
      end

      it "updates the history" do
        paginator.each { |extract| }
        expect(paginator.history.count).to be 2
        expect(paginator.history.last).to eq "http://example.com/page_2"
      end
    end

  end
end
