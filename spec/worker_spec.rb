require "spec_helpers"

describe Schablone::Worker do
  let(:router)     { Router.new }
  let(:uris)       { [] }
  let!(:processor) { Celluloid::Actor[:processor] = Processor.new(router) }
  let!(:navigator) { Celluloid::Actor[:navigator] = Navigator.new }

  subject(:worker) { Worker.new }

  describe "#scrape" do
    it "caches URIs" do
      uri = URI("http://example.com")
      worker.scrape(uri, router)
      expect(navigator.cached_uris.include?(uri)).to be true
    end

    it "evaluates payloads" do
      has_evaluated = false
      router.register_payload(:foo) { has_evaluated = true }
      router.draw(:foo, host: "example.com")
      worker.scrape(URI("http://example.com"), router)
      expect(has_evaluated).to be true
    end
  end
end
