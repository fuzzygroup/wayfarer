module Schablone
  class Crawler

    def crawl(klass, *uris)
      Celluloid::Actor[:processor] = Processor.new

      Celluloid::Actor[:navigator].stage(*uris)
      Celluloid::Actor[:processor].async.run(klass)

      Celluloid::Actor[:navigator].join
      Celluloid::Actor[:processor].join
    end

    private

    def shutdown_adapter_pool
      HTTPAdapters::AdapterPool.shutdown { |adapter| adapter.free }
    end
  end
end
