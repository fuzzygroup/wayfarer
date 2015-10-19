module Wayfarer
  module Finders
    def links(*rules)
      query("a", "href", *rules)
    end

    def stylesheets(*rules)
      query("link[rel='stylesheet']", "href", *rules)
    end

    # TODO Tests
    def javascripts(*rules)
      query("script", "src", *rules)
    end

    alias_method :scripts, :javascripts

    # TODO Tests
    def images(*rules)
      query("img", "src", *rules)
    end

    private

    def query(selector, attr, *rules)
      (rules.any? ? doc.search(*rules).css(selector) : doc.css(selector))
        .map { |node| URI.join(uri, node.attr(attr)) rescue nil }
        .find_all { |uri| uri.is_a?(URI) }
        .uniq
    end
  end
end
