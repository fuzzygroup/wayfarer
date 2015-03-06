require "spec_helpers"

describe Scrapespeare::Routing::Rule do

  subject(:rule) { Rule.new("/bar") }

  describe "#===" do
    context "with matching URI path given" do
      it "returns `true`" do
        uri = URI("http://google.com/bar")
        expect rule === uri
      end
    end

    context "with mismatching URI path given" do
      it "returns `false`" do
        uri = URI("http://google.com/foo")
        expect !(rule === uri)
      end
    end
  end

end
