require "thread"

module Schablone
  class Worker
    include Celluloid

    def scrape(uri, task_class)
      Actor[:navigator].cache(uri)
      task_class.new.invoke(uri)
    end
  end
end
