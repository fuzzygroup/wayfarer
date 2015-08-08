require "spec_helpers"

describe Wayfarer::HTTPAdapters::AdapterPool do
  subject(:adapter_pool) { AdapterPool.new }

  describe "#with" do
    context "when using Net::HTTP" do
      it "yields a NetHTTPAdapter" do
        adapter_pool.with do |adapter|
          expect(adapter).to be_a NetHTTPAdapter
        end
      end
    end

    context "when using Selenium", live: true do
      before { Wayfarer.config.http_adapter = :selenium }
      after  { Wayfarer.config.reset! }

      it "yields a SeleniumAdapter" do
        adapter_pool.with do |adapter|
          expect(adapter).to be_a SeleniumAdapter
        end
      end
    end
  end
end
