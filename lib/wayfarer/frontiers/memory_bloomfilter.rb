# frozen_string_literal: true
require "bloomfilter-rb"

module Wayfarer
  module Frontiers
    # An in-memory bloomfilter.
    # @api private
    class MemoryBloomfilter < MemoryFrontier
      def initialize(config)
        super(config)
        @filter = BloomFilter::Native.new(config.bloomfilter_opts)
      end

      # Caches URIs so they don't get processed again.
      # @param [*Array<URI>, *Array<String>] uris
      def cache(*uris)
        uris.each { |uri| @filter.insert(uri) }
      end

      # Whether a URI is cached.
      def cached?(uri)
        @filter.include?(uri)
      end

      # Frees up memory.
      def free
        super
        @filter.clear
        @conn.disconnect!
      end
    end
  end
end
