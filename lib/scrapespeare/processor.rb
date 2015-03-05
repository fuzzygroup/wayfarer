module Scrapespeare
  class Processor

    attr_reader :staged

    def initialize(entry_uri)
      @entry_uri = entry_uri

      @result  = Result.new

      @cached  = []
      @current = []
      @staged  = []
    end

    def process
      
    end

    private
    def stage_uri(uri)
      @staged << uri
    end

  end
end
