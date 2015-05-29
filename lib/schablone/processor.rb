require "thread"

module Schablone
  class Processor
    include Celluloid
    include Celluloid::Notifications

    trap_exit :worker_died
    finalizer :terminate_pool

    def initialize
      subscribe("halt", :halt)
      Navigator.supervise_as(:navigator)
    end

    def run(task)
      Actor[:worker_pool] = Worker.pool

      while Actor[:navigator].cycle
        Actor[:navigator].current_uris.each do |uri|
          Actor[:worker_pool].scrape(uri, task)
        end
      end

      halt
    end

    def halt
      puts "nothing left to do."
      # HTTPAdapters::AdapterPool.shutdown { |adapter| adapter.free }
    end

    private

    def worker_died(worker, reason)
      fail "#{worker.inspect} died because of #{reason.class}"
    end
  end
end
