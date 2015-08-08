require "spec_helpers"

describe Wayfarer::Configuration do
  let(:config) { subject.class.new }

  it "allows setting keys and values" do
    config.foo = :foo
    expect(config.foo).to be :foo
  end

  describe "#reset!" do
    it "resets keys and values to defaults" do
      config.max_http_redirects = 3
      config.reset!
      expect(config.max_http_redirects).to be 3
    end

    it "unsets non-default keys" do
      config.foo = :foo
      config.reset!
      expect(config.foo).to be nil
    end
  end
end
