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

    describe "#has_successor_doc?" do
      context "#successor_doc returns a falsey value" do
        before { paginator.define_singleton_method(:successor_doc) { nil } }

        it "returns false" do
          expect(paginator.send(:has_successor_doc?)).to be false
        end
      end

      context "#successor_doc returns a truthy value" do
        before { paginator.define_singleton_method(:successor_doc) { true } }

        it "returns false" do
          expect(paginator.send(:has_successor_doc?)).to be true
        end
      end
    end

    describe "#successor_doc" do
      it "returns nil" do
        expect(paginator.send(:successor_doc)).to be nil
      end
    end

    describe "#paginate" do
      
    end

  end
end