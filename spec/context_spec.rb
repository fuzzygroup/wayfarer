require "spec_helpers"

describe Schablone::Context do
  let(:processor)   { Object.new }
  let(:page)        { fetch_page("http://example.com") }
  let(:router)      { Router.new }
  let(:navigator)   { Navigator.new(router) }
  let(:adapter)     { Object.new }
  let(:params)      { {} }
  subject(:context) { Context.new(processor, navigator, adapter, page, params) }

  describe "::helpers" do
    it "allows defining helper methods on the instances" do
      expect {
        Context.helpers { def foobar; end }
      }.to change { context.methods.count }.by(1)
    end

    it "accepts Modules" do
      module_a = Module.new { def alpha; end }
      module_b = Module.new { def beta; end }

      expect {
        Context.helpers(module_a, module_b)
      }.to change { context.methods.count }.by(2)
    end
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
