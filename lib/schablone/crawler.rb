module Schablone
  class Crawler
    include Celluloid
    include Celluloid::Logger

    trap_exit :processor_halted
    finalizer :shutdown_adapter_pool

    def crawl(task, *uris)
      Celluloid::Actor[:processor] = Processor.new_link
      Celluloid::Actor[:navigator].stage(*uris)
    end

    def processor_halted(worker, reason)
      info("wat")
      # terminate
    end

    private

    def shutdown_adapter_pool
      HTTPAdapters::AdapterPool.shutdown { |adapter| adapter.free }
    end
  end
end
