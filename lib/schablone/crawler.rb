module Schablone
  class Crawler
    include Celluloid::Logger

    def crawl(klass, *uris)
      info("Running Scrapespeare #{Schablone::VERSION}")
      info("Crawler spawning Processor...")
      Celluloid::Actor[:processor] = Processor.new

      Celluloid::Actor[:navigator].stage(*uris)
      Celluloid::Actor[:processor].run(klass)

      Celluloid::Actor[:navigator].terminate
      Celluloid::Actor[:processor].terminate
    end
  end
end
