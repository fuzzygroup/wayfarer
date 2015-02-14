module Scrapespeare
  class Configuration < Hash

    include Hashie::Extensions::MethodAccess

    def initialize
      super
      reset!
    end

    def reset!
      merge!(defaults)
    end

    private
    def defaults
      {
        http_adapter: :net_http,
        verbose: false,
        max_http_redirects: 3
      }
    end

    # override
    def convert_key(key)
      key.to_sym
    end

  end
end
