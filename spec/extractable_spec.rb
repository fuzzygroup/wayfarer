require "spec_helpers"

module Scrapespeare
  describe Extractable do

    let(:extractable) { Object.new.extend(Scrapespeare::Extractable) }

    describe "#extractables" do
      context "with @extractables set" do
        before { extractable.instance_variable_set(:@extractables, :set) }

        it "exposes @extractables" do
          expect(extractable.extractables).to be :set
        end
      end

      context "without @extractables set" do
        it "returns an empty list" do
          expect(extractable.extractables).to eq []
        end
      end
    end

    describe "#css" do
      it "adds a CSS Extractor" do
        extractable.css(:foo, ".bar")
        added_extractable = extractable.extractables.first

        expect(added_extractable).to be_an Extractor
      end

      it "initializes the added CSS Extractor correctly" do
        extractable.css(:foo, ".bar", :href, :src)
        added_extractor = extractable.extractables.first

        expect(added_extractor.identifier).to be :foo
        expect(added_extractor.target_attrs).to eq [:href, :src]
      end

      it "initializes the added CSS Extractor's Matcher correctly" do
        extractable.css(:foo, ".bar")
        matcher = extractable.extractables.first.matcher

        expect(matcher.type).to be :css
        expect(matcher.expression).to eq ".bar"
      end
    end

    describe "#xpath" do
      it "adds an XPath Extractor" do
        extractable.xpath(:foo, ".bar")
        added_extractable = extractable.extractables.first

        expect(added_extractable).to be_an Extractor
      end

      it "initializes the added XPath Extractor correctly" do
        extractable.xpath(:foo, ".bar", :href, :src)
        added_extractor = extractable.extractables.first

        expect(added_extractor.identifier).to be :foo
        expect(added_extractor.target_attrs).to eq [:href, :src]
      end

      it "initializes the added XPath Extractor's Matcher correctly" do
        extractable.xpath(:foo, ".bar")
        matcher = extractable.extractables.first.matcher

        expect(matcher.type).to be :xpath
        expect(matcher.expression).to eq ".bar"
      end
    end

    describe "#group" do
      it "adds an ExtractableGroup" do
        extractable.group(:foo)
        added_extractable = extractable.extractables.first

        expect(added_extractable).to be_an ExtractableGroup
      end

      it "initializes the added ExtractableGroup correctly" do
        extractable.group(:foo)
        added_extractor_group = extractable.extractables.first

        expect(added_extractor_group.identifier).to be :foo
      end
    end

    describe "#scope" do
      it "adds a Scoper" do
        extractable.scope({ css: "#foo .bar" })
        added_extractable = extractable.extractables.first

        expect(added_extractable).to be_a Scoper
      end

      it "initializes the added Scoper's Matcher correctly" do
        extractable.scope({ css: "#foo .bar" })
        matcher = extractable.extractables.first.matcher

        expect(matcher.type).to be :css
        expect(matcher.expression).to eq "#foo .bar"
      end
    end

    describe "#populate_evaluator" do
      let(:extractor_a) { Extractor.new(:foo, css: "#foo") }
      let(:extractor_b) { Extractor.new(:bar, css: "#bar") }

      before do
        extractable.instance_variable_set(:@extractables, [
          extractor_a, extractor_b
        ])
      end

      let(:evaluator) { Object.new }

      it "passes the evaluator to the corresponding Extractable(s)" do
        extractable.pass_evaluator(:foo, evaluator)

        expect(extractor_a.evaluator).to be evaluator
        expect(extractor_b.evaluator).not_to be evaluator
      end
    end

  end
end
