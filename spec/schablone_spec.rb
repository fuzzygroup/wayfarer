require "spec_helpers"

describe Wayfarer do
  describe "::VERSION" do
    it("is present") { expect(defined? Wayfarer::VERSION).not_to be nil }
  end

  describe "::logger=" do
    it "allows modifying the logger" do
      expect { Wayfarer.logger = Object.new }.to change { Wayfarer.logger }
    end
  end

  describe "::config" do
    it "allows modifying options" do
      Wayfarer.config.foo = :bar
      expect(Wayfarer.config.foo).to be :bar

      Wayfarer.config { |cfg| cfg.baz = :qux }
      expect(Wayfarer.config.baz).to be :qux
    end
  end
end
