require "set"

module Schablone
  class Navigator
    def initialize
      @current_uris = Set.new([])
      @staged_uris = Set.new([])
      @cached_uris = URISet.new
      @mutex = Mutex.new
    end

    def current_uris
      @mutex.synchronize { @current_uris.to_a }
    end

    def staged_uris
      @mutex.synchronize { @staged_uris.to_a }
    end

    def cached_uris
      @mutex.synchronize { @cached_uris.to_a }
    end

    def current_uri_queue
      current_uris.reduce(Queue.new) { |queue, uri| queue << uri }
    end

    def stage(*uris)
      @mutex.synchronize { @staged_uris |= uris.flatten.map { |uri| URI(uri) } }
    end

    def cache(*uris)
      @mutex.synchronize { @cached_uris |= uris.flatten.map { |uri| URI(uri) } }
    end

    def cycle
      filter_staged_uris

      if @staged_uris.empty?
        false
      else
        @current_uris, @staged_uris = @staged_uris, Set.new([])
        true
      end
    end

    private

    def current?(uri)
      @current_uris.include?(uri)
    end

    def cached?(uri)
      @cached_uris.include?(uri)
    end

    def filter_staged_uris
      @staged_uris.delete_if { |uri| current?(uri) || cached?(uri) }
    end
  end
end
