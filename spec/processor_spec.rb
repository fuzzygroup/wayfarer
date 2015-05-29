require "spec_helpers"

describe Schablone::Processor do
  let(:task)           { Task.new }
  subject!(:processor) { Celluloid::Actor[:processor] = Processor.new }
  let(:navigator)      { Celluloid::Actor[:navigator] }

  describe "#run" do
    it "caches URIs" do
      uri = URI("http://example.com")
      navigator.stage(uri)
      processor.run(task)
      expect(navigator.cached_uris).to eq [uri]
    end
  end
end
