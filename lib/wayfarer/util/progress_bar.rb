require "ruby-progressbar"

module Wayfarer
  module Util
    class ProgressBar
      def initialize
        @bar = ::ProgressBar.create
      end

      def update(type, *argv)
        case type
        when :new_cycle      then handle_new_cycle(*argv)
        when :processed_uris then handle_processed_uris(*argv)
        end
      end

      def log(*argv)
        #@bar.log(*argv)
      end

      alias_method :debug, :log
      alias_method :error, :log
      alias_method :fatal, :log
      alias_method :info,  :log
      alias_method :warn,  :log

      def debug(str)
        
      end

      private

      def options
        {
          title: "Cycle progress",
          format: "%t: (%c/%C URIs) |%B|"
        }
      end

      def handle_new_cycle(current_uris)
        @bar.finish

        opts = options.merge(total: current_uris.count)

        @bar = ::ProgressBar.create(opts)
      end

      def handle_processed_uris(uris)
        @bar.log("PROCESSED #{uris} URIS")
        @bar.progress += uris
      end
    end
  end
end
