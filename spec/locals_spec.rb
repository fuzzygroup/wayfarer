require "spec_helpers"

describe Wayfarer::Locals do
  let(:klass) { Class.new.include(Locals) }

  describe "::let" do
    it "proxies locals via method_missing" do
      obj = Object.new
      klass.let(:foo) { obj }
      inst = klass.new
      expect(inst.foo).to be obj
    end

    context "when value is an Array" do
      it "adds a ThreadSafe::Array" do
        klass.let(:foo) { [] }
        expect(klass.locals[:foo]).to be_a ThreadSafe::Array
      end
    end

    context "when value is a Hash" do
      it "adds a ThreadSafe::Hash" do
        klass.let(:foo) { {} }
        expect(klass.locals[:foo]).to be_a ThreadSafe::Hash
      end
    end
  end
end
