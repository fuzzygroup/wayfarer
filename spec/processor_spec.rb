require "spec_helpers"

describe Schablone::Processor do

  let(:scraper) { Scraper.new.css(:title, "title") }
  let(:router) do
    router = Router.new
    router.allow.host("example.com")
    router
  end

  subject(:processor) { Processor.new(scraper, router) }

  describe "#initialize" do
    it "sets `@current_uris` to an empty list" do
      expect(processor.current_uris).to eq []
    end

    it "sets `@staged_uris` to an empty list" do
      expect(processor.staged_uris).to eq []
    end

    it "sets `@processed_uris` to an empty list" do
      expect(processor.processed_uris).to eq []
    end
  end

  describe "#stage" do
    let(:uri) { URI("http://example.com") }

    it "stages a URI" do
      expect {
        processor.send(:stage, uri)
      }.to change { processor.staged_uris.count }.by(1)
    end

    context "with processed URI" do
      before { processor.instance_variable_set(:@processed_uris, [uri]) }

      it "does not stage the URI" do
        expect {
          processor.send(:stage, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end

    context "with staged URI" do
      before { processor.send(:stage, uri) }

      it "does not stage the URI again" do
        expect {
          processor.send(:stage, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end

    context "with URI forbidden by `@router`" do
      before { router.forbid.host("example.com") }

      it "does not stage the URI" do
        expect {
          processor.send(:stage, uri)
        }.not_to change { processor.staged_uris.count }
      end
    end
  end

  describe "#current?" do
    let(:uri) { URI("http://example.com") }

    context "with current URI" do
      before { processor.instance_variable_set(:@current_uris, [uri]) }

      it "returns `true`" do
        expect(processor.send(:current?, uri)).to be true
      end
    end

    context "with non-current URI" do
      it "returns `false`" do
        expect(processor.send(:current?, uri)).to be false
      end
    end
  end

  describe "#staged?" do
    let(:uri) { URI("http://example.com") }

    context "with staged URI" do
      before { processor.send(:stage, uri) }

      it "returns `true`" do
        expect(processor.send(:staged?, uri)).to be true
      end
    end

    context "with non-staged URI" do
      it "returns `false`" do
        expect(processor.send(:staged?, uri)).to be false
      end
    end
  end

  describe "#processed?" do
    let(:uri) { URI("http://example.com") }

    context "with processed URI" do
      before { processor.instance_variable_set(:@processed_uris, [uri]) }

      it "returns `true`" do
        expect(processor.send(:processed?, uri)).to be true
      end
    end

    context "with unprocessed URI" do
      it "returns `false`" do
        expect(processor.send(:processed?, uri)).to be false
      end
    end
  end

  describe "#cycle" do
    before do
      processor.instance_variable_set(:@staged_uris, [:staged])
      processor.send(:cycle)
    end

    it "sets `@current_uris` to `@staged_uris`" do
      expect(processor.current_uris).to eq [:staged]
    end

    it "sets `@staged_uris` to an empty list" do
      expect(processor.staged_uris).to eq []
    end
  end

end
