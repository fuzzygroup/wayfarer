require "spec_helpers"

describe Schablone::Processor do
  let(:task) { Class.new(Task) }
  let!(:processor)    { Celluloid::Actor[:processor] = Processor.new }
  let!(:navigator)    { Celluloid::Actor[:navigator] = Navigator.new }

  describe "#run" do
    it "halts without staged URIs" do
      navigator.stage(URI("http://example.com"))
      navigator.cycle
      processor.run(task)
      expect(navigator.cached_uris).to eq [URI("http://example.com")]
    end
  end

  describe "#halt" do
    it "terminates the Processor" do
      processor.halt
      expect(processor).not_to be_alive
    end
  end
end
