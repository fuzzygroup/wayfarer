module Schablone
  class Worker < Thread
    attr_reader :navigator

    def initialize(processor, uri_queue, router)
      Thread.abort_on_exception = true

      @processor = processor
      @uri_queue = uri_queue
      @router    = router

      super(self, &:perform)
    end

    def perform
      until @uri_queue.empty?
        (uri = @uri_queue.pop(true) rescue nil) ? scrape(uri) : next
      end
    end

    private

    def scrape(uri)
      Thread.exit if @processor.halted?
      @processor.navigator.cache(uri)

      payload, params = @router.route(uri)
      return unless payload && params

      @processor.adapter_pool.with do |adapter|
        page = adapter.fetch(uri)
        indexer = Indexer.new(@processor, adapter, page, params)
        indexer.evaluate(&payload)
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
    end
  end
end
