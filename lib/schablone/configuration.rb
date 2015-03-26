require "hashie/extensions/method_access"

module Schablone
  class Configuration < Hash
    include Hashie::Extensions::MethodAccess

    def initialize
      super
      reset!
    end

    def reset!
      replace(defaults)
    end

    private

    def defaults
      {
        http_adapter:          :net_http,
        verbose:               false,
        max_http_redirects:    3,
        sanitize_node_content: true,
        log_level:             Logger::FATAL,
        threads:               4
      }
    end

    # override
    def convert_key(key)
      key.to_sym
    end
  end
end
