require "spec_helpers"

module Scrapespeare
  class Scoper

    describe "#initialize" do
      let(:scoper) do
        Scoper.new(css: ".foo")
      end

      it "sets @matcher" do
        matcher = scoper.matcher
        expect(matcher.type).to be :css
        expect(matcher.expression).to eq ".foo"
      end
    end

  end
end
