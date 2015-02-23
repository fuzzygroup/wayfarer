module Scrapespeare
  class Configuration < Hash

    include Hashie::Extensions::MethodAccess

    def initialize
      super
      reset!
    end

    def reset!
      self.replace(defaults)
    end

    private
    def defaults
      {
        capybara_driver: :poltergeist,
        capybara_opts: { phantomjs: Phantomjs.path },
        headers: { "User-Agent" => "Scrapespeare" },

        verbose: false,
        max_http_redirects: 3,
        sanitize_node_content: true
      }
    end

    # override
    def convert_key(key)
      key.to_sym
    end

  end
end
