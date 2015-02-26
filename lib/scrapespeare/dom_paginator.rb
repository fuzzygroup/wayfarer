require "pry"

module Scrapespeare
  class DOMPaginator

    def initialize(scraper, matcher_hash)
      @scraper      = scraper
      @matcher      = Matcher.new(matcher_hash)
      @http_adapter = HTTPAdapters::NetHTTPAdapter.new

      @state = {}
    end

    def paginate(uri)
      @state[:uri] = uri

      catch(:pagination_ended) { return }

      loop do
        _, response_body, _ = fetch(@state[:uri])
        doc = parse(response_body)

        yield @scraper.extract(doc)

        @state[:uri] = successor_uri(doc)
      end
    end

    private
    def fetch(uri)
      @http_adapter.fetch(uri)
    end

    def parse(html_str)
      Parser.parse(html_str)
    end

    def pagination_element(doc)
      matched_nodes = @matcher.match(doc)

      if matched_nodes.empty? || matched_nodes.count > 1
        throw :pagination_ended
      else
        matched_nodes.first
      end
    end

    def successor_uri(doc)
      href_attr = Evaluator.evaluate_attribute(pagination_element(doc), :href)
      URI.join(@state[:uri], href_attr)
    end

    def process
    end

  end
end
