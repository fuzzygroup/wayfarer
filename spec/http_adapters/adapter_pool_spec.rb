require "spec_helpers"

describe Schablone::HTTPAdapters::AdapterPool do
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
      before { Schablone.config.http_adapter = :selenium }
      after  { Schablone.config.http_adapter = :selenium }

      it "yields a SeleniumAdapter" do
        adapter_pool.with do |adapter|
          expect(adapter).to be_a SeleniumAdapter
        end
      end
    end
  end
end
