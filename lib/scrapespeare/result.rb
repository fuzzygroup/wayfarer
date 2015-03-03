module Scrapespeare
  class Result < Hash

    def <<(other)
      self.merge(other) do |key, val_self, val_other|
        [val_self, val_other]
      end
    end

  end
end
