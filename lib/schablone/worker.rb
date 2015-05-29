require "thread"

module Schablone
  class Worker
    include Celluloid

    def scrape(uri, task)
      Actor[:navigator].async.cache(uri)
      task.invoke(uri)
    end
  end
end
