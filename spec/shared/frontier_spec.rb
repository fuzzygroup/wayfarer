# frozen_string_literal: true
require "securerandom"

RSpec.shared_examples "Frontier" do |klass|
  subject(:frontier) { klass.new(Configuration.new(uuid: SecureRandom.uuid)) }

  after { frontier.free }

  describe "#stage" do
    let(:uri) { URI("http://example.com/foo#bar") }

    it "stages a URI" do
      expect do
        frontier.stage("http://example.com")
      end.to change { frontier.staged_uris.count }.by(1)
    end

    it "stages multiple URIs" do
      expect do
        frontier.stage("http://example.com", "http://google.com")
      end.to change { frontier.staged_uris.count }.by(2)
    end
  end

  describe "#cache" do
    it "caches a URI" do
      expect do
        frontier.cache("http://example.com")
      end.to change { frontier.cached_uris.count }.by(1)
    end

    it "caches multiple URIs" do
      expect do
        frontier.cache("http://example.com", "http://google.com")
      end.to change { frontier.cached_uris.count }.by(2)
    end
  end

  describe "#cycle" do
    let(:uri) { URI("http://example.com") }

    it "does not stage the same URI twice" do
      frontier.stage(uri)
      frontier.stage(uri)

      expect do
        frontier.cycle
      end.to change { frontier.current_uris.count }.by(1)
    end

    it "caches URIs" do
      frontier.stage(uri)
      frontier.cycle
      frontier.cycle
      expect(frontier.cached_uris).to eq [uri]
    end

    context "with staged URIs" do
      before { frontier.stage(uri) }

      it "swaps current and staged URIs" do
        frontier.cycle
        expect(frontier.current_uris).to eq [uri]
        expect(frontier.staged_uris).to eq []
      end

      it "returns true" do
        expect(frontier.cycle).to be true
      end
    end

    context "without staged URIs" do
      it "returns false" do
        expect(frontier.cycle).to be false
      end
    end

    it "does not set cached URIs as current" do
      frontier.cache(uri)
      frontier.stage(uri)
      frontier.cycle

      expect(frontier.current_uris).to be_empty
    end

    context "when circulation is allowed" do
      subject(:frontier) do
        klass.new(Configuration.new(allow_circulation: true))
      end

      it "sets cached URIs as current" do
        3.times do
          frontier.stage(uri)
          frontier.cycle
          expect(frontier.current_uris).to eq [uri]
        end
      end
    end
  end
end
