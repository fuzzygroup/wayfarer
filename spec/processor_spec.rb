require "spec_helpers"

describe Schablone::Processor do
  let(:entry_uri)     { URI("http://example.com") }
  let(:scraper)       { Proc.new { emit(:success); visit page.links } }
  let(:router)        { Router.new }
  subject(:processor) { Processor.new(entry_uri, router) }

  before { router.register_scraper(:foo, &scraper) }

  describe "#initialize" do
    it "adds the entry URI as current" do
      expect(processor.navigator.current_uris).to eq [entry_uri]
    end

    it "sets state to :idle" do
      expect(processor.state).to be :idle
    end
  end

  describe "#run" do
    it "sets state to :halted" do
      processor.run
      expect(processor.state).to be :halted
    end
  end

  describe "#step" do
    it "clears its workers" do
      processor.send(:step)
      expect(processor.workers).to eq []
    end
  end

  describe "#halt" do
    context "when state is :running" do
      before { processor.instance_variable_set(:@state, :running) }

      it "throws :halt" do
        expect {
          processor.send(:halt)
        }.to throw_symbol :halt
      end

      it "returns true" do
        catch(:halt) { expect(processor.send(:halt)).to be true }
      end
    end

    context "when state is not :running" do
      it "does not alter state" do
        expect {
          catch(:halt) { processor.send(:halt) }
        }.not_to change { processor.state }
      end

      it "returns false" do
        expect(processor.send(:halt)).to be false
      end
    end
  end

  describe "#spawn_workers" do
    let(:queue) { Queue.new }

    before { Schablone.config.threads = 2 }
    after { Schablone.config.reset! }

    it "spawns the expected number of workers" do
      expect {
        processor.send(:spawn_workers, queue)
      }.to change { processor.workers.count }.by(2)
    end
  end
end
