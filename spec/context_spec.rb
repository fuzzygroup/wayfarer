require "spec_helpers"

describe Schablone::Context do
  let(:processor) { Object.new }
  let(:page)      { fetch_page("http://example.com") }
  let(:router)    { Router.new }
  let(:navigator) { Navigator.new(router) }
  let(:emitter)   { Emitter.new }
  let(:context)   { Context.new(processor, page, navigator, emitter) }

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
    let(:uri) { URI("http://example.com") }

    it "stages a URI" do
      expect {
        context.send(:visit, uri)
      }.to change { navigator.staged_uris.count }.by(1)
    end
  end

  describe "#emit" do
    let(:emitter) { spy() }
    before { context.instance_variable_set(:@emitter, emitter) }

    it "emits as expected" do
      context.send(:emit, :foo, :bar)
      expect(emitter).to have_received(:emit).with(:foo, :bar)
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

      expect(emitter).to have_received(:emit).with({ title: "Example Domain" })
    end
  end

end
