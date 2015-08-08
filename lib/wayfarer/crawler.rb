module Wayfarer
  class Crawler
    include Celluloid::Logger

    def crawl(klass, *uris)
      info("[#{self}] Scrapespeare #{Wayfarer::VERSION}")
      info("[#{self}] Spawning Processor")
      Celluloid::Actor[:processor] = Processor.new

      info("[#{self}] Staging URIs")
      Celluloid::Actor[:navigator].stage(*uris)

      info("[#{self}] Running Processor")
      return_val = Celluloid::Actor[:processor].run(klass)

      info("[#{self}] Terminating Navigator")
      Celluloid::Actor[:navigator].terminate

      info("[#{self}] Terminating Processor")
      Celluloid::Actor[:processor].terminate

      info("[#{self}] Done")
      return_val
    end
  end
end
