require "spec_helpers"

module Scrapespeare
  describe Paginator do

    let(:html) do
      <<-html
      <span id="foo">Foo</span>
      <span id="bar">Bar</span>
      html
    end

    let(:scraper) do
      Scraper.new { css :foo, "#foo" }
    end

    let(:paginator) do
      Paginator.new(scraper, "http://example.com")
    end

    describe "#http_adapter" do
      before { Scrapespeare.config.reset! }

      context "when config.http_adapter is :net_http" do
        it "sets @http_adapter to a NetHTTPAdapter" do
          Scrapespeare.config.http_adapter = :net_http
          expect(paginator.http_adapter).to \
            be_a Scrapespeare::HTTPAdapters::NetHTTPAdapter
        end
      end

      context "when config.http_adapter is :selenium" do
        it "sets @http_adapter to a SeleniumAdapter" do
          Scrapespeare.config.http_adapter = :selenium
          expect(paginator.http_adapter).to \
            be_a Scrapespeare::HTTPAdapters::SeleniumAdapter
        end
      end

      context "when config.http_adapter is unrecognized" do
        it "raises a RuntimeError" do
          Scrapespeare.config.http_adapter = :unrecognized
          expect { paginator.http_adapter }.to raise_error(RuntimeError)
        end
      end
    end

    describe "#parse_html" do
      it "returns a parsed HTML document" do
        html = "<h1>Heading</h1>"
        document = paginator.send(:parse_html, html)

        expect(document).to be_a Nokogiri::HTML::Document
      end
    end
  end
end
