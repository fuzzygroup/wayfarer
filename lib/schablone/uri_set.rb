module Schablone
  class URISet

    def initialize
      @uris = Set.new
    end

    def <<(uri)
      @uris << normalize(uri.to_s)
    end

    def include?(uri)
      @uris.include?(normalize(uri.to_s))
    end

    def to_a
      @uris.to_a.map { |uri_str| URI(uri_str) }
    end

    private

    def normalize(uri_str)
      truncate_trailing_slash(truncate_fragment_identifier(uri_str))
    end

    def truncate_fragment_identifier(uri_str)
      uri_str.sub(/#.*/, "")
    end

    def truncate_trailing_slash(uri_str)
      uri_str.chomp("/")
    end

  end
end
