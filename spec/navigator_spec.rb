require "spec_helpers"

describe Schablone::Navigator do
  let(:router) { Router.new }
  subject(:navigator) { Navigator.new(router) }

  describe "#stage" do
    let(:uri) { URI("http://example.com/foo#bar") }

    it "stages a URI" do
      expect {
        navigator.stage(uri)
      }.to change { navigator.staged_uris.count }.by(1)
    end
  end

  describe "#cache" do
    let(:uri) { URI("http://example.com") }

    it "caches URIs" do
      expect {
        navigator.cache(uri)
      }.to change { navigator.cached_uris.count }.by(1)
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

    it "does not set the same URI as current twice" do
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
  end

  describe "#current_uri_queue" do
    it "returns a Queue of the expected size" do
      navigator.instance_variable_set(:@current_uris, Set.new([1, 2, 3]))
      expect(navigator.current_uri_queue.size).to be 3
    end
  end

  describe "#filter_staged_uris" do
    let(:uri) { URI("http://example.com") }

    it "filters staged URIs included in @current_uris" do
      navigator.instance_variable_set(:@current_uris, Set.new([uri]))
      navigator.stage(uri)

      expect {
        navigator.send(:filter_staged_uris)
      }.to change { navigator.staged_uris.count }.by(-1)
    end

    it "filters URIs included in @cached_uris" do
      navigator.cache(uri)
      navigator.stage(uri)

      expect {
        navigator.send(:filter_staged_uris)
      }.to change { navigator.staged_uris.count }.by(-1)
    end
  end
end
