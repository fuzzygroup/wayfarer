# frozen_string_literal: true
require "bloomfilter-rb"

module Wayfarer
  module Frontiers
    # The common interface of all frontiers.
    # @api private
    class Frontier
      attr_reader :config

      def initialize(config); end

      # Returns the URIs to be scraped in the current cycle.
      # @return [Array<URI>]
      def current_uris
      end

      # Returns staged URIs.
      # @return [Array<URI>]
      def staged_uris
      end

      # Stages URIs for processing in the next cycle.
      # @param [*Array<URI>, *Array<String>] uris
      def stage(*uris)
      end

      # Whether a URI is staged.
      def staged?(uri)
      end

      # Caches URIs so they don't get processed again.
      # @param [*Array<URI>, *Array<String>] uris
      def cache(*uris)
      end

      # Whether a URI is cached.
      def cached?(uri)
      end

      # TODO Documentation!
      def cycle
        unless config.allow_circulation
          cache(*current_uris)
          filter_staged_uris!
        end

        return false if staged_uris.empty?
        current_uris = staged_uris
        reset_staged_uris!

        true
      end

      # Frees up memory.
      def free
      end
    end
  end
end
