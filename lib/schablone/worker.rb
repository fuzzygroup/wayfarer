require "thread"

module Schablone
  class Worker
    include Celluloid

    trap_exit :indexer_died

    def scrape(uri, router)
      Actor[:navigator].cache(uri)

      payload, params = router.route(uri)
      terminate unless payload && params

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
