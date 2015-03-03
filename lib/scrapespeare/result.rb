module Scrapespeare
  class Result < Hash

    def <<(other)
      self.merge(other) do |key, val_self, val_other|
        if val_self.is_a? Array
          val_self.concat(val_other)
        elsif val_other.is_a? Array
          val_other.concat(val_self)
        else
          [val_self, val_other]
        end
      end
    end

  end
end
