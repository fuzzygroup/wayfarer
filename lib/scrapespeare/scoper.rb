module Scrapespeare
  class Scoper

    attr_reader :matcher

    def initialize(matcher, &proc)
      @matcher = Matcher.new(matcher)
      instance_eval(&proc) if block_given?
    end

  end
end
