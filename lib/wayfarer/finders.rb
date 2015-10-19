module Wayfarer
  module Finders
    # Returns the expanded `href` attribute URIs from all or targeted `<a>` tags.
    # @param [*Array<String>] *rules CSS/XPath expressions.
    # @return [Array<URI>]
    def links(*rules)
      query("a", "href", *rules)
    end

    # Returns the expanded `href` attribute URIs from all or targeted `<link rel="stylesheet" ...>` tags.
    # @param [*Array<String>] *rules CSS/XPath expressions.
    # @return [Array<URI>]
    def stylesheets(*rules)
      query("link[rel='stylesheet']", "href", *rules)
    end

    # Returns the expanded `src` attribute URIs from all or targeted `<script>` tags.
    # TODO Tests
    # @param [*Array<String>] *rules CSS/XPath expressions.
    # @return [Array<URI>]
    def javascripts(*rules)
      query("script", "src", *rules)
    end

    alias_method :scripts, :javascripts

    # Returns the expanded `src` attribute URIs from all or targeted `<img>` tags.
    # TODO Tests
    # @param [*Array<String>] *rules CSS/XPath expressions.
    # @return [Array<URI>]
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
