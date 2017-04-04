# frozen_string_literal: true
require "securerandom"
require "net/http"
require "net/http/persistent"

module Wayfarer
  module HTTPAdapters
    # A singleton adapter for `net-http-persistent`
    # @api private
    class NetHTTPAdapter
      # Supported classes of the Ruby URI standard lib
      RECOGNIZED_URI_TYPES = [
        URI::HTTP,
        URI::HTTPS
      ].freeze

      MalformedURI = Class.new(StandardError)
      MalformedRedirectURI = Class.new(StandardError)
      MaximumRedirectCountReached = Class.new(StandardError)

      attr_accessor :request_header_overrides

      def self.instance(config)
        @@instance ||= new(config)
      end

      def initialize(config)
        @conn = Net::HTTP::Persistent.new("wayfarer-#{SecureRandom.uuid}")
        @conn.override_headers = config.request_header_overrides
      end

      private_class_method :new

      # Fetches a page.
      # @return [Page]
      # @raise [MalformedURI] if the URI is not supported.
      # @raise [MalformedRedirectURI] if a redirection URI is not supported.
      # @raise [MaximumRedirectCountReached] if too many redirections are
      # encountered.
      def fetch(uri, redirects_followed = 0)
        if !RECOGNIZED_URI_TYPES.include?(uri.class)
          raise _ = if redirects_followed.positive?
                      MalformedRedirectURI
                    else
                      MalformedURI
                    end
        elsif redirects_followed > Wayfarer.config.max_http_redirects
          raise MaximumRedirectCountReached
        end

        res = @conn.request(uri)

        if res.is_a?(Net::HTTPRedirection)
          redirect_uri = URI(res["location"])
          return fetch(redirect_uri, redirects_followed + 1)
        end

        Page.new(
          uri: uri,
          status_code: res.code.to_i,
          body: res.body,
          headers: res.to_hash
        )

      rescue SocketError
        raise MalformedURI
      end

      # Shuts down all connections.
      def free
        @conn.shutdown
      end
    end
  end
end
