require "spec_helpers"

describe Wayfarer::Configuration do
  let(:config) { Configuration.new }

  it "allows setting keys and values" do
    config.foo = :foo
    expect(config.foo).to be :foo
  end

  describe "#reset!" do
    it "resets to defaults" do
      config.max_http_redirects = 3
      config.reset!
      expect(config.max_http_redirects).to be 3
    end
  end
end
