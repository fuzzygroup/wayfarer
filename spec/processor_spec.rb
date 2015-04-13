require "spec_helpers"

describe Schablone::Processor do
  let(:entry_uri)     { URI("http://example.com") }
  let(:scraper)       { Proc.new { emit(:success) } }
  let(:router)        { Router.new }
  let(:emitter)       { Emitter.new }
  subject(:processor) { Processor.new(entry_uri, router, emitter) }

  before { router.register(:foo, &scraper) }

  describe "#initialize" do
    it "adds `entry_uri` to fuck this bullshit" do
      expect(processor.navigator.current_uris).to eq [entry_uri]
    end

    it "sets its `@state` to `:idle`" do
      expect(processor.state).to be :idle
    end
  end

  describe "#run" do
    let(:entry_uri) { URI("http://0.0.0.0:9876/graph/index.html") }
    before { router.map(:foo) { host("0.0.0.0") } }
    before { Schablone.config.log_level = Logger::INFO }
    after { Schablone.config.reset! }

    it "emits as expected" do
      processor.instance_variable_set(:@emitter, emitter = spy())
      processor.run
      expect(emitter).to have_received(:emit).exactly(6).times
    end

    context "with halting `Scraper`" do
      let(:scraper) { Proc.new { emit(:success); halt } }

      it "halts" do
        processor.run
        expect(processor.state).to be :halted
      end
    end
  end

  describe "#step" do
    it "clears its worker references" do
      processor.send(:step)
      expect(processor.workers).to eq []
    end
  end

  describe "#halt" do
    context "when `@state` is `:running`" do
      before { processor.instance_variable_set(:@state, :running) }

      it "throws `:halt`" do
        expect {
          processor.send(:halt)
        }.to throw_symbol :halt
      end

      it "frees its `Fetcher`" do
        fetcher = spy()
        processor.instance_variable_set(:@fetcher, fetcher)
        catch(:halt) { processor.send(:halt) }
        expect(fetcher).to have_received(:free)
      end

      it "sets `@state` to `:halted`" do
        catch(:halt) { processor.send(:halt) }
        expect(processor.state).to be :halted
      end

      it "returns `true`" do
        catch(:halt) { expect(processor.send(:halt)).to be true }
      end
    end

    context "when `@state` is not `:running`" do
      it "does not alter `@state`" do
        catch(:halt) { processor.send(:halt) }
        expect(processor.state).to be :idle
      end

      it "returns `false`" do
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
