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

    # Caches URIs so they don't get processed again.
    # @param [*Array<URI>, *Array<String>] uris
    def cache(*uris)
      uris.each { |uri| @filter.insert(uri) }
    end

    # Whether a URI is cached.
    def cached?(uri)
      @filter.include?(uri)
    end

    # Deletes all used Redis keys and disconnects the client.
    def free
      super
      @filter.clear
      @conn.disconnect!
    end
  end
end
