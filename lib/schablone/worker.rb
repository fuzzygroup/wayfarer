module Schablone
  class Worker < Thread

    attr_reader :navigator
    attr_reader :result

    def initialize(navigator, router, fetcher)
      @navigator = navigator
      @router    = router
      @fetcher   = fetcher

      @result = []

      super(self, &:work)
    end

    def work
      queue = @navigator.current_uri_queue

      until queue.empty?
        if uri = queue.pop(true) rescue nil
          Schablone.log.info("About to hit: #{uri}")
          process(uri)
        end
      end
    end

    private

    def process(uri)
      page = @fetcher.fetch(uri)
      page.links.each { |uri| @navigator.stage(uri) }

      if scraper = @router.invoke(uri)
        @result << scraper.call
      end

      @navigator.cache(uri)

    rescue Schablone::Fetcher::MaximumRedirectCountReached
      Schablone.log.warn("Maximum number of HTTP redirects reached")

    rescue SocketError
      Schablone.log.warn("DNS lookup failed")
    end

  end
end
