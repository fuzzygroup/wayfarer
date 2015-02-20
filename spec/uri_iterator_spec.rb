require "spec_helpers"

module Scrapespeare
  describe URIIterator do

    describe "#initialize" do
      let(:iterator) { URIIterator.new("http://example.com") }

      it "sets @uri" do
        expect(iterator.uri.to_s).to eq "http://example.com"
      end

      it "sets @rule_set" do
        expect(iterator.rule_set).to eq({})
      end
    end

    describe "#set_query_param" do
      context "without query parameter present" do
        let(:iterator) { URIIterator.new("http://example.com") }

        it "sets the query parameter" do
          iterator.send(:set_query_param, "foo", "bar")
          expect(iterator.uri.to_s).to eq "http://example.com?foo=bar"
        end
      end

      context "with query parameter present" do
        let(:iterator) { URIIterator.new("http://example.com?foo=baz") }

        it "updates the query parameter" do
          iterator.send(:set_query_param, "foo", "bar")
          expect(iterator.uri.to_s).to eq "http://example.com?foo=bar"
        end
      end
    end

  end
end
