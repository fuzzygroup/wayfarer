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

      it "evaluates the given block in its instance context" do
        context = nil

        scoper = Scoper.new(css: ".foo") do
          context = self
        end

        expect(context).to be scoper
      end
    end

  end
end
