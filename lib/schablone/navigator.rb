require "set"

module Schablone
  class Navigator
    include Celluloid

    def initialize
      @current_uris = Set.new([])
      @staged_uris = Set.new([])
      @cached_uris = URISet.new
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
      @staged_uris |= uris.flatten.map { |uri| URI(uri) }
    end

    def cache(*uris)
      @cached_uris |= uris.flatten.map { |uri| URI(uri) }
    end

    def cycle
      filter_staged_uris! unless Schablone.config.allow_circulation
      return false if @staged_uris.empty?
      @current_uris, @staged_uris = @staged_uris, Set.new([])
      true
    end

    private

    def filter_staged_uris!
      @staged_uris.delete_if { |uri| current?(uri) || cached?(uri) }
    end

    def current?(uri)
      @current_uris.include?(uri)
    end

    def cached?(uri)
      @cached_uris.include?(uri)
    end
  end
end
