module Schablone
  class Worker < Thread
    attr_reader :navigator

    def initialize(processor, navigator, uri_queue, router)
      @processor = processor
      @navigator = navigator
      @uri_queue = uri_queue
      @router    = router

      super(self, &:work)
    end

    def work
      until @uri_queue.empty?
        if uri = @uri_queue.pop(true) rescue nil
          Schablone.log.info("About to hit: #{uri}")
          process(uri)
        end
      end
    end

    private

    def process(uri)
      scraper, params = @router.route(uri)
      return unless scraper && params

      page = adapter.fetch(uri)

      context = Context.new(@processor, @navigator, adapter, page, params)
      context.evaluate(&scraper)

    rescue Schablone::HTTPAdapters::NetHTTPAdapter::MaximumRedirectCountReached
      Schablone.log.warn("Maximum number of HTTP redirects reached")
    rescue SocketError
      Schablone.log.warn("DNS lookup failed")
    rescue Errno::ETIMEDOUT
      Schablone.log.warn("HTTP connection timed out.")
    ensure
      @navigator.cache(uri)
    end

    def adapter
      @adapter ||= HTTPAdapters::AdapterPool.instance
    end
  end
end
