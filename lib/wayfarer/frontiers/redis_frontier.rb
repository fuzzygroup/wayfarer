require "redis"

module Wayfarer
  module Frontiers
    class RedisFrontier
      include Celluloid

      def initialize
        @conn = Redis.new
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
        unless Wayfarer.config.allow_circulation
          # Cache current URIs
          @conn.sunionstore("cached_uris", "cached_uris", "current_uris")

          # Filter already cached URIs
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

      private

      def filter_staged_uris!
        @staged_uris.delete_if { |uri| @cached_uris.include?(uri) }
      end
    end
  end
end
