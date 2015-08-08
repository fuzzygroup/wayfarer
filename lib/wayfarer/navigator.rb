require "set"

module Wayfarer
  class Navigator
    include Celluloid
    include Celluloid::Logger

    def initialize
      @current_uris = Set.new([])
      @staged_uris  = Set.new([])
      @cached_uris  = NormalizedURISet.new

      debug("[#{self}] Navigator spawned")
    end

    def current_uris
      @current_uris.to_a
    end

    def staged_uris
      @staged_uris.to_a
    end

    def cached_uris
      @cached_uris.to_a
    end

    def stage(*uris)
      @staged_uris |= uris.map { |uri| URI(uri) }
    end

    def cache(*uris)
      @cached_uris |= uris.map { |uri| URI(uri) }
    end

    def cycle
      unless Wayfarer.config.allow_circulation
        cache(*current_uris)
        filter_staged_uris!
      end

      return false if @staged_uris.empty?
      @current_uris, @staged_uris = @staged_uris, Set.new([])
      true
    end

    private

    def filter_staged_uris!
      @staged_uris.delete_if { |uri| @cached_uris.include?(uri) }
    end
  end
end
