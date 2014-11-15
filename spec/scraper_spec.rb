require "spec_helpers"

module Scrapespeare
  describe Scraper do

    let(:scraper) { Scrapespeare::Scraper.new }

    describe "#initialize" do
      it "sets @extractors to an empty list" do
        expect(scraper.extractors).to be_empty
      end

      it "evaluates the Proc in its instance context" do
        context = nil

        scraper = Scrapespeare::Scraper.new do
          context = self
        end

        expect(context).to be scraper
      end
    end

    describe "#add_extractor" do
      it "adds an Extractor to @extractors" do
        expect {
          scraper.add_extractor(:foo, ".bar")
        }.to change { scraper.extractors.count }.by(1)
      end

      it "initializes the added Extractor correctly" do
        scraper.add_extractor(:foo, ".bar", "class")
        extractor = scraper.extractors.first

        expect(extractor.identifier).to be :foo
        expect(extractor.selector).to eq ".bar"
        expect(extractor.target_attributes).to eq(["class"])
      end

      it "passes @options to the added Extractor" do
        scraper.set(:foobar, 42)

        scraper.add_extractor(:name, ".name")
        extractor = scraper.extractors.first

        expect(extractor.options[:foobar]).to be 42
      end
    end

    describe "#http_adapter" do
      it "returns @http_adapter if it is not nil" do
        scraper.send(:http_adapter)
        adapter_a = scraper.instance_variable_get(:@http_adapter)

        scraper.send(:http_adapter)
        adapter_b = scraper.instance_variable_get(:@http_adapter)

        expect(adapter_a).to be adapter_b
      end

      context "when @options[:http_adapter] is :net_http" do
        it "initializes @http_adapter as a SeleniumAdapter" do
          scraper.options[:http_adapter] = :net_http
          scraper.send(:http_adapter)
          adapter = scraper.instance_variable_get(:@http_adapter)

          expect(adapter).to be_a Scrapespeare::HTTPAdapters::NetHTTPAdapter
        end
      end

      context "when @options[:http_adapter] is :selenium" do
        it "initializes @http_adapter as a SeleniumAdapter" do
          scraper.options[:http_adapter] = :selenium
          scraper.send(:http_adapter)
          adapter = scraper.instance_variable_get(:@http_adapter)

          expect(adapter).to be_a Scrapespeare::HTTPAdapters::SeleniumAdapter
        end
      end

      context "when @options[:http_adapter] is unsupported" do
        it "raises a RuntimeError" do
          scraper.options[:http_adapter] = :unsupported

          expect {
            adapter = scraper.send(:http_adapter)
          }.to raise_error(RuntimeError)
        end
      end
    end

    describe "#scrape" do
      before do
        stub_request(:get, "http://example.com").to_return(
          body: "Succeeded"
        )
      end

      it "reduces its Extractors' returned #extracts to a Hash" do
        extractor_a = double()
        extractor_b = double()
        allow(extractor_a).to receive(:extract).and_return({ name: "Albert" })
        allow(extractor_b).to receive(:extract).and_return({ age: "42" })

        scraper.instance_variable_set("@extractors", [extractor_a, extractor_b])

        result = scraper.scrape("http://example.com")
        expect(result).to eq({
          name: "Albert",
          age: "42"
        })
      end

      it "returns a tainted Object" do
        result = scraper.scrape("http://example.com")
        expect(result).to be_tainted
      end
    end

    describe "#parse_html" do
      it "returns a parsed HTML document" do
        html = "<h1>Heading</h1>"
        document = scraper.send(:parse_html, html)

        expect(document).to be_a Nokogiri::HTML::Document
      end
    end

    describe "#method_missing" do
      it "adds an extractor" do
        expect {
          scraper.send(:heading, "h1")
        }.to change { scraper.extractors.count }.by(1)
      end
    end

    describe "#before" do
      let(:callback) { Proc.new { 42 } }

      it "registers a callback on its HTTP adapter" do
        http_adapter = scraper.send(:http_adapter)

        scraper.send(:before, &callback)

        expect(http_adapter.callbacks[:before]).to eq [callback]
      end
    end

  end
end