require "spec_helpers"

describe Schablone::Processor do
  subject!(:processor) { Celluloid::Actor[:processor] = Processor.new }
  let(:navigator)      { Celluloid::Actor[:navigator] }

  describe "#step" do
    it "caches URIs" do
      uri = test_app("/hello_world")
      navigator.stage(uri)
      navigator.cycle
      processor.send(:step, Task)

      expect(navigator.cached_uris).to eq [uri]
    end

    it "stages URIs" do
      task_class = Class.new(Task) do
        def foo; %w(http://example.com http://google.com); end
        router.draw(:foo, path: "/hello_world")
      end

      navigator.stage(test_app("/hello_world"))
      navigator.cycle
      processor.send(:step, task_class)

      expect(navigator.staged_uris).to eq [
        URI("http://example.com"), URI("http://google.com")
      ]
    end
  end
end
