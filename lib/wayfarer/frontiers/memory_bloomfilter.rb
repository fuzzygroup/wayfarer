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

      def filter_staged_uris!
        @staged_uris.delete_if { |uri| @filter.include?(uri) }
      end
    end
  end
end
