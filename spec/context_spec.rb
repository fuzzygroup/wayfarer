require "spec_helpers"

describe Schablone::Context do

  let(:page) { fetch_page("http://example.com") }
  let(:router) { Router.new }
  let(:navigator) { Navigator.new(router) }
  let(:context) { Context.new(page, navigator) }

  describe "#page" do
    it "returns `@page`" do
      expect(context.send(:page)).to be page
    end
  end

  describe "#navigator" do
    it "returns `@navigator`" do
      expect(context.send(:navigator)).to be navigator
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

end
