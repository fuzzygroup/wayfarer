require "thread"

module Schablone
  class Worker
    include Celluloid

    def scrape(uri, task_class)
      Actor[:navigator].async.cache(uri)

      HTTPAdapters::AdapterPool.with do |adapter|
        task_class.new.invoke(uri, adapter)
      end
    end
  end
end
