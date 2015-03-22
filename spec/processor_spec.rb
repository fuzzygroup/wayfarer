require "spec_helpers"

describe Scrapespeare::Processor do

  subject(:processor) { Processor.new }

  describe "#cache_uri" do
    it "caches an URI" do
      uri = URI("http://example.com")
      expect {
        processor.send(:cache_uri, uri)
      }.to change { processor.cached_uris.count }.by(1)
    end
  end

  describe "#stage_uri" do
    it "stages an URI" do
      uri = URI("http://example.com")
      expect {
        processor.send(:stage_uri, uri)
      }.to change { processor.staged_uris.count }.by(1)
    end

    context "with cached URI given" do
      let(:uri) { URI("http://example.com") }
      before { processor.send(:cache_uri, uri) }

      it "does not stage the URI" do
        expect {
          processor.send(:stage_uri, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end
  end
end
