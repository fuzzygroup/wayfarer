require "spec_helpers"

module Scrapespeare
  describe Extractor do

    let(:document) { Nokogiri::HTML(dummy_html("index.html")) }

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

      it "sets @target_attributes" do
        expect(extractor.target_attributes).to eq ["href"]
      end

      it "evaluates the Proc in its instance context" do
        context = nil

        extractor = Scrapespeare::Extractor.new(:heading, { css: "h1" }) do
          context = self
        end

        expect(context).to be extractor
      end
    end

    describe "#extract" do
      let(:extractor) do
        Scrapespeare::Extractor.new(:employees, { css: ".employees li" })
      end

      it "matches Elements" do
        matcher = spy()
        extractor.instance_variable_set(:@matcher, matcher)

        extractor.extract(document)

        expect(matcher).to have_received(:match).with(document)
      end

      context "without nested Extractables" do
        let(:extractor) do
          Scrapespeare::Extractor.new(
            :name, { css: "#nickolas-howe .name" }
          )
        end

        it "evaluates matched Elements" do
          result = extractor.extract(document)
          expect(result).to eq({
            name: "Nickolas Howe"
          })
        end
      end

      context "with nested Extractables" do
        let(:extractor) do
          Scrapespeare::Extractor.new(
            :employees, { css: "#employees li" }
          )
        end

        before do
          extractor.css(:name, ".name")
          extractor.css(:department, ".department")
        end

        it "evaluates nested Extractables" do
          result = extractor.extract(document)
          expect(result).to eq({
            employees: [
              {
                name: "Nickolas Howe",
                department: "Music, Computers & Grocery"
              },
              {
                name: "Ivah Swift",
                department: "Kids, Sports & Shoes"
              },
              {
                name: "Lucy Walker",
                department: "Automotive, Tools & Sports"
              },
              {
                name: "Sherwood Cremin",
                department: "Outdoors"
              }
            ]
          })
        end
      end
    end

  end
end
