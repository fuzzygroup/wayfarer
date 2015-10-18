module Wayfarer
  module Finders
    def links(*rules)
      query("a", "href", *rules)
    end

    def stylesheets(*rules)
      query("link[rel='stylesheet']", "href", *rules)
    end

    def javascripts(*rules)
    end

    def images(*rules)
    end

    def videos(*rules)
    end

    private

    def query(selector, attr, *rules)
      nodes = if rules.any?
                doc.search(*rules).css(selector)
              else
                doc.css(selector)
              end

      uris = nodes.map do |node|
        begin
          URI.join(uri, node.attr(attr))
        rescue
          nil
        end
      end

      uris.uniq.find_all { |uri| uri.is_a?(URI) }
    end
  end
end
