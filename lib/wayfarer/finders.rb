# frozen_string_literal: true
module Wayfarer
  module Finders
    # Returns the expanded `href` attribute URIs from all or targeted `<a>` tags.
    # @param [*Array<String>] filters CSS/XPath expressions.
    # @return [Array<URI>]
    def links(*filters)
      query("a", "href", *filters)
    end

    # Returns the expanded `href` attribute URIs from all or targeted `<link rel="stylesheet" ...>` tags.
    # @param [*Array<String>] filters CSS/XPath expressions.
    # @return [Array<URI>]
    def stylesheets(*filters)
      query("link[rel='stylesheet']", "href", *filters)
    end

    # Returns the expanded `src` attribute URIs from all or targeted `<script>` tags.
    # TODO Tests
    # @param [*Array<String>] filters CSS/XPath expressions.
    # @return [Array<URI>]
    def javascripts(*filters)
      query("script", "src", *filters)
    end

    alias scripts javascripts

    # Returns the expanded `src` attribute URIs from all or targeted `<img>` tags.
    # TODO Tests
    # @param [*Array<String>] filters CSS/XPath expressions.
    # @return [Array<URI>]
    def images(*filters)
      query("img", "src", *filters)
    end

    private

    # TODO Lord have mercy
    # But this works
    def query(selector, attr, *filters)
      (filters.any? ? doc.search(*filters).css(selector) : doc.css(selector))
        .map { |node| URI.join(uri, node.attr(attr)) rescue nil }
        .find_all { |uri| uri.is_a?(URI) }
        .uniq
    end
  end
end
