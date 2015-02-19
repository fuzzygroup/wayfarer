require "spec_helpers"

module Scrapespeare
  describe Extractor do

    let(:doc) do
      Nokogiri::HTML <<-html
        <span id="foo">Foo</span>
        <span id="bar">Bar</span>

        <div class="alpha">
          <span class="beta">Lorem</span>
          <span class="beta">Ipsum</span>
        </div>

        <div class="alpha">
          <span class="beta">Dolor</span>
          <span class="beta">Sit</span>
        </div>

        <div class="alpha">
          <span class="beta">Amet</span>
          <span class="beta">Consetetur</span>
        </div>
      html
    end

    describe "#initialize" do
      let(:extractor) do
        Scrapespeare::Extractor.new(:foo, { css: ".bar" }, "href")
      end

      it "sets @identifier" do
        expect(extractor.identifier).to be :foo
      end

      it "sets @matcher" do
        matcher = extractor.matcher
        expect(matcher.type).to be :css
        expect(matcher.expression).to eq ".bar"
      end

      it "sets @target_attrs" do
        expect(extractor.target_attrs).to eq ["href"]
      end
    end

    describe "#extract" do
      context "without nested Extractables" do
        let(:extractor) do
          Scrapespeare::Extractor.new(:foo, { css: "#foo" })
        end

        it "evaluates matched Elements' contents" do
          result = extractor.extract(doc)
          expect(result).to eq({ foo: "Foo" })
        end
      end

      context "with nested Extractables" do
        let(:extractor) do
          Scrapespeare::Extractor.new(:alphas, { css: ".alpha" })
        end

        before { extractor.css(:betas, ".beta") }

        it "evaluates nested Extractables" do
          result = extractor.extract(doc)
          expect(result).to eq({
            alphas: [
              {
                betas: ["Lorem", "Ipsum"]
              },
              {
                betas: ["Dolor", "Sit"]
              },
              {
                betas: ["Amet", "Consetetur"]
              }
            ]
          })
        end
      end
    end

  end
end
