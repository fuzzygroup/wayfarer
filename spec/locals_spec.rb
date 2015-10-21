require "spec_helpers"

describe Wayfarer::Locals do
  let(:klass) { Class.new.include(Locals) }

  describe "::let" do
    it "adds a local" do
      klass.let(:foo) { :bar }
      expect(klass.locals[:foo]).to be :bar
    end

    it "defines an instance reader method" do
      obj = Object.new
      klass.let(:foo) { obj }
      inst = klass.new
      expect(inst.foo).to be obj
    end
  end
end
