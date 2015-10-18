module Wayfarer
  class Crawler
    include Celluloid::Internals::Logger

    def initialize
      Wayfarer.log.debug("[#{self}] Hello from Wayfarer #{Wayfarer::VERSION}")

      Wayfarer.log.debug("[#{self}] Spawning Processor")
      Celluloid::Actor[:processor] = Processor.new
    end

    def crawl(klass, *uris)
      Wayfarer.log.debug("[#{self}] Staging initial URIs")
      navigator.stage(*uris)

      Wayfarer.log.debug("[#{self}] Running Processor")
      processor.run(klass)

      Wayfarer.log.debug("[#{self}] Terminating Processor")
      processor.terminate

      Wayfarer.log.debug("[#{self}] Done")
    end

    def processor
      Celluloid::Actor[:processor]
    end

    def navigator
      processor.navigator
    end
  end
end
