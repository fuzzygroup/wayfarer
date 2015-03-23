require "spec_helpers"

describe Scrapespeare::Extraction::Scoper do

  describe "#initialize" do
    let(:scoper) { Scoper.new(css: ".foo") }

    it "sets @matcher correctly" do
      matcher = scoper.matcher
      expect(matcher.type).to be :css
      expect(matcher.expression).to eq ".foo"
    end
  end

  describe "#extract" do
    let(:doc) do
      Nokogiri::HTML <<-html
        <span class="alpha">Lorem</span>
        <span class="beta">Ipsum</span>

        <div class="scope">
          <span class="alpha">Sit</span>
          <span class="beta">Amet</span>
        </div>
      html
    end

    context "without nested Extractables" do
      it "returns an empty Hash" do
        result = Scoper.new(css: ".scope").extract(doc)
        expect(result).to eq({})
      end
    end

    context "with nested Extractables" do
      it "calls its Extractables with the correct NodeSet" do
        scoper = Scoper.new(css: ".scope")
        scoper.css(:alpha, ".alpha")

        result = scoper.extract(doc)

        expect(result).to eq({
          alpha: "Sit"
        })
      end
    end
  end

end
