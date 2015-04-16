require "spec_helpers"

describe Schablone::Worker do
  let(:processor)     { Object.new }
  let(:uri_queue)     { queue([URI("http://example.com")]) }
  let(:handler)       { Proc.new { emit(:success) } }
  let(:router)        { Router.new }
  let(:navigator)     { Navigator.new(router) }
  let(:emitter)       { Emitter.new }
  let(:adapter)       { HTTPAdapters::NetHTTPAdapter.new }

  subject(:worker) do
    Worker.new(processor, uri_queue, navigator, router, emitter, adapter)
  end

  before do
    router.register_handler(:foo, &handler)
    router.map(:foo) { host("0.0.0.0") }
  end

  describe "#process" do
    let(:uri) { URI("http://0.0.0.0:9876/graph/index.html") }
    before { worker.send(:process, uri) }

    it "emits as expected" do
      emitter = spy()
      worker.instance_variable_set(:@emitter, emitter)

      worker.send(:process, uri)

      expect(emitter).to have_received(:emit).with(:foo, :success)
    end

    context "with handler that does not stage URIs" do
      let(:handler) { Proc.new {} }

      it "does not stage URIs" do
        expect(worker.navigator.staged_uris).to be_empty
      end
    end

    context "with handler that stages URIs" do
      let(:handler) { Proc.new { visit page.links } }

      it "stages URIs" do
        expect(worker.navigator.staged_uris).to eq %w(
          http://0.0.0.0:9876/graph/details/a.html
          http://0.0.0.0:9876/graph/details/b.html
          http://0.0.0.0:9876/status_code/400
          http://0.0.0.0:9876/status_code/403
          http://0.0.0.0:9876/status_code/404
          http://bro.ken
          http://0.0.0.0:9876/redirect_loop
        ).map { |str| URI(str) }
      end
    end

    it "caches processed URIs" do
      expected_uris = %w(
        http://0.0.0.0:9876/graph/index.html
        http://example.com
      ).map { |str| URI(str) }

      expected_uris.each do |uri|
        expect(worker.navigator.cached_uris).to include uri
      end
    end
  end

  describe "#http_adapter" do
    context "when `@adapter` is not `nil`" do
      it "returns `@adapter`" do
        worker.instance_variable_set(:@adapter, :foo)
        expect(worker.send(:http_adapter)).to be :foo
      end
    end

    context "when `@adapter` is `nil`", live: true do
      it "returns a `SeleniumAdapter`" do
        worker.instance_variable_set(:@adapter, nil)
        adapter = worker.send(:http_adapter)
        expect(adapter).to be_a SeleniumAdapter
        adapter.free
      end
    end
  end
end
