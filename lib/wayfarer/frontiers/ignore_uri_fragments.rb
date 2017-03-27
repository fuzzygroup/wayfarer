# frozen_string_literal: true
module Wayfarer
  module Frontiers
    # @api private
    class IgnoreURIFragments
      def initialize(frontier)
        @frontier = frontier
      end

      def stage(*uris)
        uris = uris.map { |uri| truncate_uri_fragment(uri) }
        @frontier.stage(*uris)
      end

      def staged?(uri)
        truncate_uri_fragment!(uri)
        @frontier.staged?(uri)
      end

      def cache(*uris)
        uris = uris.map { |uri| truncate_uri_fragment(uri) }
        @frontier.cache(*uris)
      end

      def cached?(uri)
        truncate_uri_fragment!(uri)
        @frontier.cached?(uri)
      end

      private

      def truncate_uri_fragment(str)
        uri = URI(str)
        uri.fragment = nil
        uri.to_s
      end

      def method_missing(method, *argv, &proc)
        @frontier.public_send(method, *argv, &proc)
      end

      def respond_to_missing?(method, private = false)
        @frontier.respond_to?(method) || super
      end
    end
  end
end
