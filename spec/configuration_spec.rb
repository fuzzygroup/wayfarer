# frozen_string_literal: true
require "spec_helpers"

describe Wayfarer::Configuration do
  let(:config) { Configuration.new }

  describe "::new" do
    it "overrides defaults" do
      config = Configuration.new(http_adapter: :selenium)
      expect(config.http_adapter).to be :selenium
    end
  end

  it "sets keys and values" do
    config.foo = :foo
    expect(config.foo).to be :foo
  end

  describe "#reset!" do
    it "resets to defaults" do
      config.max_http_redirects = 5
      config.reset!
      expect(config.max_http_redirects).to be 3
    end
  end
end
