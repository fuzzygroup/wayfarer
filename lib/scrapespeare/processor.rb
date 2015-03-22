require "uri"
require "thread"

module Scrapespeare
  class Processor

    attr_reader :cached_uris

    def initialize()
      @fetcher = Fetcher.new

      @current_uris = []
      @staged_uris  = []
      @cached_uris  = []
    end

    def process
    end

    private
    def fetch(uri)
      @fetcher.fetch(uri)
    end

    def cache_uri(uri)
      @cached_uris << uri
    end

  end
end
