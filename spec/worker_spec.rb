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

    it "stages URIs" do
      task_class = Class.new(Task) do
        def foo; visit(URI("http://google.com")); end
        route.draw(:foo, host: "google.com")
      end

      task = task_class.new
      worker.scrape(URI("http://google.com"), task)
      expect(navigator.staged_uris.include?(URI("http://google.com"))).to be true
    end
  end
end
