module Scrapespeare
  module Configurable

    # @return [Hash]
    def config
      @config ||= Hashie::Mash.new
    end

    # Sets arbitrary key-value pairs on `@config`
    #
    # @param key [Symbol]
    # @param value [Object]
    def set(key, value = true)
      if key.is_a? Hash
        config.merge!(key)
      else
        config[key] = value
      end
    end

  end
end
