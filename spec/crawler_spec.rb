require "spec_helpers"

describe Schablone::Crawler do
  let(:crawler) { Crawler.new }

  describe "#threadsafe" do
    it "stores a Threadsafe" do
      crawler.threadsafe(:foo) { Object.new }
      crawler.threadsafe(:bar, Object.new)

      expect(crawler.threadsafes[:foo]).to be_a Threadsafe
      expect(crawler.threadsafes[:bar]).to be_a Threadsafe
    end
  end

  describe "#crawl" do
    it "returns an OpenStruct of Threadsafes" do
      crawler.threadsafe(:foo) { 42 }
      expect(crawler.crawl.foo).to be 42
    end
  end
end
