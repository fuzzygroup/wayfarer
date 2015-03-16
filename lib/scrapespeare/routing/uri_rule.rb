require "uri"

module Scrapespeare
  module Routing
    class URIRule < Rule

      def initialize(uri_str, opts = {}, &proc)
        @uri = URI(uri_str)
        super(opts, &proc)
      end

      private
      def apply(uri)
        uri == @uri
      end

    end
  end
end
