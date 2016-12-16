# frozen_string_literal: true
require "bloomfilter-rb"

module Wayfarer
  module Frontiers
    # A Redis bloomfilter.
    # @api private
    class RedisBloomfilter < MemoryBloomfilter
      def initialize(config)
        super(config)
        @conn = Redis.new(@config.redis_opts)
        @filter = BloomFilter::Redis.new(config.bloomfilter_opts.merge({
          db: @conn
        }))
      end
    end

    # Deletes all used Redis keys and disconnects the client.
    def free
      @filter.clear
      @conn.disconnect!
    end
  end
end
