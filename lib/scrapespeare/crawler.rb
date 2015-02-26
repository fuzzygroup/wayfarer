module Scrapespeare
  class Crawler

    attr_reader   :scraper
    attr_reader   :base_uri
    attr_accessor :uri_template

    def initialize(&proc)
      @scraper = Scraper.new
      @parser  = Parser

      instance_eval(&proc) if block_given?
    end

    def crawl(uri_or_template_params)
      @base_uri = case uri_or_template_params
                  when String then URI(uri_or_template_params)
                  when Hash   then build_base_uri(uri_or_template_params)
                  end
    end

    def define_scraper(&proc)
      @scraper.instance_eval(&proc) if block_given?
    end

    def configure
      yield Scrapespeare.config if block_given?
    end

    def set_evaluator_for(identifier, evaluator = nil, &proc)
      if evaluator
        @scraper.pass_evaluator(identifier, evaluator)
      elsif proc
        @scraper.pass_evaluator(identifier, proc)
      else
        fail ArgumentError, "No evaluator given"
      end
    end

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
