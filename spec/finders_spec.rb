require "spec_helpers"

describe Wayfarer::Finders do
  let(:page) { fetch_page(test_app("/links/links.html")) }

  describe "#links" do
    context "without CSS selector/XPath expression" do
      it "returns all links" do
        expect(page.links("a").map(&:to_s)).to eq %w(
          http://0.0.0.0:9876/foo
          http://0.0.0.0:9876/bar
          http://0.0.0.0:9876/baz
          http://0.0.0.0:9876/links/foo
          http://0.0.0.0:9876/links/bar
          http://0.0.0.0:9876/links/baz
          http://google.com
          http://yahoo.com
          http://aol.com
        )
      end
    end

    context "with paths" do
      it "returns selected links" do
        expect(page.links("ul li:nth-child(3) a").map(&:to_s)).to eq %w(
          http://0.0.0.0:9876/baz
        )
      end
    end
  end
end
