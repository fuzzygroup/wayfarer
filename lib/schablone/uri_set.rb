module Schablone
  # @private
  #
  # A {URISet} decorates a `Set` and differs in behaviour of {#add} and
  # {#include?}. URIs are stored as Strings internally.
  #
  # {#add} normalizes the passed URI by removing trailing slashes and
  # fragment identifiers:
  #
  # ```
  # uri_set << URI("http://example.com/#fragment-identifier")
  # uri_set.to_a.first # => #<URI::HTTP:... URL:http://example.com>
  # ```
  #
  # {#include?} normalizes the passed URI before checking for membership:
  # ```
  # uri_set << URI("http://example.com/#fragment-identifier")
  # uri_set.include?(URI("http://example.com")) # => true
  # ```
  # @param enumerable [Enumerable]
  class URISet
    def initialize(enumerable = [])
      @set = Set.new(enumerable)
    end

    def add(uri)
      @set << normalize(uri.to_s)
    end

    alias_method :<<, :add

    def include?(uri)
      @set.include?(normalize(uri.to_s))
    end

    alias_method :member, :include?

    def to_a
      @set.to_a.map { |uri_str| URI(uri_str) }
    end

    private

    # Removes trailing slashes and fragment identifiers from Strings
    #
    # @return [String] the normalized URI String
    def normalize(uri_str)
      truncate_trailing_slash(truncate_fragment_identifier(uri_str))
    end

    # Removes fragment identifiers from Strings
    #
    # @return [String] the normalized URI String
    def truncate_fragment_identifier(uri_str)
      uri_str.sub(/#.*/, "")
    end

    # Removes trailing slashes from Strings
    #
    # @return [String] the normalized URI String
    def truncate_trailing_slash(uri_str)
      uri_str.chomp("/")
    end

    def method_missing(method, *argv, &proc)
      @set.send(method, *argv, &proc)
    end

    def respond_to_missing?(method, private = false)
      @set.respond_to?(method) || super
    end
  end
end
