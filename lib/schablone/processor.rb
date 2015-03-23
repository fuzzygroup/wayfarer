require "pry"
require "thread"
require "thread/pool"

module Schablone
  class Processor

    attr_reader :current_uris
    attr_reader :staged_uris
    attr_reader :cached_uris
    attr_reader :result

    def initialize(entry_uri, scraper, router)
      @scraper = scraper
      @router  = router
      @fetcher = Fetcher.new

      @result  = []

      @current_uris = [entry_uri]
      @staged_uris  = []
      @cached_uris  = []

      @pool  = Thread.pool(Schablone.config.threads)
      @mutex = Mutex.new
    end

    def run
      @pool.process { step while has_next_uri? }
      @pool.shutdown
    end

    def step
      uri = next_uri

      Schablone.logger.info "About to hit #{uri}"

      cache_uri(uri)
      page = fetch(uri)

      Schablone.logger.info "Reponse from #{uri}: #{page.status_code}"

      return if page.status_code > 299

      page.links.each { |uri| stage_uri(uri) }

      @result << @scraper.extract(page.parsed_document)

    rescue => error
      Schablone.logger.fatal(error)
    end

    private
    def fetch(uri)
      @fetcher.fetch(uri)
    end

    def next_uri
      @mutex.synchronize { @current_uris.shift }
    end

    def has_next_uri?
      @mutex.synchronize do
        return true unless @current_uris.empty?
        @staged_uris.any? ? (cycle; true) : false
      end
    end

    def stage_uri(uri)
      @mutex.synchronize do
        return if @current_uris.include?(uri) ||
                  @staged_uris.include?(uri)  ||
                  @cached_uris.include?(uri)  ||
                  @router.forbids?(uri)

        @staged_uris << uri
      end
    end

    def cache_uri(uri)
      @mutex.synchronize { @cached_uris << uri }
    end

    def cycle
      @current_uris, @staged_uris = @staged_uris, []
    end

  end
end
