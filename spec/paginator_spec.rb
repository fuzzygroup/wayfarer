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
    end

  end
end