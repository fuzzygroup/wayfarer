require "spec_helpers"

module Scrapespeare
  describe Crawler do

    let(:crawler) { Crawler.new }

    describe "#http_adapter" do
      it "returns @http_adapter if set" do
        crawler.send(:http_adapter)
        adapter_a = crawler.instance_variable_get(:@http_adapter)

        crawler.send(:http_adapter)
        adapter_b = crawler.instance_variable_get(:@http_adapter)

        expect(adapter_a).to be adapter_b
      end

      context "when @options[:http_adapter] is :net_http" do
        it "initializes @http_adapter as a SeleniumAdapter" do
          crawler.options[:http_adapter] = :net_http
          crawler.send(:http_adapter)
          adapter = crawler.instance_variable_get(:@http_adapter)

          expect(adapter).to be_a Scrapespeare::HTTPAdapters::NetHTTPAdapter
        end
      end

      context "when @options[:http_adapter] is :selenium" do
        it "initializes @http_adapter as a SeleniumAdapter" do
          crawler.options[:http_adapter] = :selenium
          crawler.send(:http_adapter)
          adapter = crawler.instance_variable_get(:@http_adapter)

          expect(adapter).to be_a Scrapespeare::HTTPAdapters::SeleniumAdapter
        end
      end

      context "when @options[:http_adapter] is unsupported" do
        it "raises a RuntimeError" do
          crawler.options[:http_adapter] = :unsupported

          expect {
            adapter = crawler.send(:http_adapter)
          }.to raise_error(RuntimeError)
        end
      end
    end

    describe "#parse_html" do
      it "returns a parsed HTML document" do
        html = "<h1>Heading</h1>"
        document = crawler.send(:parse_html, html)

        expect(document).to be_a Nokogiri::HTML::Document
      end
    end

    describe "#before" do
      let(:callback) { Proc.new { 42 } }

      it "registers a callback on its HTTP adapter" do
        http_adapter = crawler.send(:http_adapter)

        crawler.send(:before, &callback)

        expect(http_adapter.callbacks[:before]).to eq [callback]
      end
    end

    describe "#after" do
      let(:callback) { Proc.new { 42 } }

      it "registers a callback on its HTTP adapter" do
        http_adapter = crawler.send(:http_adapter)

        crawler.send(:after, &callback)

        expect(http_adapter.callbacks[:after]).to eq [callback]
      end
    end

  end
end