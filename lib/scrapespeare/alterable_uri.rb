module Scrapespeare
  class AlterableURI

    def initialize(uri)
      @uri = uri
    end

    def method_missing(method)
      @uri.respond_to?(method) ? @uri.send(method) : super(method)
    end

  end
end
