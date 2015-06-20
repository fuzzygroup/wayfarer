require "spec_helpers"

describe Schablone::Scraper do
  describe "#scrape" do
    it "instantiate an Indexer and invokes it" do
      klass = Class.new do
        class << self
          attr_accessor :adapter
        end

        def invoke(*, adapter)
          self.class.adapter = adapter
          :return_value
        end
      end

      return_value = Scraper.new.scrape(nil, klass)
      expect(return_value).to be :return_value
      expect(klass.adapter).to be_a NetHTTPAdapter
    end
  end
end
