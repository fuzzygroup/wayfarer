# frozen_string_literal: true
require "set"

module Wayfarer
  module Frontiers
    # A naive in-memory frontier
    # TODO Store strings instead of URI objects
    # @private
    class MemoryFrontier
      def initialize(config)
        @config = config
        @current_uris = Set.new([])
        @staged_uris  = Set.new([])
        @cached_uris  = URISet.new
      end

      # Returns the URIs to be scraped in the current cycle.
      # @return [Array<URI>]
      def current_uris
        @current_uris.to_a
      end

      # Returns the staged URIs.
      # @return [Array<URI>]
      def staged_uris
        @staged_uris.to_a
      end

      # Returns all cached URIs.
      # @return [Array<URI>]
      def cached_uris
        @cached_uris.to_a
      end

      # Stages URIs for processing in the next cycle.
      # @param [*Array<URI>, *Array<String>] *uris
      def stage(*uris)
        @staged_uris |= uris.map { |uri| URI(uri) }
      end

      # Caches URIs so they don't get processed again.
      # @param [*Array<URI>, *Array<String>] *uris
      def cache(*uris)
        @cached_uris |= uris.map { |uri| URI(uri) }
      end

      # Caches current URIs and sets staged URIs as current.
      # TODO: Documentation
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
        @staged_uris.delete_if { |uri| @cached_uris.include?(uri) }
      end
    end
  end
end
