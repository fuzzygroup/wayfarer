# frozen_string_literal: true
require "redis"

module Wayfarer
  module Frontiers
    # A Redis frontier
    # @api private
    class RedisFrontier < Frontier
      def initialize(config)
        @conn = Redis.new(@config.redis_opts)
        super(config)
      end

      # Returns the URIs to be scraped in the current cycle.
      # @return [Array<URI>]
      def current_uris
        @conn.smembers(current_uris_key).map { |str| URI(str) }
      end

      # Returns the staged URIs.
      # @return [Array<URI>]
      def staged_uris
        @conn.smembers(staged_uris_key).map { |str| URI(str) }
      end

      # Stages URIs for processing in the next cycle.
      # @param [*Array<URI>, *Array<String>] uris
      def stage(*uris)
        @conn.sadd(staged_uris_key, uris.map(&:to_s)) if uris.any?
      end

      # Whether a URI is cached.
      def staged?(uri)
        @conn.sismember(staged_uris_key, uri.to_s)
      end

      # Caches URIs so they don't get processed again.
      # @param [*Array<URI>, *Array<String>] uris
      def cache(*uris)
        @conn.sadd(cached_uris_key, uris.map(&:to_s)) if uris.any?
      end

      # Whether a URI is cached.
      def cached?(uri)
        @conn.sismember(cached_uris_key, uri.to_s)
      end

      # Deletes all used Redis keys and disconnects the client.
      def free
        @conn.del(current_uris_key)
        @conn.del(staged_uris_key)
        @conn.del(cached_uris_key)

        @conn.disconnect!
      end

      private

      def reset_staged_uris!
        @conn.del(cached_uris_key)
      end

      def swap!
        @conn.rename(current_uris_key, swap_key)
        @conn.rename(cached_uris_key, current_uris_key)
        @conn.rename(swap_key, cached_uris_key)
      end

      def filter_staged_uris!
        @conn.sdiffstore(staged_uris_key, cached_uris_key, staged_uris_key)
      end

      def current_uris_key
        "#{@config.uuid}_current_uris"
      end

      def staged_uris_key
        "#{@config.uuid}_staged_uris"
      end

      def cached_uris_key
        "#{@config.uuid}_cached_uris"
      end

      def swap_key
        "#{@config.uuid}_swap"
      end
    end
  end
end
