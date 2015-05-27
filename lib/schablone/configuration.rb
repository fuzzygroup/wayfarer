module Schablone
  class Configuration
    DEFAULTS = {
      thread_count:          6,
      http_adapter:          :net_http,
      connection_count:      6,
      http_adapter_timeout:  5.0,
      max_http_redirects:    3,
      selenium_argv:         [:firefox],
      sanitize_node_content: true,
      log_level:             Logger::FATAL,
      mustermann_type:       :template,
      connection_count:      6,
      thread_timeout:        8
    }

    def initialize
      @config = {}
      reset!
    end

    def reset!
      @config.replace(DEFAULTS)
    end

    private

    def method_missing(method, *args)
      if method.to_s =~ /^\w+=$/
        @config[method.to_s.chomp("=").to_sym] = args.first
      else
        @config[method]
      end
    end

    def respond_to_missing?(method, private = false)
      @config.key?(method) || super
    end
  end
end
