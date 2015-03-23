require "hashie"
require "json"
require "yaml"

module Schablone
  class Result

    def initialize
      @result = {}
    end

    def <<(other)
      @result.merge!(other) do |_, val_self, val_other|
        if val_self.is_a? Array
          val_self.concat [val_other].flatten
        elsif val_other.is_a? Array
          val_other.concat [val_self].flatten
        else
          [val_self, val_other]
        end
      end
    end

    def to_h
      @result
    end

    def to_json
      @result.to_json
    end

    def to_yaml
      Hashie.stringify_keys(@result).to_yaml
    end

  end
end
