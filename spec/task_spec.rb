require "spec_helpers"

describe Schablone::Task do
  let!(:processor) { Celluloid::Actor[:processor] = Processor.new }
  let!(:navigator) { Celluloid::Actor[:navigator] = Navigator.new }

  subject(:task) { Task.new }

  describe "::router" do
    it "works" do
      router = nil
      task_class = Class.new(Task) { router = self.router }
      expect(task_class.router).to be router
    end
  end

  describe "#invoke" do
    context "with matching route" do
      it "calls the expected instance method" do
        task_class = Class.new(Task) do
          def foo; :ok; end
          router.draw(:foo, host: "example.com")
        end

        task = task_class.new

        uri = URI("http://example.com")
        expect(task.invoke(uri)).to be :ok
      end
    end

    context "with mismatching route" do
      it "returns nil" do
        task_class = Class.new(Task)
        task = task_class.new
        uri = URI("http://example.com")
        expect(task.invoke(uri)).to be nil
      end
    end
  end

  describe "#halt" do
    it "halts the Processor" do
      task.send(:halt)
      # expect(processor).not_to be_alive
    end
  end

  describe "#visit" do
    it "stages URIs" do
      expect {
        task.send(:visit, "http://google.com", "http://yahoo.com")
      }.to change { navigator.staged_uris.count }.by(2)
    end
  end

end