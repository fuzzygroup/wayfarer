# frozen_string_literal: true
module Wayfarer
  module Routing
    # @private
    class HostRule < Rule
      def initialize(str_or_regexp, opts = {}, &proc)
        @str_or_regexp = str_or_regexp
        super(opts, &proc)
      end

      # rubocop:disable Style/CaseEquality
      def match!(uri)
        @str_or_regexp === uri.host
      end
      # rubocop:enable Style/CaseEquality
    end
  end
end
