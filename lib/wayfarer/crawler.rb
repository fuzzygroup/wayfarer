module Wayfarer
  class Crawler
    include Celluloid::Logger

    def crawl(klass, *uris)
      debug("[#{self}] Hello from Wayfarer #{Wayfarer::VERSION}")
      debug("[#{self}] Spawning Processor")
      Celluloid::Actor[:processor] = Processor.new

      debug("[#{self}] Staging initial URIs")
      Celluloid::Actor[:navigator].stage(*uris)

      debug("[#{self}] Running Processor")
      return_val = Celluloid::Actor[:processor].run(klass)

      debug("[#{self}] Terminating Navigator")
      Celluloid::Actor[:navigator].terminate

      debug("[#{self}] Terminating Processor")
      Celluloid::Actor[:processor].terminate

      debug("[#{self}] All done")

      return_val
    end
  end
end
