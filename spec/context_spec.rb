require "spec_helpers"

describe Schablone::Context do
  let(:handler)   { :foo }
  let(:processor) { Object.new }
  let(:page)      { fetch_page("http://example.com") }
  let(:router)    { Router.new }
  let(:navigator) { Navigator.new(router) }
  let(:emitter)   { Emitter.new }
  let(:adapter)   { Object.new }

  subject(:context) do
    Context.new(handler, processor, page, navigator, emitter, adapter)
  end

  describe "#page" do
    it "returns `@page`" do
      expect(context.send(:page)).to be page
    end
  end

  describe "#history" do
    it "returns `@navigator.cached_uris`" do
      expect(context.send(:history)).to eq navigator.cached_uris
    end
  end

  describe "#visit" do
    context "with `URI` given" do
      let(:uri) { URI("http://example.com") }

      it "stages the `URI`" do
        expect {
          context.send(:visit, uri)
        }.to change { navigator.staged_uris.count }.by(1)
      end
    end

    context "with `String` given" do
      let(:uri_str) { "http://example.com" }

      it "converts the `String` to a `URI` and stages it" do
        expect {
          context.send(:visit, uri_str)
        }.to change { navigator.staged_uris.count }.by(1)
      end
    end

    context "with multiple `URI`s given" do
      let(:uris) { [URI("http://example.com"), URI("http://google.com")] }

      it "stages the `URI`s" do
        expect {
          context.send(:visit, uris)
        }.to change { navigator.staged_uris.count }.by(2)
      end
    end

    context "with multiple `Strings`s given" do
      let(:uri_strs) { %w(http://example.com http://google.com) }

      it "stages the `URI`s" do
        expect {
          context.send(:visit, uri_strs)
        }.to change { navigator.staged_uris.count }.by(2)
      end
    end
  end

  describe "#emit" do
    let(:emitter) { spy() }
    before { context.instance_variable_set(:@emitter, emitter) }

    it "emits as expected" do
      context.send(:emit, 1, 2, 3)
      expect(emitter).to have_received(:emit).with(:foo, 1, 2, 3)
    end
  end

  describe "#halt" do
    it "calls #halt on its `Processor`" do
      context.instance_variable_set(:@processor, processor = spy())
      context.send(:halt)
      expect(processor).to have_received(:halt)
    end
  end

  describe "#invoke" do
    it "evaluates the `Proc` in its instance context" do
      this = nil
      context.invoke { this = self }
      expect(this).to be context
    end
  end

  describe "#extract" do
    it "works" do
      extract = context.send(:extract) do
        css :title, "title"
      end

      expect(extract).to eq({ title: "Example Domain" })
    end
  end

  describe "#extract!" do
    let(:emitter) { spy() }
    before { context.instance_variable_set(:@emitter, emitter) }

    it "emits as expected" do
      context.send(:extract!) do
        css :title, "title"
      end

      expect(emitter).to have_received(:emit).with(
        :foo, { title: "Example Domain" }
      )
    end
  end

  describe "#driver" do
    context "when config.http_adapter is :net_http" do
      it "returns nil" do
        expect(context.send(:driver)).to be nil
      end
    end

    context "when config.http_adapter is :selenium" do
      let(:adapter) { spy() }

      before { Schablone.config.http_adapter = :selenium }
      after { Schablone.config.reset! }

      it "returns @adapter" do
        expect(context.send(:driver)).to be adapter
      end
    end
  end

end
