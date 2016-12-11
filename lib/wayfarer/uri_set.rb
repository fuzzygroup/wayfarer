# frozen_string_literal: true
module Wayfarer
  # A set that considers trailing slashes and fragment identifiers of URIs as insignifcant
  # TODO Documentation
  class URISet
    def initialize(enumerable = [])
      @set = Set.new(enumerable)
    end

    def add(uri)
      @set << normalize(uri.to_s)
    end

    alias << add

    def include?(uri)
      @set.include?(normalize(uri.to_s))
    end

    alias member include?

    def to_a
      @set.to_a.map { |uri_str| URI(uri_str) }
    end

    private

    def normalize(uri_str)
      truncate_trailing_slash(truncate_fragment_identifier(uri_str))
    end

    def truncate_fragment_identifier(uri_str)
      uri_str.sub(/#.*/, "")
    end

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
