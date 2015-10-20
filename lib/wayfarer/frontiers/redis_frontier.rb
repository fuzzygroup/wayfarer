require "redis"

module Wayfarer
  module Frontiers
    class RedisFrontier
      include Celluloid

      def initialize(config)
        @config = config
        @conn = Redis.new(*@config.redis_argv)
      end

      def current_uris
        @conn.smembers(current_uris_key).map { |str| URI(str) }
      end

      def staged_uris
        @conn.smembers(staged_uris_key).map { |str| URI(str) }
      end

      def cached_uris
        @conn.smembers(cached_uris_key).map { |str| URI(str) }
      end

      def stage(*uris)
        @conn.sadd(staged_uris_key, uris.map(&:to_s))
      end

      def cache(*uris)
        @conn.sadd(cached_uris_key, uris.map(&:to_s))
      end

      def cycle
        unless @config.allow_circulation
          @conn.sunionstore(current_uris_key, cached_uris_key, current_uris_key)
          @conn.sdiffstore(staged_uris_key, staged_uris_key, cached_uris_key)
        end

        return false if @conn.scard(staged_uris_key).zero?
        @conn.rename(staged_uris_key, current_uris_key)
        true
      end

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
