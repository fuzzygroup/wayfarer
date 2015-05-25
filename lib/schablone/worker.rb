module Schablone
  class Worker < Thread
    attr_reader :navigator

    def initialize(processor, uri_queue, router)
      @processor = processor
      @uri_queue = uri_queue
      @router    = router

      super(self, &:perform)
    end

    def perform
      until @uri_queue.empty?
        if uri = @uri_queue.pop(true) rescue nil
          puts "PROCESSING URI: #{uri}"
          scrape(uri)
        end
      end
    end

    private

    def scrape(uri)
      puts "CAHING URI: #{uri}"
      @processor.navigator.cache(uri)
      puts "CACHED URIS: #{@processor.navigator.cached_uris}"

      payload, params = @router.route(uri)
      return unless payload && params

      HTTPAdapters::AdapterPool.with do |adapter|
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
