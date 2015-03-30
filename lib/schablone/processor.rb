require "set"
require "thread"

module Schablone
  class Processor
    attr_reader :result
    attr_reader :navigator

    def initialize(entry_uri, scraper, router)
      @scraper = scraper
      @navigator = Navigator.new(router)
      @fetcher = Fetcher.new
      @result = []

      @navigator.stage(entry_uri)
      @navigator.cycle
    end

    def run
      loop do
        queue = @navigator.current_uri_queue
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

        if @navigator.staged_uris.any?
          @navigator.filter_staged_uris
          @navigator.cycle
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
      page.links.each { |uri| @navigator.stage(uri) }
      @result << @scraper.extract(page.parsed_document)
      @navigator.cache(uri)
    end
  end
end
