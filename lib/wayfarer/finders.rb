module Wayfarer
  module Finders
    def links(*argv)
      links = doc.search(*argv).map do |node|
        begin
          URI.join(@uri, node.attr("href"))
        rescue
          nil
        end
      end

      links.uniq.find_all { |link| link.is_a?(URI) }
    end
  end
end
