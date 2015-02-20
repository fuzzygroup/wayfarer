module Scrapespeare
  class AlterableURI

    def initialize(uri)
      @uri = uri
    end

    def respond_to?(sym, include_private = false)
      super || @uri.respond_to?(sym, include_private)
    end

    private
    def method_missing(sym)
      @uri.respond_to?(sym) ? @uri.send(sym) : super(sym)
    end

  end
end
