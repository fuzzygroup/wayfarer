module Scrapespeare
  module Callbacks

    # @return [Hash]
    def callbacks
      @callbacks ||= {}
    end

    # Registers a `Proc` as a callback
    #
    # @param context [Symbol]
    # @param proc [Proc]
    def register_callback(context, &proc)
      (callbacks[context] ||= []) << proc
    end

    # Calls all callbacks identified by `context` and passes `*argv`
    #
    # @param context [Symbol]
    # @param argv [Array<Object>]
    def execute_callbacks(context, *argv)
      callbacks[context].each { |callback| callback.call(*argv) }
    end

  end
end
