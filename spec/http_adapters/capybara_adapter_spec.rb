require "spec_helpers"

module Scrapespeare
  module HTTPAdapters
    describe CapybaraAdapter do

      let(:adapter) { CapybaraAdapter.new }

      describe "#initialize" do
        it "works" do
          adapter.session.visit "http://google.com"
        end
      end

    end
  end
end
