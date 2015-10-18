require "spec_helpers"

describe Wayfarer::Finders do
  let(:page) { fetch_page(test_app("/finders.html")) }

  describe "#links" do
    context "without paths" do
      it "returns all links" do
        expect(page.links.map(&:to_s)).to eq %w(
          http://0.0.0.0:9876/foo
          http://0.0.0.0:9876/bar
          http://0.0.0.0:9876/baz
          http://google.com
          http://yahoo.com
          http://aol.com
        )
      end
    end

    context "with paths" do
      it "returns targeted links" do
        expect(page.links("ul li:nth-child(3) a").map(&:to_s)).to eq %w(
          http://0.0.0.0:9876/baz
        )
      end
    end
  end

  describe "#stylesheets" do
    context "without paths" do
      it "returns all stylesheets" do
        expect(page.stylesheets.map(&:to_s)).to eq %w(
          http://0.0.0.0:9876/a.css
          http://0.0.0.0:9876/b.css
          http://google.com/c.css
        )
      end
    end

    context "with paths" do
      it "returns targeted stylesheets" do
        expect(page.stylesheets("#stylesheet-c").map(&:to_s)).to eq %w(
          http://google.com/c.css
        )
      end
    end
  end
end
