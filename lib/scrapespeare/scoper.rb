module Scrapespeare
  class Scoper

    attr_reader :matcher

    def initialize(matcher, &proc)
      @matcher = Matcher.new(matcher)
    end

  end
end
