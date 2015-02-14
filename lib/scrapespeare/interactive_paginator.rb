module Scrapespeare
  class InteractivePaginator < Paginator

    def initialize(scraper, uri, &proc)
      super(scraper, uri)
      @paginator = proc
    end

    def each
      @paginator.call()
    end

  end
end
