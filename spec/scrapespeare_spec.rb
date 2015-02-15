require "spec_helpers"

describe Scrapespeare do

  describe "::VERSION" do
    it("is present") { expect(defined? Scrapespeare::VERSION) }
  end

  describe "#config" do
    it "exposes the configuration" do
      expect(Scrapespeare.config).to be_a Scrapespeare::Configuration
    end

    context "with block given" do
      after { Scrapespeare.config.reset! }

      it "yields the configuration" do
        Scrapespeare.config { |config| config.foo = :foo }
        expect(Scrapespeare.config.foo).to be :foo
      end
    end
  end

end
