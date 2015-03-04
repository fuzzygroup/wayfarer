module Scrapespeare
  class Result

    def initialize
      @result = {}
    end

    def <<(other)
      @result.merge!(other) do |key, val_self, val_other|
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

  end
end
