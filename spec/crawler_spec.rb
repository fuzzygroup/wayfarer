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

  describe "#uri_template" do
    it "registers an URI template" do
      expect {
        crawler.uri_template(:foo, "http://example.com")
      }.to change { crawler.uri_templates.count }
    end
  end

  describe "#method_missing" do
    it "allows "
  end
end
