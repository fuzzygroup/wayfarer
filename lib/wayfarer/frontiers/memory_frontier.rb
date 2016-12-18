# frozen_string_literal: true
require "set"

module Wayfarer
  module Frontiers
    # A naive in-memory frontier.
    # @api private
    class MemoryFrontier < Frontier
      def initialize(config)
        @config = config
        @current_uris = Set.new([])
        @staged_uris  = Set.new([])
        @cached_uris  = URISet.new
      end

      # Returns the URIs to be scraped in the current cycle.
      # @return [Array<URI>]
      def current_uris
        @current_uris.map { |uri| URI(uri) }
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
        @staged_uris.include?(uri.to_s)
      end

      # Returns the staged URIs.
      # @return [Array<URI>]
      def staged_uris
        @staged_uris.to_a
      end

      # Caches URIs so they don't get processed again.
      # @param [*Array<URI>, *Array<String>] uris
      def cache(*uris)
        @cached_uris |= uris.map { |uri| uri.to_s }
      end

      # Whether a URI is cached.
      def cached?(uri)
        @cached_uris.include?(uri.to_s)
      end

      # Frees up memory.
      def free
        @current_uris = @staged_uris = @cached_uris = nil
      end

      private

      def reset_staged_uris!
        @staged_uris = Set.new([])
      end

      def swap!
        @current_uris = @staged_uris
      end

      def filter_staged_uris!
        @staged_uris.delete_if { |uri| cached?(uri) }
      end
    end
  end
end
