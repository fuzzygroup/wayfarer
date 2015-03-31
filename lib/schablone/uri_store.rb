module Schablone
  class URIStore

    def initialize
      @hosts = {}
    end

    def <<(uri)
      (@hosts[uri.host] ||= Set.new([])) << normalize(uri.to_s)
    end

    def include?(uri)
      return false unless @hosts.key?(host = uri.host)
      normalized_uri_str = normalize(uri.to_s)
      @hosts[host].include?(normalized_uri_str)
    end

    def to_a
      @hosts.inject([]) do |array, (_, set)|
        uris = set.to_a.map { |uri_str| URI(uri_str) }
        array.concat(uris)
      end
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
