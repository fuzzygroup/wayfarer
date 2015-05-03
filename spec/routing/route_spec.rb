require "spec_helpers"

describe Schablone::Routing::Route do
  let(:handler) { :foo }
  let(:adapter) { :net_http }
  let(:rule) { Rule.new.host "example.com" }
  subject(:route) { Route.new(handler, rule, adapter) }

  describe "#===" do
    context "with matching URI" do
      it "returns true" do
        expect(route === URI("http://example.com")).to be true
      end
    end

    context "with mismatching URI" do
      it "returns false" do
        expect(route === URI("http://google.com")).to be false
      end
    end
  end
end
