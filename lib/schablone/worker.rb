require "thread"

module Schablone
  class Worker
    include Celluloid

    def scrape(uri, task)
      Actor[:navigator].cache(uri)
      task.invoke(uri)
    end
  end
end
