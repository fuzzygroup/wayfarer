require "spec_helpers"

describe Scrapespeare do

  describe "VERSION" do
    it "has a VERSION" do
      expect(defined? Scrapespeare::VERSION)
    end
  end

  describe "#config" do
    context "with block given" do
      it "yields config" do
        Scrapespeare.config do |config|
          config.foo = :foo
          config.bar = :bar
        end

        expect(Scrapespeare.config.foo).to be :foo
        expect(Scrapespeare.config.bar).to be :bar
      end
    end
  end

end
