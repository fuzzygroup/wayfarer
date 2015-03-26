require "spec_helpers"

describe Schablone::Extraction::Extractable do
  let(:extractable) { Object.new.extend(Extractable) }

  describe "#add_css_extractor, #css" do
    it "adds a CSS Extractor" do
      extractable.css(:foo, ".bar")
      added_extractable = extractable.extractables.first

      expect(added_extractable).to be_an Extractor
    end

    it "initializes the added CSS Extractor correctly" do
      extractable.css(:foo, ".bar", :href, :src)
      added_extractor = extractable.extractables.first

      expect(added_extractor.key).to be :foo
      expect(added_extractor.target_attrs).to eq [:href, :src]
    end

    it "initializes the added CSS Extractor's Matcher correctly" do
      extractable.css(:foo, ".bar")
      matcher = extractable.extractables.first.matcher

      expect(matcher.type).to be :css
      expect(matcher.expression).to eq ".bar"
    end
  end

  describe "#add_xpath_extractor, #xpath" do
    it "adds an XPath Extractor" do
      extractable.xpath(:foo, ".bar")
      added_extractable = extractable.extractables.first

      expect(added_extractable).to be_an Extractor
    end

    it "initializes the added XPath Extractor correctly" do
      extractable.xpath(:foo, ".bar", :href, :src)
      added_extractor = extractable.extractables.first

      expect(added_extractor.key).to be :foo
      expect(added_extractor.target_attrs).to eq [:href, :src]
    end

    it "initializes the added XPath Extractor's Matcher correctly" do
      extractable.xpath(:foo, ".bar")
      matcher = extractable.extractables.first.matcher

      expect(matcher.type).to be :xpath
      expect(matcher.expression).to eq ".bar"
    end
  end

  describe "#add_group, #group" do
    it "adds an ExtractableGroup" do
      extractable.group(:foo)
      added_extractable = extractable.extractables.first

      expect(added_extractable).to be_an ExtractableGroup
    end

    it "initializes the added ExtractableGroup correctly" do
      extractable.group(:foo)
      added_extractor_group = extractable.extractables.first

      expect(added_extractor_group.key).to be :foo
    end
  end

  describe "#add_scoper, #scope" do
    it "adds a Scoper" do
      extractable.scope(css: "#foo .bar")
      added_extractable = extractable.extractables.first

      expect(added_extractable).to be_a Scoper
    end

    it "initializes the added Scoper's Matcher correctly" do
      extractable.scope(css: "#foo .bar")
      matcher = extractable.extractables.first.matcher

      expect(matcher.type).to be :css
      expect(matcher.expression).to eq "#foo .bar"
    end
  end
end
