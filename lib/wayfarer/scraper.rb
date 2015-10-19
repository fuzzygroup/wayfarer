require "thread"

module Wayfarer
  # Fetches a page from a URI and instantiates a job
  class Scraper
    include Celluloid

    task_class Task::Threaded

    def initialize
      Wayfarer.log.debug("[#{self}] Scraper spawned")
    end

    # Fetches a page from a URI and instantiates a job
    # @param [URI] uri the URI to fetch.
    # @param [Job] klass the job to run.
    # @param [AdapterPool] adapter_pool the adapter pool the check out an adapter from.
    def scrape(uri, klass, adapter_pool)
      adapter_pool.with do |adapter|
        Wayfarer.log.debug("[#{self}] About to scrape: #{uri}")
        indexer = klass.new
        indexer.invoke(uri, adapter)
      end
    end
  end
end
