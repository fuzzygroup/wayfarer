require "spec_helpers"

module Scrapespeare
  describe URIPaginator do

    let(:paginator) do
      URIPaginator.new(
        HTTPClient.new,
        Parser,
        {}
      )
    end

    describe "#initialize" do
      it "sets @rule_set" do
        expect(paginator.rule_set).to eq({})
      end
    end

  end
end
