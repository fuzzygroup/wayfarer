require "spec_helpers"

describe Schablone::Routing::HostRule do
  subject(:rule) { HostRule.new(str_or_regexp) }

  describe "#===" do
    describe "String matching" do
      let(:str_or_regexp) { "example.com" }

      context "with matching URI" do
        let(:uri) { URI("http://example.com/foo/bar") }

        it "returns `true`" do
          expect(rule === uri).to be true
        end
      end

      context "with mismatching URI" do
        let(:uri) { URI("http://google.com/bar/qux") }

        it "returns `false`" do
          expect(rule === uri).to be false
        end
      end
    end

    describe "Regexp matchesing" do
      let(:str_or_regexp) { /example.com/ }

      context "with matching URI" do
        let(:uri) { URI("http://sub.example.com") }

        it "returns `true`" do
          expect(rule === uri).to be true
        end
      end

      context "with mismatching URI" do
        let(:uri) { URI("http://example.sub.com") }

        it "returns `false`" do
          expect(rule === uri).to be false
        end
      end
    end
  end
end
