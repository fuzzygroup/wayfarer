module Scrapespeare
  module Configurable

    # @return [Hash]
    def config
      @config ||= Hashie::Mash.new
    end

    # Sets arbitrary key-value pairs on `config`
    #
    # @param key [Symbol]
    # @param value [Object]
    def set(key, value = true)
      (key.is_a? Hash) ? config.merge!(key) : config[key] = value
    end

  end
end
