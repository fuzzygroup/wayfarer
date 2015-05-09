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
    it "stages URIs" do
      expect {
        context.send(:visit, "http://google.com", "http://yahoo.com")
      }.to change { navigator.staged_uris.count }.by(2)
    end
  end

  describe "#halt" do
    it "calls #halt on its @processor" do
      context.instance_variable_set(:@processor, processor = spy())
      context.send(:halt)
      expect(processor).to have_received(:halt)
    end
  end

  describe "#evaluate" do
    it "evaluates the Proc in its instance context" do
      this = nil
      context.evaluate { this = self }
      expect(this).to be context
    end
  end
end
