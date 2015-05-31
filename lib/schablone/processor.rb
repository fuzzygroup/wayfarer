require "thread"

module Schablone
  class Processor
    include Celluloid
    include Celluloid::Logger

    def initialize
      Actor[:navigator]   = Navigator.new_link
      Actor[:worker_pool] = Worker.pool
    end

    def run(task)
      step(task) while Actor[:navigator].cycle
      halt
    end

    def halt
      info("Processor halts")
      terminate
    end

    private

    def step(task)
      Actor[:navigator].current_uris.each do |uri|
        Actor[:worker_pool].scrape(uri, task)
      end
    end
  end
end
