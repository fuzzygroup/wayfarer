require "spec_helpers"

describe Schablone::URIStore do
  subject(:store) { URIStore.new }

  describe "#include?" do
    let(:uri) { URI("http://example.com") }

    context "with stored URI" do
      before { store << uri }

      it "returns `true`" do
        expect(store).to include uri
      end
    end

    context "with non-stored URI" do
      it "returns `false`" do
        expect(store).not_to include uri
      end
    end

    it "is insensitive to trailing slashes" do
      store << uri
      dup_uri = URI("http://example.com/")
      expect(store).to include dup_uri
    end

    it "is insensitive to fragment identifiers" do
      store << uri

      dup_uris = %w(
        http://example.com#foo
        http://example.com/#foo
      ).map { |str| URI(str) }

      dup_uris.each do |dup_uri|
        expect(store).to include dup_uri
      end
    end
  end

  describe "#truncate_fragment_identifier" do
    it "truncates fragment identifiers" do
      uri_strs = %w(
        http://example.com
        http://example.com#foo
        http://example.com#/foo
        http://example.com/#/foo/
        http://example.com/foo#bar
        http://example.com/foo?bar=qux#quux
      )

      truncated_uri_strs = uri_strs.map do |uri_str|
        store.send(:truncate_fragment_identifier, uri_str)
      end

      expect(truncated_uri_strs).to eq %w(
        http://example.com
        http://example.com
        http://example.com
        http://example.com/
        http://example.com/foo
        http://example.com/foo?bar=qux
      )
    end
  end

  describe "#truncate_trailing_slash" do
    it "truncates trailing slashes" do
      uri_strs = %w(
        http://example.com
        http://example.com/
        http://example.com#/foo/
        http://example.com/#/foo/
        http://example.com/foo#bar/qux/
        http://example.com/foo?bar=qux#quux/
      )

      truncated_uri_strs = uri_strs.map do |uri_str|
        store.send(:truncate_trailing_slash, uri_str)
      end

      expect(truncated_uri_strs).to eq %w(
        http://example.com
        http://example.com
        http://example.com#/foo
        http://example.com/#/foo
        http://example.com/foo#bar/qux
        http://example.com/foo?bar=qux#quux
      )
    end
  end

  describe "#normalize" do
    it "truncates trailing slashes and fragment identifiers" do
      uri_strs = %w(
        http://example.com
        http://example.com/
        http://example.com#/foo/
        http://example.com/#/foo/
        http://example.com/foo#bar/qux/
        http://example.com/foo?bar=qux#quux/
      )

      normalized_uri_strs = uri_strs.map do |uri_str|
        store.send(:normalize, uri_str)
      end

      expect(normalized_uri_strs).to eq %w(
        http://example.com
        http://example.com
        http://example.com
        http://example.com
        http://example.com/foo
        http://example.com/foo?bar=qux
      )
    end
  end

  describe "#to_a" do
    it "returns the correct Array representation" do
      uris = %w(
        http://example.com
        http://google.com
        http://yahoo.com
      ).map { |str| URI(str) }

      uris.each { |uri| store << uri }

      expect(store.to_a).to eq uris
    end
  end
end
