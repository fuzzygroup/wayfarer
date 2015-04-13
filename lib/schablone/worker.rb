module Schablone
  class Worker < Thread

    attr_reader :navigator

    def initialize(processor, uri_queue, navigator, router, emitter, fetcher)
      @processor = processor
      @uri_queue = uri_queue
      @navigator = navigator
      @router    = router
      @emitter   = emitter
      @fetcher   = fetcher

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
      @navigator.cache(uri)

      handler, proc = @router.invoke(uri)
      return unless handler && proc

      page = @fetcher.fetch(uri)
      page.links.each { |uri| @navigator.stage(uri) }

      Context.new(
        handler, @processor, page, @navigator, @emitter
      ).invoke(&proc)

    rescue Schablone::Fetcher::MaximumRedirectCountReached
      Schablone.log.warn("Maximum number of HTTP redirects reached")

    rescue SocketError
      Schablone.log.warn("DNS lookup failed")

    rescue Errno::ETIMEDOUT
      Schablone.log.warn("HTTP connection timed out.")

    ensure
      @navigator.cache(uri)
    end

  end
end
