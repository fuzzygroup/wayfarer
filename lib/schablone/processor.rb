require "set"
require "thread"

module Schablone
  class Processor
    attr_reader :result

    def initialize(entry_uri, scraper, router)
      @scraper = scraper
      @router = router

      @fetcher = Fetcher.new
      @result = []

      @current_uris = [entry_uri]
      @staged_uris = []
      @cached_uris = Set.new([])

      @mutex = Mutex.new
    end

    def current_uris
      @mutex.synchronize { @current_uris }
    end

    def staged_uris
      @mutex.synchronize { @staged_uris }
    end

    def cached_uris
      @mutex.synchronize { @cached_uris.to_a }
    end

    def run
      loop do
        queue = current_uri_queue
        threads = []

        Schablone.config.threads.times do
          threads << Thread.new do
            until queue.empty?
              if uri = queue.pop(true) rescue nil
                Schablone.log.info("About to hit: #{uri}")
                process(uri)
              end
            end
          end
        end

        threads.each(&:join)

        if @staged_uris.any?
          filter_staged_uris
          cycle
        else
          threads.each(&:kill)
          @fetcher.free
          break
        end
      end

    rescue RuntimeError => error
      Schablone.log.error(error)
    end

    private

    def process(uri)
      page = @fetcher.fetch(uri)
      page.links.each { |uri| stage(uri) }
      @result << @scraper.extract(page.parsed_document)
      cache(uri)
    end

    def current_uri_queue
      @current_uris.inject(Queue.new) { |queue, uri| queue << uri }
    end

    def stage(uri)
      @mutex.synchronize { @staged_uris << remove_fragment_identifier(uri) }
    end

    def cache(uri)
      @mutex.synchronize { @cached_uris << uri.to_s }
    end

    def current?(uri)
      @current_uris.include?(uri)
    end

    def cached?(uri)
      @cached_uris.include?(uri.to_s)
    end

    def forbidden?(uri)
      @router.forbids?(uri)
    end

    def filter_staged_uris
      @staged_uris.uniq!
      @staged_uris.delete_if do |uri|
        forbidden?(uri) || current?(uri) || cached?(uri)
      end
    end

    def cycle
      @current_uris, @staged_uris = @staged_uris, []
    end

    def remove_fragment_identifier(uri)
      return uri unless uri.fragment
      URI(uri.to_s.sub(/#.*/, ""))
    end
  end
end
