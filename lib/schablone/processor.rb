require "thread"

module Schablone
  class Processor
    include Celluloid
    include Celluloid::Logger

    def initialize
      Actor[:navigator]   = Navigator.new_link
      Actor[:worker_pool] = Worker.pool(size: 16)
    end

    def run(task_class)
      step(task_class) while Actor[:navigator].cycle
      halt
    end

    def halt
      info("Processor halts")
      #terminate
    end

    private

    def step(task_class)
      uris = Actor[:navigator].current_uris.map do |uri|
        Actor[:worker_pool].future.scrape(uri, task_class)
      end

      uris.each do |uri|
        Actor[:navigator].stage(uri.value)
      end
    end
  end
end
