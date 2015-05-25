require "spec_helpers"

describe Schablone::Crawler do
  let(:crawler) { Crawler.new }

  describe "#let" do
    it "creates threadsafe locals" do
      crawler.let :foo, Object.new
      expect(crawler.locals[:foo]).to be_a Threadsafe
    end
  end

  describe "#let!" do
    it "creates locals" do
      crawler.let! :foo, obj = Object.new
      expect(crawler.locals[:foo]).to be obj
    end
  end
end
