require "pry"
require "thread"

module Schablone
  class Processor
    attr_reader :result

    attr_reader :current_uris
    attr_reader :staged_uris
    attr_reader :cached_uris

    def initialize(entry_uri, scraper, router)
      @scraper = scraper
      @router = router

      @result = []

      @current_uris = [entry_uri]
      @staged_uris = []
      @cached_uris = []

      @fetcher = Fetcher.new
      @mutex = Mutex.new
    end

    def run
      loop do
        queue = current_uri_queue
        threads = []

        Schablone.config.threads.times do
          threads << Thread.new do
            until queue.empty?
              if uri = queue.pop(true) rescue nil
                process(uri)
              end
            end
          end
        end

        threads.each(&:join)
        @current_uris.clear

        @staged_uris.any? ? cycle : break
      end

    rescue RuntimeError => e
      Schablone.log.error(e)
    end

    private

    def process(uri)
      @mutex.synchronize do
        page = @fetcher.fetch(uri)
        page.links.each { |uri| stage(uri) }
        @result << @scraper.extract(page.parsed_document)
        cache(uri)
      end
    end

    def current_uri_queue
      @mutex.synchronize do
        @current_uris.inject(Queue.new) { |queue, uri| queue << uri }
      end
    end

    def stage(uri)
      return if current?(uri)   ||
                staged?(uri)    ||
                cached?(uri)    ||
                forbidden?(uri)

      staged_uris.push(uri)
    end

    def cache(uri)
      @cached_uris.push(uri)
    end

    def current?(uri)
      @current_uris.include?(uri)
    end

    def staged?(uri)
      @staged_uris.include?(uri)
    end

    def cached?(uri)
      @cached_uris.include?(uri)
    end

    def forbidden?(uri)
      @router.forbids?(uri)
    end

    def cycle
      @current_uris, @staged_uris = staged_uris, []
    end

    def emit
    end
  end
end
