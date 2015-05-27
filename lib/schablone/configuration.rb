require "ostruct"

module Schablone
  class Configuration < OpenStruct
    DEFAULTS = {
      thread_count:          6,
      http_adapter:          :net_http,
      connection_count:      6,
      http_adapter_timeout:  5.0,
      max_http_redirects:    3,
      selenium_argv:         [:firefox],
      sanitize_node_content: true,
      log_level:             Logger::FATAL,
      mustermann_type:       :template
    }

    def initialize
      super
      reset!
    end

    def reset!
      each_pair { |key, _| delete_field(key) }
      DEFAULTS.each { |key, val| self[key] = val }
    end
  end
end
