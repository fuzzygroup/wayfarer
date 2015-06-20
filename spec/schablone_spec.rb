require "spec_helpers"

describe Schablone do
  describe "::VERSION" do
    it("is present") { expect(defined? Schablone::VERSION).not_to be nil }
  end

  describe "::logger=" do
    it "allows modifying the logger" do
      expect {
        Schablone.logger = Object.new
      }.to change { Schablone.logger }
    end
  end

  describe "::config" do
    it "allows modifying options" do
      Schablone.config.foo = :bar
      expect(Schablone.config.foo).to be :bar

      Schablone.config { |cfg| cfg.baz = :qux }
      expect(Schablone.config.baz).to be :qux
    end
  end
end
