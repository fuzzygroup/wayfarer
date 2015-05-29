require "spec_helpers"

describe Schablone::HTTPAdapters::AdapterPool do
  describe "#with" do
    context "when config.http_adapter is :net_http" do
      it "yields a NetHTTPAdapter" do
        yielded = nil
        AdapterPool.with { |adapter| yielded = adapter }
        expect(yielded).to be_a NetHTTPAdapter 
      end
    end

    context "when config.http_adapter is :selenium" do
      before { Schablone.config.http_adapter = :selenium }
      after { Schablone.config.reset! }

      it "yields a SeleniumAdapter" do
        yielded = nil
        AdapterPool.with { |adapter| yielded = adapter }
        expect(yielded).to be_a SeleniumAdapter 
      end
    end
  end
end
