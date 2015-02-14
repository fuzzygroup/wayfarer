require "spec_helpers"

describe Scrapespeare do

  describe "VERSION" do
    it "has a VERSION" do
      expect(defined? Scrapespeare::VERSION)
    end
  end

  describe "#config" do
    it "yields the configuration" do
      Scrapespeare.config do |config|
        config.foo = :foo
      end

      expect(Scrapespeare.config.foo).to be :foo
    end
  end

end
