# frozen_string_literal: true
require "spec_helpers"

describe Wayfarer::Routing::URIRule do
  subject(:rule) { URIRule.new("http://example.com/foo/bar") }

  describe "#matches?" do
    context "with matching URI" do
      let(:uri) { URI("http://example.com/foo/bar") }

      it "returns true" do
        expect(rule.matches?(uri)).to be true
      end
    end

    context "with mismatching URI" do
      let(:uri) { URI("http://example.com/foo/qux") }

      it "returns true" do
        expect(rule.matches?(uri)).to be false
      end
    end
  end
end
