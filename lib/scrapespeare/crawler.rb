module Scrapespeare
  class Crawler

    attr_reader   :base_uri
    attr_reader   :scrapers
    attr_accessor :uri_template

    def initialize(&proc)
      @result        = Result.new
      @scrapers      = {}

      instance_eval(&proc) if block_given?
    end

    def crawl(uri_or_template_params)
      @base_uri = case uri_or_template_params
                  when String then URI(uri_or_template_params)
                  when Hash   then build_base_uri(uri_or_template_params)
                  end
    end

    def scrape(sym, &proc)
      @scrapers[sym] = Scraper.new(&proc)
    end

    def config
      yield Scrapespeare.config if block_given?
    end

    alias_method :configure, :config

    private
    def build_base_uri(params)
      fail "uri_template is missing" unless @uri_template

      params.each { |key, val| params[key] = URI.escape(val.to_s) }
      URI(@uri_template % params)

    rescue KeyError
      fail ArgumentError, "Insufficient URI parameters given"
    end

  end
end
