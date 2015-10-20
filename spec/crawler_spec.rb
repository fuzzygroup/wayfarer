require "spec_helpers"

describe Wayfarer::Crawler do
  let(:config) { Configuration.new() }

  subject(:crawler) { Crawler.new(Wayfarer.config) }

  describe "#processor" do
    it "initializes and registers a Processor" do
      
    end
  end
end
