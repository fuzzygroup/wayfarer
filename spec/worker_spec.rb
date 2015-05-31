require "spec_helpers"

describe Schablone::Worker do
  let(:task)       { Task.new }
  let!(:processor) { Celluloid::Actor[:processor] = Processor.new }
  let!(:navigator) { Celluloid::Actor[:navigator] = Navigator.new }
  subject(:worker) { Worker.new }

  describe "#scrape" do
    it "caches URIs" do
      uri = URI(test_app("/hello_world"))
      worker.scrape(uri, task)
      expect(navigator.cached_uris.include?(uri)).to be true
    end

    it "allows staging URIs" do
      task_class = Class.new(Task) do
        def foo; visit("http://example.com"); end
        route.draw(:foo, path: "/hello_world")
      end

      task = task_class.new
      uri = test_app("/hello_world")
      worker.scrape(uri, task)
      expect(navigator.staged_uris.include?(URI("http://example.com"))).to be true
    end
  end
end
