require "spec_helpers"

module Scrapespeare
  describe Paginator do

    let(:paginator) do
      Paginator.new(HTTPClient.new, Parser)
    end

    describe "#initialize" do
      it "sets @http_adapter" do
        expect(paginator.http_adapter).not_to be nil
      end

      it "sets @parser" do
        expect(paginator.parser).not_to be nil
      end
    end

    describe "#successor_doc" do
      it "returns nil" do
        expect(paginator.send(:successor_doc)).to be nil
      end
    end

    describe "#paginate" do
      before do
        paginator.define_singleton_method(:successor_doc) do
          # TODO This hurts my brain
          ((@counter ||= 0) < 5) ? (@counter += 1 and true) : nil
        end
      end

      it "yields objects while #successor_doc returns a truthy value" do
        yield_count = 0
        paginator.paginate("http://example.com") { |_| yield_count += 1 }
        expect(yield_count).to be 5
      end

      it "sets @uri" do
        paginator.paginate("http://example.com") { |_| }
        expect(paginator.instance_variable_get(:@uri)).to eq \
          "http://example.com"
      end
    end

  end
end