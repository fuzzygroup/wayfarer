# frozen_string_literal: true
require "spec_helpers"

describe Wayfarer::Processor do
  subject!(:processor) { Processor.new(Wayfarer.config) }

  describe "#halted?" do
    context "when not halted" do
      it "returns false" do
        expect(processor.halted?).to be false
      end
    end

    context "when halted" do
      it "returns true" do
        processor.halt!
        expect(processor.halted?).to be true
      end
    end
  end

  describe "#frontier" do
    context "when memory frontier is used" do
      it "returns a MemoryFrontier" do
        expect(processor.frontier).to be_a MemoryFrontier
      end
    end

    context "when Redis frontier is used" do
      let(:config) { Configuration.new(frontier: :redis) }
      subject(:processor) { Processor.new(config) }

      it "returns a MemoryFrontier" do
        expect(processor.frontier).to be_a RedisFrontier
      end
    end

    context "when memory bloomfilter is used" do
      let(:config) { Configuration.new(frontier: :memory_bloom) }
      subject(:processor) { Processor.new(config) }

      it "returns a MemoryBloomfilter" do
        expect(processor.frontier).to be_a MemoryBloomfilter
      end
    end

    context "when Redis bloomfilter is used" do
      let(:config) { Configuration.new(frontier: :redis_bloom) }
      subject(:processor) { Processor.new(config) }

      it "returns a RedisBloomfilter" do
        expect(processor.frontier).to be_a RedisBloomfilter
      end
    end

    context "with other value" do
      let(:config) { Configuration.new(frontier: :foobar) }
      subject(:processor) { Processor.new(config) }

      it "returns a MemoryTrieFrontier" do
        expect(processor.frontier).to be_a MemoryTrieFrontier
      end
    end
  end
end
