module Wayfarer
  # Entry-point for initiating a new crawl
  class Crawler
    def initialize
      Wayfarer.log.debug("[#{self}] Hello from Wayfarer #{Wayfarer::VERSION}")

      Wayfarer.log.debug("[#{self}] Spawning Processor")
      Celluloid::Actor[:processor] = Processor.new
    end

    # Stages URIs for the first cycle and runs a {Processor}
    # @param [Job] klass the job to run.
    # @param [*Array<URI>, *Array<String>] *uris the URIs to stage for the first cycle.
    def crawl(klass, *uris)
      Wayfarer.log.debug("[#{self}] Staging initial URIs")
      navigator.stage(*uris)

      Wayfarer.log.debug("[#{self}] Running Processor")
      processor.run(klass)

      Wayfarer.log.debug("[#{self}] Terminating Processor")
      processor.terminate

      Wayfarer.log.debug("[#{self}] Done")
    end

    # Returns the spawned {Processor}
    # @return [Processor]
    def processor
      Celluloid::Actor[:processor]
    end

    # Returns the spawned {Processor}’s {Navigator}
    # @return [Navigator]
    def navigator
      processor.navigator
    end
  end
end
