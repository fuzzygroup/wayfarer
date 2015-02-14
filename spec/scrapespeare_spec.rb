require "spec_helpers"

describe Scrapespeare do

  describe "VERSION" do
    it "has a VERSION" do
      expect(defined? Scrapespeare::VERSION)
    end
  end

  describe "#config" do
    it "exposes the configuration" do
      expect(Scrapespeare.config).to be_a Scrapespeare::Configuration
    end
  end

end
