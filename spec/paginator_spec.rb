require "spec_helpers"

module Scrapespeare
  describe Paginator do

    let(:paginator) do
      Paginator.new(HTTPAdapters::RestClientAdapter.new, Parser)
    end

    describe "#initialize" do
      it "sets @http_adapter" do
        expect(paginator.http_adapter).not_to be nil
      end

      it "sets @parser" do
        expect(paginator.parser).not_to be nil
      end

      it "sets @state" do
        expect(paginator.state).to eq({})
      end
    end

    describe "#has_successor_uri?" do
      context "#successor_uri returns a falsey value" do
        before { paginator.define_singleton_method(:successor_uri) { nil } }

        it "returns false" do
          expect(paginator.send(:has_successor_uri?)).to be false
        end
      end

      context "#successor_uri returns a truthy value" do
        before { paginator.define_singleton_method(:successor_uri) { true } }

        it "returns false" do
          expect(paginator.send(:has_successor_uri?)).to be true
        end
      end
    end

  end
end