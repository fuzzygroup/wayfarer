module Scrapespeare
  module HTTPAdapters

    class NetHTTPAdapter

      def self.fetch(uri)
        target = URI(uri)
        response = Net::HTTP.get(target)
      end

    end

  end
end
