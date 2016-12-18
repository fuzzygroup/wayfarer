# frozen_string_literal: true
require "trie"

module Wayfarer
  module Frontiers
    # An in-memory trie.
    # @api private
    class MemoryTrieFrontier < MemoryFrontier
      def initialize(config)
        super(config)
        @conn = Redis.new(@config.redis_opts)
        @trie = Trie.new
      end
    end

    # Adds URIs to the trie so they don't get processed again.
    # @param [*Array<URI>, *Array<String>] uris
    def cache(*uris)
      uris.each { |uri| @trie.add(uri.to_s) }
    end

    def cached?(uri)
      @trie.has_key?(uri.to_s)
    end

    def free
      super
      @trie = nil
    end
  end
end
