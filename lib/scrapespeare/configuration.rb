module Scrapespeare
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
        http_adapter: :rest_client,
        verbose: false,
        max_http_redirects: 3,
        selenium_argv: [:firefox],
        sanitize_node_content: true
      }
    end

    # override
    def convert_key(key)
      key.to_sym
    end

  end
end
