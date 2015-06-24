require "spec_helpers"

describe Schablone::Task do
  let(:adapter)  { NetHTTPAdapter.instance }
  subject(:task) { Task.new }

  describe "::config" do
    it "works" do
      task.class.instance_eval do
        config do |c|
          c.http_adapter = :selenium
        end
      end

      expect(task.config.http_adapter).to be :selenium
    end
  end

  describe "::draw" do
    it "draws routes" do
      task.class.class_eval do
        draw host: "example.com"
        def example; end
      end

      expect(task.class.router.routes.any? { |(method, _)| method == :example })
    end
  end

  describe "::post_process" do
    it "registers post-processors" do
      task.class.instance_eval do
        post_process :foo
        post_process :bar
      end

      expect(task.class.post_processors.count).to be 2
    end
  end

  describe "::post_process!" do
    it "runs all post-processors in FIFO order" do
      task.class.instance_eval do
        post_process :foo
        post_process :bar
        post_process do
          @qux = 42
        end
        post_process :baz

        private

        def self.foo; :foo; end
        def self.bar; :bar; end
        def self.baz; @qux + 24; end
      end

      expect(task.class.post_process!).to be 66
    end
  end

  describe "#invoke" do
    context "with matching route" do
      it "returns a Stage" do
        task.class.class_eval do
          draw path: "/hello_world"
          def foo; visit("http://example.com"); end
        end

        uri = test_app("/hello_world")
        returned = task.invoke(uri, adapter)
        expect(returned).to be_a Task::Stage
        expect(returned.uris).to eq ["http://example.com"]
      end
    end

    context "with mismatching routes" do
      it "returns a Mismatch" do
        task.class.class_eval do
          route.draw :bar, path: "/hello_world"
          def foo; end
        end

        uri = test_app("/hello_world")
        returned = task.invoke(uri, adapter)
        expect(returned).to be_a Task::Mismatch
        expect(returned.uri).to be uri
      end
    end

    context "with failing instance method" do
      it "returns an Error" do
        task.class.class_eval do
          draw path: "/hello_world"
          def foo; fail; end
        end

        uri = test_app("/hello_world")
        returned = task.invoke(uri, adapter)
        expect(returned).to be_a Task::Error
        expect(returned.exception).to be_a RuntimeError
      end
    end
  end

  describe "#halt!" do
    it "enforces a Halt to be returned" do
      task.class.class_eval do
        draw path: "/hello_world"
        def foo
          visit("http://example.com")
          halt
        end
      end

      uri = test_app("/hello_world")
      expect(task.invoke(uri, adapter)).to be_a Task::Halt
    end
  end

  describe "#visit" do
    it "stages URIs internally" do
      expect {
        task.send(:visit, "http://google.com")
      }.to change { task.staged_uris.count }.by(1)
    end
  end
end