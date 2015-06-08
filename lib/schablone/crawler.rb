module Schablone
  class Crawler

    def crawl(task_class, *uris)
      Celluloid::Actor[:processor] = Processor.new

      Celluloid::Actor[:navigator].stage(*uris)
      Celluloid::Actor[:processor].run(task_class)

      Celluloid::Actor[:processor].terminate
      Celluloid::Actor[:navigator].terminate

      Celluloid.shutdown
    end

    private

    def shutdown_adapter_pool
      HTTPAdapters::AdapterPool.shutdown { |adapter| adapter.free }
    end
  end
end
