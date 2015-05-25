module Schablone
  class Worker < Thread
    attr_reader :navigator

    def initialize(processor, navigator, uri_queue, router)
      @processor = processor
      @navigator = navigator
      @uri_queue = uri_queue
      @router    = router

      super(self, &:perform)
    end

    def perform
      until @uri_queue.empty?
        uri = @uri_queue.pop(true) rescue nil ? scrape(uri) : next
      end
    end

    private

    def scrape(uri)
      payload, params = @router.route(uri)
      return unless payload && params

      HTTPAdapters::AdapterPool.with do |adapter|
        page = adapter.fetch(uri)
        context = Context.new(@processor, @navigator, adapter, page, params)
        context.evaluate(&payload)
      end

    rescue Schablone::HTTPAdapters::NetHTTPAdapter::MaximumRedirectCountReached
      Schablone.log.info("Maximum number of HTTP redirects reached for #{uri}")

    rescue Schablone::HTTPAdapters::NetHTTPAdapter::MalformedRedirectURI
      Schablone.log.info("Got a malformed redirect URI for #{uri}")

    rescue Timeout::Error
      Schablone.log.info("HTTP adapter timed out while scraping #{uri}")

    rescue SocketError
      Schablone.log.info("DNS lookup failed for #{uri}")

    rescue Errno::ETIMEDOUT
      Schablone.log.info("HTTP connection timed out for #{uri}")

    ensure
      @navigator.cache(uri)
    end
  end
end
