module Schablone
  class Worker < Thread

    attr_reader :navigator

    def initialize(processor, uri_queue, navigator, router, emitter, adapter)
      @processor = processor
      @uri_queue = uri_queue
      @navigator = navigator
      @router    = router
      @emitter   = emitter
      @adapter   = adapter

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
      handler, proc = @router.invoke(uri)
      return unless handler && proc

      page = http_adapter.fetch(uri)

      Context.new(
        handler, @processor, page, @navigator, @emitter
      ).invoke(&proc)

    rescue Schablone::HTTPAdapters::NetHTTPAdapter::MaximumRedirectCountReached
      Schablone.log.warn("Maximum number of HTTP redirects reached")

    rescue SocketError
      Schablone.log.warn("DNS lookup failed")

    rescue Errno::ETIMEDOUT
      Schablone.log.warn("HTTP connection timed out.")

    ensure
      @navigator.cache(uri)
    end

    def http_adapter
      @adapter ||= HTTPAdapters::SeleniumAdapter.new
    end

    def free_http_adapter
      http_adapter.free if Schablone.config.http_adapter == :selenium
    end

  end
end
