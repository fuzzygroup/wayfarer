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
        http_adapter: :faraday,
        verbose: false,
        max_http_redirects: 3,
        selenium_argv: [:firefox]
      }
    end

    # override
    def convert_key(key)
      key.to_sym
    end

  end
end
