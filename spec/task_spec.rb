require "spec_helpers"

describe Schablone::Task do
  let!(:processor) { Celluloid::Actor[:processor] = Processor.new }
  let!(:navigator) { Celluloid::Actor[:navigator] = Navigator.new }
  let(:adapter)    { NetHTTPAdapter.instance }
  subject(:task)   { Task.new }

  describe "#initialize" do
    it "points its instance variables to class instance variables" do
      task_class = Class.new(Task) do
        @yetis_seen = 0

        def yeti!
          @yetis_seen += 1
        end
      end

      task = task_class.new
      task.yeti!
      task.yeti!
      task.yeti!

      expect(task.instance_variable_get(:@yetis_seen)).to be 3
    end
  end

  describe "#invoke" do
    context "with matching route" do
      it "calls the expected instance method" do
        task_class = Class.new(Task) do
          def foo; :ok; end
          router.draw(:foo, path: "/hello_world")
        end

        uri = test_app("/hello_world")
        expect(task_class.new.invoke(uri, adapter)).to be :ok
      end
    end

    context "with mismatching route" do
      it "returns an empty Array" do
        uri = URI("http://example.com")
        expect(Task.new.invoke(uri, adapter)).to eq []
      end
    end
  end

  describe "#halt" do
    pending "fuck."
  end

  describe "#visit" do
    it "stages URIs" do
      expect {
        task.send(:visit, "http://google.com", "http://yahoo.com")
      }.to change { navigator.staged_uris.count }.by(2)
    end
  end

end