require "spec_helpers"

describe Wayfarer::Worker do
  let(:adapter_pool) { AdapterPool.new(Wayfarer.config) }

  describe "#work" do
    it "instantiates a job and invokes it" do
      klass = Class.new do
        class << self
          attr_accessor :adapter
        end

        def invoke(*, adapter)
          self.class.adapter = adapter
          :foo
        end
      end

      return_value = Worker.new.work(nil, klass, adapter_pool)

      expect(return_value).to be :foo
      expect(klass.adapter).to be_a NetHTTPAdapter
    end
  end
end
