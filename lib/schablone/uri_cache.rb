require "lru_redux"

module Schablone
  class URICache

    def initialize
      @hosts = {}
      @cache = LruRedux::Cache.new(128)
    end

    def <<(uri)
      (@hosts[uri.host] ||= Set.new([])) << normalize(uri.to_s)
    end

    def include?(uri)
      normalized_uri_str = normalize(uri.to_s)

      return true if @cache[normalized_uri_str]
      return false unless @hosts.key?(host = uri.host)
      
      if @hosts[host].include?(normalized_uri_str)
        @cache[normalized_uri_str] = true
      else
        false
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
