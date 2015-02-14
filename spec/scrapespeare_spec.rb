require "spec_helpers"

describe Scrapespeare do

  describe "VERSION" do
    it "has a VERSION" do
      expect(defined? Scrapespeare::VERSION)
    end
  end

  describe "#config" do
    after { Scrapespeare.config.reset! }

    it "exposes the configuration" do
      expect(Scrapespeare.config).to be_a Scrapespeare::Configuration
    end

    context "with block given" do
      it "yields the configuration" do
        Scrapespeare.config { |config| config.foo = :foo }
        expect(Scrapespeare.config.foo).to be :foo
      end
    end
  end

  describe "#[]=" do
    it "works" do
      Scrapespeare["http://example.com"]
    end
  end

end
