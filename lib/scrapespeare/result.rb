require "hashie"

module Scrapespeare
  class Result

    def initialize
      @result = {}
    end

    def <<(other)
      @result.merge!(other) do |_, val_self, val_other|
        if val_self.is_a? Array
          if val_other.is_a? Array
            val_self.concat(val_other)
          else
            val_self << val_other
          end
        elsif val_other.is_a? Array
          if val_self.is_a? Array
            val_other.concat(val_self)
          else
            val_other << val_self
          end
        else
          [val_self, val_other]
        end
      end
    end

    def to_h
      @result
    end

    def to_json
      require "json"
      @result.to_json
    end

    def to_yaml
      require "yaml"
      Hashie.stringify_keys(@result).to_yaml
    end

  end
end
