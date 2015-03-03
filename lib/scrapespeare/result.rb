module Scrapespeare
  class Result < Hash

    include Hashie::Extensions::DeepMerge

    def <<(other)
      self.deep_merge(other) do |key, val_self, val_other|
        [val_self, val_other]
      end
    end

  end
end
