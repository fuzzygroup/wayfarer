require "uri"
require "thread"

module Scrapespeare
  class Processor

    attr_reader :current_uris
    attr_reader :staged_uris
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

    def next_uri
      @current_uris.shift
    end

    def has_next_uri?
      return true unless @current_uris.empty?
    end

    def stage_uri(uri)
      @staged_uris << uri unless @cached_uris.include?(uri)
    end

    def cache_uri(uri)
      @cached_uris << uri
    end

    def cycle
      @current_uris, @staged_uris = @staged_uris, []
    end

  end
end
