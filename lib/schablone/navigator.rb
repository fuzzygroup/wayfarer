require "set"

module Schablone
  class Navigator

    def initialize(router)
      @router = router
      @current_uris = []
      @staged_uris = []
      @cached_uris = Set.new([])

      @mutex = Mutex.new
    end

    def current_uris
      @mutex.synchronize { @current_uris }
    end

    def staged_uris
      @mutex.synchronize { @staged_uris }
    end

    def cached_uris
      @mutex.synchronize { @cached_uris.to_a }
    end

    def current_uri_queue
      @current_uris.inject(Queue.new) { |queue, uri| queue << uri }
    end

    def stage(uri)
      @mutex.synchronize { @staged_uris << remove_fragment_identifier(uri) }
    end

    def cache(uri)
      @mutex.synchronize { @cached_uris << uri.to_s }
    end

    private
    def current?(uri)
      @current_uris.include?(uri)
    end

    def cached?(uri)
      @cached_uris.include?(uri.to_s)
    end

    def forbidden?(uri)
      @router.forbids?(uri)
    end

    def filter_staged_uris
      @staged_uris.uniq!
      @staged_uris.delete_if do |uri|
        forbidden?(uri) || current?(uri) || cached?(uri)
      end
    end

    def cycle
      @current_uris, @staged_uris = @staged_uris, []
    end

    def remove_fragment_identifier(uri)
      return uri unless uri.fragment
      URI(uri.to_s.sub(/#.*/, ""))
    end

  end
end
