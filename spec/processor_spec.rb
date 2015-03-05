require "spec_helpers"

describe Scrapespeare::Processor do

  subject(:processor) { Processor.new }

  describe "#stage_uri" do
    context "when given URI has not been processed yet" do
      it "stages the URI for processing" do
        uri = URI("http://google.com")
        processor.send(:stage_uri, uri)
        expect(processor.staged).to eq [uri]
      end
    end

    context "when given URI has been processed" do
      it "does not stage the URI for processing" do
        uri = URI("http://google.com")
        processor.send(:stage_uri, uri)
        expect(processor.staged).to eq [uri]
      end
    end
  end

end
