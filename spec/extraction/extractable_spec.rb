require "spec_helpers"

describe Schablone::Extraction::Extractable do
  subject(:extractable) { Object.new.extend(Extractable) }

  describe "#css" do
    it "adds a CSS Extractor" do
      extractable.css(:foo, ".bar")
      expect(extractable.extractables.first).to be_an Extractor
    end
  end

  describe "#xpath" do
    it "adds an XPath Extractor" do
      extractable.xpath(:foo, "/")
      expect(extractable.extractables.first).to be_an Extractor
    end
  end

  describe "#group" do
    it "adds an ExtractableGroup" do
      extractable.group(:foo)
      expect(extractable.extractables.first).to be_an ExtractableGroup
    end
  end

  describe "#scope" do
    it "adds a Scoper" do
      extractable.scope(css: "#foo .bar")
      expect(extractable.extractables.first).to be_a Scoper
    end
  end
end
