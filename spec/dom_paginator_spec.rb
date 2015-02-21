require "spec_helpers"

module Scrapespeare
  describe DOMPaginator do

    let(:paginator) do
      DOMPaginator.new(
        HTTPAdapters::RestClientAdapter.new,
        Parser,
        { css: "#foo" }
      )
    end

    describe "#initialize" do
      it "sets @matcher" do
        expect(paginator.matcher).to be_a Matcher
      end
    end

  end
end