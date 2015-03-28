require "spec_helpers"

describe Schablone::Processor do

  subject(:processor) { Processor.new }

  describe "#initialize" do
    it "sets `@current_uris` to an empty list" do
      expect(processor.current_uris).to eq []
    end

    it "sets `@staged_uris` to an empty list" do
      expect(processor.staged_uris).to eq []
    end

    it "sets `@processed_uris` to an empty list" do
      expect(processor.processed_uris).to eq []
    end
  end

  describe "#stage" do
    it "stages a URI" do
      uri = URI("http://example.com")
      expect {
        processor.send(:stage, uri)
      }.to change { processor.staged_uris.count }.by(1)
    end

    context "with processed URI" do
      let(:uri) { URI("http://example.com") }
      before { processor.instance_variable_set(:@processed_uris, [uri]) }

      it "does not stage the URI" do
        expect {
          processor.send(:stage, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end

    context "with staged URI" do
      let(:uri) { URI("http://example.com") }
      before { processor.send(:stage, uri) }

      it "does not stage the URI" do
        expect {
          processor.send(:stage, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end
  end

  describe "#processed?" do
    let(:uri) { URI("http://example.com") }

    context "with processed URI" do
      before { processor.instance_variable_set(:@processed_uris, [uri]) }

      it "returns `true`" do
        expect(processor.send(:processed?, uri)).to be true
      end
    end

    context "with unprocessed URI" do
      it "returns `false`" do
        expect(processor.send(:processed?, uri)).to be false
      end
    end
  end

end
