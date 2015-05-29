require "spec_helpers"

describe Schablone::Worker do
  let(:task)       { Task.new }
  let!(:processor) { Celluloid::Actor[:processor] = Processor.new }
  let!(:navigator) { Celluloid::Actor[:navigator] = Navigator.new }

  subject(:worker) { Worker.new }

  describe "#scrape" do
    it "caches URIs" do
      uri = URI("http://example.com")
      worker.scrape(uri, task)
      expect(navigator.cached_uris.include?(uri)).to be true
    end
  end
end
