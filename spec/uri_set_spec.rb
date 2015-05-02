require "spec_helpers"

describe Schablone::URISet do
  subject(:uri_set) { URISet.new }

  describe "#add" do
    
  end

  describe "#include?" do
    let(:uri) { URI("http://example.com") }

    context "with uri_setd URI" do
      before { uri_set << uri }

      it "returns `true`" do
        expect(uri_set).to include uri
      end
    end

    context "with non-uri_setd URI" do
      it "returns `false`" do
        expect(uri_set).not_to include uri
      end
    end

    it "is insensitive to trailing slashes" do
      uri_set << uri
      dup_uri = URI("http://example.com/")
      expect(uri_set).to include dup_uri
    end

    it "is insensitive to fragment identifiers" do
      uri_set << uri

      dup_uris = %w(
        http://example.com#foo
        http://example.com/#foo
      ).map { |str| URI(str) }

      dup_uris.each do |dup_uri|
        expect(uri_set).to include dup_uri
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
        uri_set.send(:truncate_fragment_identifier, uri_str)
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
        uri_set.send(:truncate_trailing_slash, uri_str)
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
        uri_set.send(:normalize, uri_str)
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

      uris.each { |uri| uri_set << uri }

      expect(uri_set.to_a).to eq uris
    end
  end

  describe "#method_missing" do
    let(:set) { spy }
    subject(:uri_set) { URISet.new(spy) }
    before { uri_set.instance_variable_set(:@set, set) }

    it "proxies missing methods to its @set" do
      uri_set.send(:foobar)
      expect(set).to have_received(:foobar)
    end
  end

  describe "#respond_to?" do
    context "with method recognized by @set" do
      it "returns true" do
        expect(uri_set).to respond_to(:difference)
      end
    end

    context "with method not recognized by @set" do
      it "returns false" do
        expect(uri_set).not_to respond_to(:foobar)
      end
    end
  end
end
