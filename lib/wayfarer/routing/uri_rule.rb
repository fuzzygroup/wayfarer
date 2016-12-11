# frozen_string_literal: true
require "uri"

module Wayfarer
  module Routing
    # @private
    class URIRule < Rule
      def initialize(uri_str, opts = {}, &proc)
        @uri = URI(uri_str)
        super(opts, &proc)
      end

      def match!(uri)
        uri == @uri
      end
    end
  end
end
