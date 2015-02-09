require "spec_helpers"

describe Scrapespeare do

  describe "VERSION" do
    it "has a VERSION" do
      expect(defined? Scrapespeare::VERSION)
    end
  end

  describe "#config" do
    it "returns a Configuration" do
      expect(Scrapespeare.config).to be_a Scrapespeare::Configuration
    end
  end

  describe "#configure" do
    it "yields its Configuration" do
      Scrapespeare.configure do |config|
        expect(config).to be Scrapespeare.config
      end
    end
  end

end
