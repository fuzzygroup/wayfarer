require "spec_helpers"

describe Scrapespeare do

  describe "VERSION" do
    it "has a VERSION" do
      expect(defined? Scrapespeare::VERSION)
    end
  end

  describe "#options" do
    it "returns a Configuration" do
      expect(Scrapespeare.options).to be_a Hash
    end
  end

end
