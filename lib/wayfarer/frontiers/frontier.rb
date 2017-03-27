# frozen_string_literal: true
module Wayfarer
  module Frontiers
    # @abstract The common behaviour of all frontiers.
    class Frontier
      attr_reader :config

      def initialize(config)
        @config = config
      end

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
