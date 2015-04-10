module Schablone
  class Worker < Thread

    attr_reader :navigator
    attr_reader :result

    def initialize(navigator, router, emitter, fetcher)
      @navigator = navigator
      @router    = router
      @emitter   = emitter
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
        Context.new(page, @navigator, @emitter).invoke(&scraper)
      end

    rescue Schablone::Fetcher::MaximumRedirectCountReached
      Schablone.log.warn("Maximum number of HTTP redirects reached")

    rescue SocketError
      Schablone.log.warn("DNS lookup failed")

    ensure
      @navigator.cache(uri)
    end

  end
end
