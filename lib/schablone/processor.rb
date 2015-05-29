require "thread"
require "celluloid"
require "connection_pool"

module Schablone
  class Processor
    include Celluloid
    include Celluloid::Notifications

    def initialize
      subscribe("halt", :halt)
      Navigator.supervise_as(:navigator)
      @worker_pool = Worker.pool
    end

    def run(task)
      Actor[:navigator].current_uris.each do |uri|
        @worker_pool.scrape(uri, task)
      end

      halt unless Actor[:navigator].cycle
    end

    def halt
      # HTTPAdapters::AdapterPool.shutdown { |adapter| adapter.free }
      terminate
    end
  end
end
