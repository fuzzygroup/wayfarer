require "logger"
require "ruby-progressbar"

module Wayfarer
  module Util
    class ProgressBar
      attr_accessor :level

      def initialize
        @level = Wayfarer.logger.level
        Wayfarer.logger = self

        @bar = ::ProgressBar.create
      end

      def update(type, *argv)
        case type
        when :new_cycle      then handle_new_cycle(*argv)
        when :processed_uri  then handle_processed_uri(*argv)
        end
      end

      def add(severity, message = nil, progname = nil, &proc)
        msg = if message
                message
              elsif proc
                proc.call
              else
                progname
              end

        case severity
        when Logger::UNKNOWN then unknown(msg)
        when Logger::DEBUG   then debug(msg)
        when Logger::ERROR   then error(msg)
        when Logger::FATAL   then fatal(msg)
        when Logger::INFO    then info(msg)
        when Logger::WARN    then warn(msg)
        end
      end

      alias_method :log, :add

      def unknown(str)
        @bar.log("[UNKNOWN] #{str}") if @level <= Logger::UNKNOWN
      end

      def debug(str)
        @bar.log("[DEBUG] #{str}") if @level <= Logger::DEBUG
      end

      def error(str)
        @bar.log("[ERROR] #{str}") if @level <= Logger::ERROR
      end

      def fatal(str)
        @bar.log("[FATAL] #{str}") if @level <= Logger::FATAL
      end

      def info(str)
        @bar.log("[INFO] #{str}") if @level <= Logger::INFO
      end

      def warn(str)
        @bar.log("[WARN] #{str}") if @level <= Logger::WARN
      end

      def debug(str)
        @bar.log("[DEBUG] #{str}") if @level <= Logger::DEBUG
      end

      private

      def options
        {
          title: "Cycle progress",
          format: "%t: (%c/%C URIs) |%B|"
        }
      end

      def handle_new_cycle(uri_count)
        @bar.finish

        opts = options.merge(total: uri_count)

        @bar = ::ProgressBar.create(opts)
      end

      def handle_processed_uri
        @bar.increment
      end
    end
  end
end
