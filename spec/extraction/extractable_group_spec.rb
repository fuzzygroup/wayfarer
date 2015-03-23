require "spec_helpers"

describe Scrapespeare::Extraction::ExtractableGroup do

  let(:extractable_group) { ExtractableGroup.new(:foo) }

  describe "#initialize" do
    it "sets @identifier correctly" do
      expect(extractable_group.identifier).to be :foo
    end
  end

  describe "#extract" do
    let(:doc) do
      Nokogiri::HTML <<-html
        <span id="foo">Foo</span>
        <span id="bar">Bar</span>
      html
    end

    context "without nested Extractables" do
      it "returns a Hash with an empty String as value" do
        result = extractable_group.extract(doc)
        expect(result).to eq({ foo: "" })
      end
    end

    context "with nested Extractables" do
      before do
        extractable_group.css(:bar, "#bar")
      end

      it "returns the expected Hash structure" do
        result = extractable_group.extract(doc)
        expect(result).to eq({
          foo: { bar: "Bar" }
        })
      end
    end
  end

end
