require "spec_helpers"

describe Schablone::HTTPAdapters::Factory do
  subject(:factory) { Factory }

  describe "::adapter_instance" do
    context "when config.http_adapter is :net_http" do
      it "returns a singleton NetHTTPAdapter" do
        a = factory.adapter_instance
        b = factory.adapter_instance

        expect(a).to be_a NetHTTPAdapter
        expect(a).to be b
      end
    end

    context "when config.http_adapter is :selenium", live: true do
      before { Schablone.config.http_adapter = :selenium }
      after  { Schablone.config.reset! }

      it "returns an instance of SeleniumAdapter" do
        a = factory.adapter_instance
        b = factory.adapter_instance

        expect(a).to be_a SeleniumAdapter
        expect(a).not_to be b
      end
    end
  end
end
