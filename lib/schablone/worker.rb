require "thread"

module Schablone
  class Worker
    include Celluloid

    trap_exit :indexer_died

    def scrape(uri, task)
      Actor[:navigator].cache(uri)

      HTTPAdapters::AdapterPool.with do |adapter|
        page = adapter.fetch(uri)
        indexer = Indexer.new_link(router, adapter, page, params)
        indexer.async.evaluate(payload)
      end
    end

    private

    def indexer_died(indexer, exception)
      terminate
    end
  end
end
