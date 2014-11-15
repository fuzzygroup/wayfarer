module Scrapespeare
  module Callbacks

    def callbacks
      @callbacks ||= {}
    end

    def register_callback(context, &proc)
      (callbacks[context] ||= []) << proc
    end

    def execute_callbacks(context, *argv)
      callbacks[context].each { |callback| callback.call(*argv) }
    end

  end
end
