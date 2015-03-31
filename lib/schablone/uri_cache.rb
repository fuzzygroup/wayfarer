require "lru_redux"

module Schablone
  class URICache

    attr_reader :hosts

    def initialize
      @hosts = {}
    end

    def <<(uri)
      (@hosts[uri.host] ||= []) << normalize(uri)
    end

    def include?(uri)
      return false unless @hosts.key?(host = uri.host)
      @hosts[host].include?(normalize(uri))
    end

    private

    def normalize(uri)
      truncate_trailing_slash(truncate_fragment_identifier(uri.to_s))
    end

    def truncate_fragment_identifier(uri_str)
      uri_str.sub(/#.*/, "")
    end

    def truncate_trailing_slash(uri_str)
      uri_str.chomp("/")
    end

  end
end
