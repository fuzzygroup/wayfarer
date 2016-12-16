# frozen_string_literal: true
require "bloomfilter-rb"

module Wayfarer
  module Frontiers
    # The common interface of all frontiers.
    # @api private
    class Frontier
      attr_reader :config

      def initialize(config); end

      # TODO Documentation!
      def cycle
        unless config.allow_circulation
          cache(*current_uris)
          filter_staged_uris!
        end

        return false if staged_uris.empty?

        swap!
        reset_staged_uris!

        true
      end
    end
  end
end