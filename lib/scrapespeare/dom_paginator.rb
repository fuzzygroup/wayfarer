module Scrapespeare
  class DOMPaginator < Paginator

    attr_reader :matcher, :uri_constructor

    def initialize(scraper, uri, matcher_hash)
      super(scraper, uri)
      @matcher = Matcher.new(matcher_hash)
      @uri_constructor = URIConstructor
    end

    private
    def successor_uri
      path = matcher.match(@doc).first.attr("href")
      uri_constructor.construct(uri, path)
    end

  end
end
