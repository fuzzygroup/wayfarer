require "spec_helpers"

describe Schablone::Processor do
  let(:indexer)       { Proc.new {} }
  let(:router)        { Router.new }
  subject(:processor) { Processor.new(router) }

  it "is idle initially" do
    expect(processor).to be_idle
  end

  describe "#step" do
    let(:uri) { URI("http://example.com") }

    before do
      processor.navigator.stage(uri)
      processor.navigator.cycle
    end

    it "halts" do
      processor.run
      expect(processor).to be_halted
    end

    it "caches URIs" do
      processor.step
      expect(processor.navigator.cached_uris).to eq [uri]
    end

    it "stages URIs" do
      router.register_payload(:foo, &Proc.new { visit("http://google.com") })
      router.draw(:foo) { host "example.com" }
      processor.step
      expect(processor.navigator.current_uris).to eq [URI("http://google.com")]
    end

    context "with staged URIs" do
      it "does not halt" do
        router.register_payload(:foo, &Proc.new { visit("http://google.com") })
        router.draw(:foo) { host "example.com" }
        processor.step
        expect(processor).not_to be_halted
      end
    end

    context "without staged URIs" do
      it "halts" do
        router.register_payload(:foo, &Proc.new {})
        router.draw(:foo) { host "example.com" }
        processor.step
        expect(processor.state).to be :halted
      end
    end
  end
end
