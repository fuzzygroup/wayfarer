require "spec_helpers"

describe Schablone::Navigator do
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

  describe "#current?" do
    let(:uri) { URI("http://example.com") }

    context "with current URI" do
      before { navigator.instance_variable_set(:@current_uris, [uri]) }

      it "returns true" do
        expect(navigator.send(:current?, uri)).to be true
      end
    end

    context "with non-current URI" do
      it "returns false" do
        expect(navigator.send(:current?, uri)).to be false
      end
    end
  end

  describe "#cached?" do
    let(:uri) { URI("http://example.com") }

    context "with cached URI" do
      before { navigator.send(:cache, uri) }

      it "returns true" do
        expect(navigator.send(:cached?, uri)).to be true
      end
    end

    context "with non-cached URI" do
      it "returns false" do
        expect(navigator.send(:cached?, uri)).to be false
      end
    end
  end

  describe "#cached?" do
    let(:uri) { URI("http://example.com") }

    context "with cached URI" do
      before { navigator.send(:cache, uri) }

      it "returns true" do
        expect(navigator.send(:cached?, uri)).to be true
      end
    end

    context "with unprocessed URI" do
      it "returns false" do
        expect(navigator.send(:cached?, uri)).to be false
      end
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

    context "with staged URIs" do
      before { navigator.stage(uri) }

      it "swaps @current_uris and @staged_uris" do
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

    context "when circulation is allowed" do
      before { Schablone.config.allow_circulation = true }
      after  { Schablone.config.reset! }

      it "allows re-staging cached URIs" do
        3.times do
          navigator.stage(uri)
          navigator.cycle
          expect(navigator.current_uris).to eq [uri]
        end
      end
    end
  end

  describe "#filter_staged_uris!" do
    let(:uri) { URI("http://example.com") }

    it "filters staged URIs included in @current_uris" do
      navigator.instance_variable_set(:@current_uris, Set.new([uri]))
      navigator.stage(uri)

      expect {
        navigator.send(:filter_staged_uris!)
      }.to change { navigator.staged_uris.count }.by(-1)
    end

    it "filters URIs included in @cached_uris" do
      navigator.cache(uri)
      navigator.stage(uri)

      expect {
        navigator.send(:filter_staged_uris!)
      }.to change { navigator.staged_uris.count }.by(-1)
    end
  end
end
