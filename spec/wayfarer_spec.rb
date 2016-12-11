# frozen_string_literal: true
require "spec_helpers"

describe Wayfarer do
  describe "::VERSION" do
    it("is present") { expect(defined? Wayfarer::VERSION).not_to be nil }
  end

  describe "::logger, ::logger=" do
    it "returns and alters the logger" do
      expect { Wayfarer.logger = Object.new }.to change { Wayfarer.logger }
    end
  end

  describe "::config" do
    it "alters keys and values" do
      Wayfarer.config.foo = :bar
      expect(Wayfarer.config.foo).to be :bar

      Wayfarer.config { |config| config.baz = :qux }
      expect(Wayfarer.config.baz).to be :qux
    end
  end
end
