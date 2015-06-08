require "thread"

module Schablone
  class Processor
    include Celluloid
    include Celluloid::Logger

    def initialize
      Actor[:navigator]   = Navigator.new_link
      Actor[:worker_pool] = Worker.pool
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
      Actor[:navigator].current_uris.each do |uri|
        uris = Actor[:worker_pool].future.scrape(uri, task_class)
        puts "----"
        puts uris.value.inspect
        puts "----"
        Actor[:navigator].stage(uris.value)
      end
    end
  end
end
