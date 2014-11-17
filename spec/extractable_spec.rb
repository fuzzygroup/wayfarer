require "spec_helpers"

module Scrapespeare
  describe Extractable do

    let(:extractable) { Object.new.extend(Scrapespeare::Extractable) }

    describe "#extractors" do
      context "with @extractors set" do
        before { extractable.instance_variable_set(:@extractors, 42) }

        it "exposes @extractors" do
          expect(extractable.extractors).to be 42
        end
      end

      context "without @extractors set" do
        it "sets @extractors to an empty list" do
          expect(extractable.extractors).to eq []
        end
      end
    end

    describe "#add_extractor" do
      it "adds an Extractor" do
        expect {
          extractable.send(:add_extractor, :foo, { css: ".bar" })
        }.to change { extractable.extractors.count }.by(1)
      end

      it "initializes the added Extractor correctly" do
        extractable.send(:add_extractor, :foo, { css: ".bar" }, "class", "id")
        added_extractor = extractable.extractors.first

        expect(added_extractor.identifier).to be :foo
        
        matcher = added_extractor.matcher
        expect(matcher.type).to be :css
        expect(matcher.expression).to eq ".bar"

        expect(added_extractor.target_attributes).to eq ["class", "id"]
      end

      it "passes @options to the added Extractor" do
        extractable.instance_variable_set(:@options, { foo: "bar" })

        extractable.send(:add_extractor, :foo, { css: ".bar" })
        added_extractor = extractable.extractors.first

        expect(added_extractor.options[:foo]).to eq "bar"
      end
    end

    describe "#add_extractor_group" do
      it "adds an ExtractorGroup" do
        expect {
          extractable.send(:add_extractor_group, :foo)
        }.to change { extractable.extractors.count }.by(1)
      end

      it "initializes the added ExtractorGroup correctly" do
        extractable.send(:add_extractor_group, :foo)
        added_extractor_group = extractable.extractors.first

        expect(added_extractor_group.identifier).to be :foo
      end

      it "passes @options to the added ExtractorGroup" do
        extractable.instance_variable_set(:@options, { foo: "bar" })

        extractable.send(:add_extractor_group, :foo)
        added_extractor_group = extractable.extractors.first

        expect(added_extractor_group.options[:foo]).to eq "bar"
      end
    end

    describe "#css" do
      it "adds an Extractor" do
        expect {
          extractable.send(:css, :foo, ".bar")
        }.to change { extractable.extractors.count }.by(1)
      end

      it "initializes the added Extractor correctly" do
        extractable.send(:css, :foo, ".bar", "class", "id")
        added_extractor = extractable.extractors.first

        expect(added_extractor.identifier).to be :foo
        
        matcher = added_extractor.matcher
        expect(matcher.type).to be :css
        expect(matcher.expression).to eq ".bar"

        expect(added_extractor.target_attributes).to eq ["class", "id"]
      end
    end

    describe "#xpath" do
      it "adds an Extractor" do
        expect {
          extractable.send(:xpath, :foo, "bar")
        }.to change { extractable.extractors.count }.by(1)
      end

      it "initializes the added Extractor correctly" do
        extractable.send(:xpath, :foo, "bar", "class", "id")
        added_extractor = extractable.extractors.first

        expect(added_extractor.identifier).to be :foo
        
        matcher = added_extractor.matcher
        expect(matcher.type).to be :xpath
        expect(matcher.expression).to eq "bar"

        expect(added_extractor.target_attributes).to eq ["class", "id"]
      end
    end

  end
end
