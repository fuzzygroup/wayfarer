require "spec_helpers"

describe Schablone::Extraction::ExtractableGroup do
  subject(:group) { ExtractableGroup.new(:foo) }

  let(:doc) do
      Nokogiri::HTML <<-html
        <span id="foo">Foo</span>
        <span id="bar">Bar</span>
      html
    end

  describe "#initialize" do
    it "sets `@key` correctly" do
      expect(group.key).to be :foo
    end
  end

  describe "#extract" do
    context "without nested Extractables" do
      it "returns a Hash with an empty String as value" do
        result = group.extract(doc)
        expect(result).to eq(foo: "")
      end
    end

    context "with nested Extractables" do
      before { group.css(:bar, "#bar") }

      it "returns the expected Hash structure" do
        result = group.extract(doc)
        expect(result).to eq(foo: { bar: "Bar" })
      end
    end
  end
end
