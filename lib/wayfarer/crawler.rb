require "securerandom"

module Wayfarer
  # Entry-point for initiating a new crawl
  class Crawler
    attr_accessor :uuid

    # Stages URIs for the first cycle and runs a {Processor}
    # @param [Job] klass the job to run.
    # @param [*Array<URI>, *Array<String>] *uris the URIs to stage for the first cycle.
    def crawl(klass, *uris)
      config = klass.config
      config.uuid = @uuid = SecureRandom.uuid

      Wayfarer.log.debug("[#{self}] Hello from Wayfarer #{Wayfarer::VERSION}")
      Wayfarer.log.debug(
        "[#{self}] Running job #{klass} #{@uuid}"
      )

      config.each_pair do |key, val|
        Wayfarer.log.debug("[#{self}] #{key}: #{val}")
      end

      Wayfarer.log.debug("[#{self}] Spawning Processor")
      Celluloid::Actor[:processor] = Processor.new(config)

      Wayfarer.log.debug("[#{self}] Staging initial URIs")
      frontier.stage(*uris)

      Wayfarer.log.debug("[#{self}] Running Processor")
      # Create a new sub-class so each job has its own locals
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
    def frontier
      processor.frontier
    end
  end
end
