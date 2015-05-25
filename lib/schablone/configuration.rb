require "ostruct"

module Schablone
  class Configuration < OpenStruct
    DEFAULTS = {
      http_adapter:          :net_http,
      verbose:               false,
      max_http_redirects:    3,
      sanitize_node_content: true,
      log_level:             Logger::FATAL,
      threads:               4,
      selenium_argv:         [:firefox]
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
