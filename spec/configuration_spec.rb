require "spec_helpers"

module Scrapespeare
  describe Configuration do

    let(:config) { Configuration.new }

    it "allows setting keys and values" do
      config.foo = :foo
      expect(config.foo).to be :foo
    end

    it "has correct default values set" do
      expect(config.http_adapter).to be :rest_client
      expect(config.verbose).to be false
      expect(config.max_http_redirects).to be 3
      expect(config.selenium_argv).to eq [:firefox]
    end

    it "allows overriding default values" do
      config.verbose = true
      expect(config.verbose).to be true
    end

    describe "#reset!" do
      it "resets keys and values to defaults" do
        config.verbose = true
        config.reset!
        expect(config.verbose).to be false
      end

      it "unsets non-default keys" do
        config.foo = :foo
        config.reset!
        expect(config.foo?).to be false
      end
    end

  end
end
