require "redis"

module Wayfarer
  module Frontiers
    # A Redis frontier
    class RedisFrontier
      def initialize(config)
        @config = config
        @conn = Redis.new(*@config.redis_argv)
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

      # Returns all cached URIs.
      # @return [Array<URI>]
      def cached_uris
        @conn.smembers(cached_uris_key).map { |str| URI(str) }
      end

      # Stages URIs for processing in the next cycle.
      # @param [*Array<URI>, *Array<String>] *uris
      def stage(*uris)
        @conn.sadd(staged_uris_key, uris.map(&:to_s))
      end

      # Caches URIs so they don't get processed again.
      # @param [*Array<URI>, *Array<String>] *uris
      def cache(*uris)
        @conn.sadd(cached_uris_key, uris.map(&:to_s))
      end

      # TODO Documentation
      # Caches current URIs and sets staged URIs as current.
      def cycle
        unless @config.allow_circulation
          @conn.sunionstore(current_uris_key, cached_uris_key, current_uris_key)
          @conn.sdiffstore(staged_uris_key, staged_uris_key, cached_uris_key)
        end

        return false if @conn.scard(staged_uris_key).zero?
        @conn.rename(staged_uris_key, current_uris_key)
        true
      end

      # Deletes all used Redis keys and disconnects the client.
      def free
        @conn.del(current_uris_key)
        @conn.del(staged_uris_key)
        @conn.del(cached_uris_key)

        @conn.disconnect!
      end

      private

      def current_uris_key
        "#{@config.uuid}_current_uris"
      end

      def staged_uris_key
        "#{@config.uuid}_staged_uris"
      end

      def cached_uris_key
        "#{@config.uuid}_cached_uris"
      end
    end
  end
end
