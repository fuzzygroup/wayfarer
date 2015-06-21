require "spec_helpers"

describe Schablone::Task do
  let!(:processor) { Celluloid::Actor[:processor] = Processor.new }
  let!(:navigator) { Celluloid::Actor[:navigator] = Navigator.new }
  let(:adapter)    { NetHTTPAdapter.instance }
  subject(:task)   { Task.new }

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
      Task.class_eval do
        draw host: "example.com"
        def example; :ok; end
      end

      expect(task.class.router.routes.any? { |(method, _)| method == :example })
    end
  end

  describe "#invoke" do
    context "with matching route" do
      it "calls the expected instance method and returns staged URIs" do
        Task.class_eval do
          draw path: "/hello_world"
          def foo; visit("http://example.com"); end
        end

        uri = test_app("/hello_world")
        expect(task.invoke(uri, adapter)).to eq ["http://example.com"]
      end
    end

    context "with mismatching routes" do
      it "returns an empty Array" do
        uri = URI("http://example.com")
        expect(task.invoke(uri, adapter)).to eq []
      end
    end
  end

  describe "#halt!" do
    it "returns :halt" do
      Task.class_eval do
        draw path: "/hello_world"
        def foo
          visit("http://example.com")
          halt!
        end
      end

      uri = test_app("/hello_world")
      expect(task.invoke(uri, adapter)).to be :halt
    end
  end

  describe "#visit" do
    it "stages URIs internally" do
      expect {
        task.send(:visit, "http://google.com", "http://yahoo.com")
      }.to change { task.staged_uris.count }.by(2)
    end
  end
end