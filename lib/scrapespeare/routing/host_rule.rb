module Scrapespeare
  module Routing
    class HostRule < Rule

      def initialize(str_or_regexp, opts = {}, &proc)
        @str_or_regexp = str_or_regexp
        super(opts, &proc)
      end

      def match(uri)
        @str_or_regexp === uri.host
      end

    end
  end
end
