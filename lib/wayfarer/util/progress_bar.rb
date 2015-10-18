require "logger"
require "ruby-progressbar"

module Wayfarer
  module Util
    class ProgressBar
      attr_accessor :level

      def initialize
        @level = Wayfarer.logger.level
        Wayfarer.logger = self
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

      LEVELS = {
        Logger::UNKNOWN => "unknown",
        Logger::DEBUG   => "debug",
        Logger::ERROR   => "error",
        Logger::FATAL   => "fatal",
        Logger::INFO    => "info",
        Logger::WARN    => "warn"
      }

      def unknown(str)
        if @level <= Logger::UNKNOWN
          @bar ? @bar.log("[UNKNOWN] #{str}") : puts(str)
        end
      end

      def debug(str)
        if @level <= Logger::DEBUG
          @bar ? @bar.log("[DEBUG] #{str}") : puts(str)
        end
      end

      def error(str)
        if @level <= Logger::ERROR
          @bar ? @bar.log("[ERROR] #{str}") : puts(str)
        end
      end

      def fatal(str)
        if @level <= Logger::FATAL
          @bar ? @bar.log("[FATAL] #{str}") : puts(str)
        end
      end

      def info(str)
        if @level <= Logger::INFO
          @bar ? @bar.log("[INFO] #{str}") : puts(str)
        end
      end

      def warn(str)
        if @level <= Logger::WARN
          @bar ? @bar.log("[WARN] #{str}") : puts(str)
        end
      end

      private

      def options
        {
          title: "Cycle progress",
          format: "%t: (%c/%C URIs) <%B>"
        }
      end

      def handle_new_cycle(uri_count)
        @bar.finish if @bar

        opts = options.merge(total: uri_count)

        @bar = ::ProgressBar.create(opts)
      end

      def handle_processed_uri
        @bar.increment
      end
    end
  end
end
