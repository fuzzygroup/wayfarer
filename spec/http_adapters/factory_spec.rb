require "spec_helpers"

describe Schablone::HTTPAdapters::Factory do
  subject(:factory) { Factory }

  describe "::instance" do
    after { factory.free_instances }

    context "when config.http_adapter is :net_http" do
      it "returns a NetHTTPAdapter" do
        expect(factory.instance).to be_a NetHTTPAdapter
      end

      it "returns a singleton" do
        factory.instance
        factory.instance
        expect(factory.instances.count).to be 1
      end
    end

    context "when config.http_adapter is :selenium", live: true do
      before { Schablone.config.http_adapter = :selenium }
      after  { Schablone.config.reset! }

      it "returns a SeleniumAdapter" do
        expect(factory.instance).to be_a SeleniumAdapter
      end

      it "returns multiple instances" do
        factory.instance
        factory.instance
        expect(factory.instances.count).to be 2
      end
    end
  end

  describe "::free_instances" do
    let(:adapter_a) { spy() }
    let(:adapter_b) { spy() }

    before do
      factory.instance_variable_set(:@instances, [adapter_a, adapter_b])
    end

    after do
      factory.free_instances
      factory.instance_variable_set(:@instances, [])
    end

    it "calls #free on all instances" do
      factory.free_instances
      [adapter_a, adapter_b].each do |adapter|
        expect(adapter).to have_received(:free)
      end
    end

    it "empties its instance list" do
      factory.free_instances
      expect(factory.instances).to be_empty
    end
  end
end
