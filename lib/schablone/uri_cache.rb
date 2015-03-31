require "lru_redux"

module Schablone
  class URICache

    attr_reader :hosts

    def initialize
      @hosts = {}
    end

    def <<(uri)
      (@hosts[uri.host] ||= []) << uri.to_s
    end

    def include?(uri)
      return false unless @hosts.key?(host = uri.host)
      @hosts[host].include?(uri.to_s)
    end

  end
end
