require "spec_helpers"

describe Schablone::Context do

  let(:page) { fetch_page("http://example.com") }
  let(:router) { Router.new({}) }
  let(:navigator) { Navigator.new(router) }
  let(:context) { Context.new(page, navigator) }

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

  describe "#halt" do
    it "throws `:halt`" do
      expect {
        context.send(:halt)
      }.to throw_symbol :halt
    end
  end

  describe "#invoke" do
    it "evaluates the `Proc` in its instance context" do
      this = nil
      context.invoke { this = self }
      expect(this).to be context
    end
  end

end
