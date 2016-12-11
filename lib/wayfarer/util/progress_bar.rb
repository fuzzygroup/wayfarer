# frozen_string_literal: true

require "logger"
require "ruby-progressbar"

module Wayfarer
  module Utils
    # @private
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

      # rubocop:disable Metrics/CyclomaticComplexity
      def add(severity, message = nil, progname = nil, &proc)
        msg = if message
                message
              elsif proc
                yield
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

      alias log add

      LEVELS = {
        Logger::UNKNOWN => :unknown,
        Logger::DEBUG   => :debug,
        Logger::ERROR   => :error,
        Logger::FATAL   => :fatal,
        Logger::INFO    => :info,
        Logger::WARN    => :warn
      }.freeze

      LEVELS.each do |level, sym|
        define_method(sym) do |message|
          if @level <= level
            @bar ? @bar.log("[sym.to_s.upcase] #{message}") : puts(message)
          end
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
        @bar&.finish

        opts = options.merge(total: uri_count)

        @bar = ::ProgressBar.create(opts)
      end

      def handle_processed_uri
        @bar.increment
      end
    end
  end
end
