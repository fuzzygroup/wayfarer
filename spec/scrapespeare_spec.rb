require "spec_helpers"

describe Scrapespeare do

  describe "::VERSION" do
    it("is present") { expect(defined? Scrapespeare::VERSION) }
  end

  describe "#config" do
    context "without Proc given" do
      it "returns the Configuration" do
        expect(Scrapespeare.config).to be_a Scrapespeare::Configuration
      end
    end

    context "with Proc of arity 0 given" do
      it "evaluates the Proc in its Configuration's instance context" do
        this = nil
        Scrapespeare.config { this = self }
        expect(this).to be_a Configuration
      end
    end

    context "with Proc of arity 1 given" do
      it "yields the Configuration" do
        Scrapespeare.config { |conf| @config = conf }
        expect(@config).to be Scrapespeare.config
      end
    end
  end

  describe "#logger" do
    it "exposes the Logger" do
      expect(Scrapespeare.logger).to be_a Logger
    end

    it "sets the correct log level" do
      Scrapespeare.config.log_level = Logger::INFO
      expect(Scrapespeare.logger.level).to be Scrapespeare.config.log_level
      Scrapespeare.config.reset!
    end
  end

end
