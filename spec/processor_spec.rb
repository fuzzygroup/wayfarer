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
end
