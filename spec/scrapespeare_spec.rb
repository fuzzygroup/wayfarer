require "spec_helpers"

describe Scrapespeare do

  describe "VERSION" do
    it "has a VERSION" do
      expect(defined? Scrapespeare::VERSION)
    end
  end

  describe "#config" do
    it "is set to the default configuration as default" do
      expect(Scrapespeare.config.http_adapter).to be :net_http
      expect(Scrapespeare.config.verbose).to be false
    end
  end

end
