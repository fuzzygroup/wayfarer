require "spec_helpers"

describe Schablone do
  describe "::VERSION" do
    it("is present") { expect(defined? Schablone::VERSION).not_to be nil }
  end

  describe "::configure" do
    context "without Proc given" do
      it "returns the Configuration" do
        expect(Schablone.config).to be_a Schablone::Configuration
      end
    end

    context "with Proc of arity 0 given" do
      it "evaluates the Proc in its Configuration's instance context" do
        this = nil
        Schablone.configure { this = self }
        expect(this).to be_a Configuration
      end
    end

    context "with Proc of arity 1 given" do
      it "yields the Configuration" do
        Schablone.configure { |conf| @config = conf }
        expect(@config).to be Schablone.config
      end
    end
  end

  describe "::logger" do
    it "exposes the Logger" do
      expect(Schablone.logger).to be_a Logger
    end

    it "sets the correct log level" do
      Schablone.config.log_level = Logger::INFO
      expect(Schablone.logger.level).to be Schablone.config.log_level
      Schablone.config.reset!
    end
  end
end
