# frozen_string_literal: true
require "spec_helpers"

describe Wayfarer::Routing::PathRule, mri: true do
  subject(:rule) { PathRule.new("/{alpha}/{beta}") }

  describe "#matches?" do
    context "with matching URI" do
      let(:uri) { URI("http://example.com/foo/bar") }

      it "returns true" do
        expect(rule.matches?(uri)).to be true
      end
    end
  end

  context "with mismatching URI" do
    let(:uri) { URI("http://example.com/foo") }

    it "returns false" do
      expect(rule.matches?(uri)).to be false
    end
  end

  describe "#params" do
    it "returns the correct parameters" do
      uri = URI("http://example.com/foo/bar")
      expect(rule.params(uri)).to eq("alpha" => "foo", "beta" => "bar")
    end
  end
end
