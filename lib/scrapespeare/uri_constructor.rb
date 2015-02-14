module Scrapespeare
  module URIConstructor

    extend self

    def construct(base_uri, path)
      URI.join(base_uri, path)
    end

  end
end
