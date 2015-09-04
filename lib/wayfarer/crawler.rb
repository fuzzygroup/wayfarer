module Wayfarer
  class Crawler
    include Celluloid::Internals::Logger

    def crawl(klass, *uris)
      Wayfarer.log.debug("[#{self}] Hello from Wayfarer #{Wayfarer::VERSION}")

      Wayfarer.log.debug("[#{self}] Spawning Processor")
      Celluloid::Actor[:processor] = Processor.new

      Wayfarer.log.debug("[#{self}] Staging initial URIs")
      Celluloid::Actor[:navigator].stage(*uris)

      Wayfarer.log.debug("[#{self}] Running Processor")
      return_val = Celluloid::Actor[:processor].run(klass)

      Wayfarer.log.debug("[#{self}] Terminating Navigator")
      Celluloid::Actor[:navigator].terminate

      Wayfarer.log.debug("[#{self}] Terminating Processor")
      Celluloid::Actor[:processor].terminate

      Wayfarer.log.debug("[#{self}] All done")

      return_val
    end
  end
end
