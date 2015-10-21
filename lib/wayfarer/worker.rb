module Wayfarer
  # Fetches a page from a URI and instantiates a job
  class Worker
    include Celluloid

    task_class Task::Threaded

    # Fetches a page from a URI and instantiates a job
    # @param [URI] uri the URI to fetch.
    # @param [Job] klass the job to run.
    # @param [AdapterPool] adapter_pool the adapter pool the check out an adapter from.
    def work(uri, klass, adapter_pool)
      adapter_pool.with { |adapter| klass.new.invoke(uri, adapter) }
    end
  end
end
