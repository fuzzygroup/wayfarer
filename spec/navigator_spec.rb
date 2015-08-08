require "spec_helpers"

describe Wayfarer::Navigator do
  subject(:navigator) { Navigator.new }

  describe "#stage" do
    let(:uri) { URI("http://example.com/foo#bar") }

    it "stages a URI" do
      expect {
        navigator.stage("http://example.com")
      }.to change { navigator.staged_uris.count }.by(1)
    end

    it "stages multiple URIs" do
      expect {
        navigator.stage("http://example.com", "http://google.com")
      }.to change { navigator.staged_uris.count }.by(2)
    end
  end

  describe "#cache" do
    it "caches a URI" do
      expect {
        navigator.cache("http://example.com")
      }.to change { navigator.cached_uris.count }.by(1)
    end

    it "caches multiple URIs" do
      expect {
        navigator.cache("http://example.com", "http://google.com")
      }.to change { navigator.cached_uris.count }.by(2)
    end
  end

  describe "#cycle" do
    let(:uri) { URI("http://example.com") }

    it "does not stage the same URI twice" do
      navigator.stage(uri)
      navigator.stage(uri)

      expect {
        navigator.cycle
      }.to change { navigator.current_uris.count }.by(1)
    end

    it "caches URIs" do
      navigator.stage(uri)
      navigator.cycle
      navigator.cycle
      expect(navigator.cached_uris).to eq [uri]
    end

    context "with staged URIs" do
      before { navigator.stage(uri) }

      it "swaps current and staged URIs" do
        navigator.cycle
        expect(navigator.current_uris).to eq [uri]
        expect(navigator.staged_uris).to eq []
      end

      it "returns true" do
        expect(navigator.cycle).to be true
      end
    end

    context "without staged URIs" do
      it "returns false" do
        expect(navigator.cycle).to be false
      end
    end

    it "does not set cached URIs as current" do
      navigator.cache(uri)
      navigator.stage(uri)
      navigator.cycle

      expect(navigator.current_uris).to be_empty
    end

    context "when circulation is allowed" do
      before { Wayfarer.config.allow_circulation = true }
      after  { Wayfarer.config.reset! }

      it "allows re-staging cached URIs" do
        3.times do
          navigator.stage(uri)
          navigator.cycle
          expect(navigator.current_uris).to eq [uri]
        end
      end
    end
  end
end
