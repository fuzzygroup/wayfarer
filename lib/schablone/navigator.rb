require "set"

module Schablone
  # @private
  #
  # A {Navigator} is responsible for managing:
  # * A set of __current__ URIs that are being processed
  # * A set of __staged__ URIs that shall be processed under certain conditions
  # * A set of __cached__ URIs that have been processed
  #
  # After initialization, all three sets are empty. Hence, {#current_uris},
  # {#staged_uris} and {#cached_uris} return an empty `Array`:
  # ```
  # navigator.current_uris # => []
  # navigator.staged_uris  # => []
  # navigator.cached_uris  # => []
  # ```
  # URIs get staged by calling {#stage}:
  # ```
  # navigator.stage(URI("http://example.com"))
  # navigator.staged_uris.count # => 1
  # ```
  # After staging URIs, calling {#cycle} will set all staged URIs as
  # current that suffice the following conditions:
  # 1. The URI is not included in the set of current URIs
  # 2. The URI is not included in the set of cached URIs
  # 3. The URI is not forbidden by {#router}
  #
  # Assume some URIs have been processed and staged and all staged URIs
  # suffice the above criteria:
  # ```
  # navigator.current_uris.count # => 5
  # navigator.staged_uris.count  # => 3
  # navigator.cached_uris.count  # => 0
  #
  # navigator.cycle
  #
  # navigator.current_uris.count # => 3
  # navigator.staged_uris.count  # => 0
  # navigator.cached_uris.count  # => 5
  # ```
  # Because {#cached_uris} is backed by a {URISet}, both fragment identifiers
  # and trailing slashes are disregarded:
  # ```
  # navigator.stage(URI("http://example.com"))
  # navigator.stage(URI("http://example.com/"))
  # navigator.stage(URI("http://example.com#fragment-identifier"))
  #
  # navigator.staged_uris.count # => 1
  # ```
  # @param router [Schablone::Router]
  class Navigator
    # @!attribute [r] router
    # @return [Routing::Router]
    attr_reader :router

    # Initializes a new {Navigator}
    #
    # @param router [Routing::Router]
    # @return [Navigator] the initialized {Navigator}
    def initialize(router)
      @router = router

      @current_uris = Set.new([])
      @staged_uris = Set.new([])
      @cached_uris = URISet.new

      @mutex = Mutex.new
    end

    # Returns an `Array` containing all URIs that are being processed
    #
    # @return [Array<URI>] URIs that are being processed
    def current_uris
      @mutex.synchronize { @current_uris.to_a }
    end

    # Returns an `Array` containing all URIs that shall be processed under
    # certain conditions
    #
    # @return [Array<URI>] URIs that shall be processed
    def staged_uris
      @mutex.synchronize { @staged_uris.to_a }
    end

    # Returns an `Array` containing all URIs that have been processed
    #
    # @return [Array<URI>] URIs that have been processed
    def cached_uris
      @mutex.synchronize { @cached_uris.to_a }
    end

    # Returns a `Queue` containing all URIs present in {#current_uris}
    #
    # @return [Queue]
    def current_uri_queue
      @current_uris.inject(Queue.new) { |queue, uri| queue << uri }
    end

    # Stages a URI
    #
    # @param [URI] URI to be staged
    def stage(uri)
      @mutex.synchronize { @staged_uris << uri }
    end

    # Caches a URI
    #
    # @param [URI] URI to be cached staged
    def cache(*uris)
      @mutex.synchronize { @cached_uris |= uris.map { |uri| URI(uri) } }
    end

    # Sets staged URIs as current and clears the set of staged URIs
    #
    # @param [URI] URI to be cached staged
    # @return [true, false] whether the resulting {#current_uris} set has URIs
    # @see #filter_staged_uris
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

    # Whether a URI is included in the set of current URIs
    #
    # @param [URI] URI to check
    # @return [true, false]
    def current?(uri)
      @current_uris.include?(uri)
    end

    # Whether a URI is included in the set of cached URIs
    #
    # @param [URI] URI to check
    # @return [true, false]
    def cached?(uri)
      @cached_uris.include?(uri)
    end

    # Whether a URI is forbidden by {#router}
    #
    # @param [URI] URI to check
    # @return [true, false]
    def forbidden?(uri)
      @router.forbids?(uri)
    end

    # Removes all URIs from {#staged_uris} that are subject to at least one of
    # the following criteria:
    # 1. The URI is included in the set of current URIs
    # 2. The URI is included in the set of cached URIs
    # 3. The URI is forbidden by {#router}
    #
    # @param [URI] URI to check
    # @return [true, false]
    def filter_staged_uris
      @staged_uris.delete_if do |uri|
        current?(uri) || cached?(uri)
      end
    end
  end
end
