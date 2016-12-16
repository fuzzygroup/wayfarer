# frozen_string_literal: true
require "bloomfilter-rb"

module Wayfarer
  module Frontiers
    # An in-memory bloomfilter.
    # @private
    class MemoryBloomfilter
      def initialize(config)
        @config = config
        @current_uris = Set.new([])
        @staged_uris  = Set.new([])
        @filter = BloomFilter::Native.new(*config.bloomfilter_argv)
      end

      # Returns the URIs to be scraped in the current cycle.
      # @return [Array<URI>]
      def current_uris
        @current_uris.to_a
      end

      # Returns staged URIs.
      # @return [Array<URI>]
      def staged_uris
        @staged_uris.to_a
      end

      # Stages URIs for processing in the next cycle.
      # @param [*Array<URI>, *Array<String>] uris
      def stage(*uris)
        @staged_uris |= uris
      end

      # Whether a URI is staged.
      def staged?(uri)
        @staged_uris.include?(uri)
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

      # Caches current URIs and sets staged URIs to current.
      def cycle
        unless @config.allow_circulation
          cache(*current_uris)
          filter_staged_uris!
        end

        return false if @staged_uris.empty?
        @current_uris = @staged_uris
        @staged_uris = Set.new([])

        true
      end

      # Frees up memory.
      def free
        @current_uris = @staged_uris = @cached_uris = nil
      end

      private

      def filter_staged_uris!
        @staged_uris.delete_if { |uri| @filter.include?(uri) }
      end
    end
  end
end
