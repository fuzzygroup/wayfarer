require "spec_helpers"

module Scrapespeare
  describe Extractable do

    let(:extractable) { Object.new.extend(Scrapespeare::Extractable) }

    describe "#extractables" do
      context "with @extractables set" do
        before { extractable.instance_variable_set(:@extractables, "set") }

        it "exposes @extractables" do
          expect(extractable.extractables).to eq("set")
        end
      end

      context "without @extractables set" do
        it "sets @extractables to an empty list" do
          expect(extractable.extractables).to eq([])
        end
      end
    end

    describe "#add_extractable" do
      let(:other_extractable) { spy("other_extractable") }

      it "adds an Extractable" do
        expect {
          extractable.add_extractable(other_extractable)
        }.to change{ extractable.extractables.count }.by(1)
      end

      it "sets its @options on the added Extractable" do
        extractable.instance_variable_set(:@options, { foo: "bar" })

        extractable.add_extractable(other_extractable)
        added_extractable = extractable.extractables.first

        expect(added_extractable).to have_received(:set).with({ foo: "bar" })
      end
    end

    describe "#css" do
      it "adds an Extractor" do
        extractable.css(:foo, ".bar")
        added_extractable = extractable.extractables.first

        expect(added_extractable).to be_an Extractor
      end

      it "initializes the added Extractor correctly" do
        extractable.css(:foo, ".bar", "href", "src")
        added_extractor = extractable.extractables.first

        expect(added_extractor.identifier).to be :foo
        expect(added_extractor.target_attributes).to eq ["href", "src"]
      end

      it "initializes the added Extractor's Matcher correctly" do
        extractable.css(:foo, ".bar")
        matcher = extractable.extractables.first.matcher

        expect(matcher.type).to be :css
        expect(matcher.expression).to eq ".bar"
      end
    end

    describe "#xpath" do
      it "adds an Extractor" do
        extractable.xpath(:foo, ".bar")
        added_extractable = extractable.extractables.first

        expect(added_extractable).to be_an Extractor
      end

      it "initializes the added Extractor correctly" do
        extractable.xpath(:foo, ".bar", "href", "src")
        added_extractor = extractable.extractables.first

        expect(added_extractor.identifier).to be :foo
        expect(added_extractor.target_attributes).to eq ["href", "src"]
      end

      it "initializes the added Extractor's Matcher correctly" do
        extractable.xpath(:foo, ".bar")
        matcher = extractable.extractables.first.matcher

        expect(matcher.type).to be :xpath
        expect(matcher.expression).to eq ".bar"
      end
    end

    describe "#group" do
      it "adds an ExtractorGroup" do
        extractable.group(:foo)
        added_extractable = extractable.extractables.first

        expect(added_extractable).to be_an ExtractorGroup
      end

      it "initializes the added ExtractorGroup correctly" do
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

  end
end
