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

    before { stub_request(:get, "http://example.com").to_return(body: html) }

    describe "#http_adapter" do
      after { Scrapespeare.config.reset! }

      context "when config.http_adapter is :faraday" do
        it "sets @http_adapter to a FaradayAdapter" do
          Scrapespeare.config.http_adapter = :faraday
          expect(paginator.http_adapter).to \
            be_a Scrapespeare::HTTPAdapters::FaradayAdapter
        end
      end

      context "when config.http_adapter is :selenium", live: true do
        before { WebMock.allow_net_connect! }
        after { paginator.http_adapter.release_driver }

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

    describe "#history" do
      it "is empty" do
        expect(paginator.history).to be_empty
      end
    end

    describe "#each" do
      it "yields 1 extract" do
        yield_count = 0
        paginator.each { yield_count += 1 }
        expect(yield_count).to be 1
      end

      it "yields the expected extract" do
        paginator.each do |extract|
          expect(extract).to eq({ foo: "Foo" })
        end
      end

      it "updates the history" do
        paginator.each { |extract| }
        expect(paginator.history.count).to be 1
        expect(paginator.history.last).to eq "http://example.com"
      end

      context "when config.http_adapter is :selenium", live: true do
        after { Scrapespeare.config.reset! }

        it "releases the WebDriver" do
          Scrapespeare.config.http_adapter = :selenium
          paginator.each { |extract| }
          expect(paginator.http_adapter.driver).to be nil
        end
      end
    end

  end
end
