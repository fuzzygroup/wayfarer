module Scrapespeare
  module URIConstructor

    module_function

    def absolute_uri(base_uri, path)
      URI.join(base_uri, path).to_s
    end

  end
end
