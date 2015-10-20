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
        @conn.smembers("current_uris").map { |str| URI(str) }
      end

      def staged_uris
        @conn.smembers("staged_uris").map { |str| URI(str) }
      end

      def cached_uris
        @conn.smembers("cached_uris").map { |str| URI(str) }
      end

      def stage(*uris)
        @conn.sadd("staged_uris", uris.map(&:to_s))
      end

      def cache(*uris)
        @conn.sadd("cached_uris", uris.map(&:to_s))
      end

      def cycle
        unless @config.allow_circulation
          @conn.sunionstore("cached_uris", "cached_uris", "current_uris")
          @conn.sdiffstore("staged_uris", "staged_uris", "cached_uris")
        end

        return false if @conn.scard("staged_uris").zero?
        @conn.rename("staged_uris", "current_uris")
        true
      end

      def free
        @conn.del("current_uris")
        @conn.del("staged_uris")
        @conn.del("cached_uris")

        @conn.disconnect!
      end
    end
  end
end
