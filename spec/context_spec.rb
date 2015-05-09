require "spec_helpers"

describe Schablone::Context do
  let(:processor) { Object.new }
  let(:page)      { fetch_page("http://example.com") }
  let(:router)    { Router.new }
  let(:navigator) { Navigator.new(router) }
  let(:adapter)   { Object.new }
  let(:params)    { {} }

  subject(:context) do
    Context.new(processor, navigator, adapter, page, params)
  end

  describe "#page" do
    it "returns @page" do
      expect(context.send(:page)).to be page
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

  describe "#adapter" do
    let(:adapter) { spy() }

    it "returns @adapter" do
      expect(context.send(:adapter)).to be adapter
    end
  end

end
