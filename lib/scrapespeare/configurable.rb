module Scrapespeare
  module Configurable

    # @return [Hash]
    def options
      @options ||= {}
    end

    # Sets arbitrary keys and options
    #
    # @param key [Symbol]
    # @param value [Object]
    def set(key, value = true)
      @options ||= {}

      if key.is_a? Hash
        @options.merge!(key)
      else
        @options[key] = value
      end
    end

  end
end
