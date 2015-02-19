module Scrapespeare
  module Parser

    module_function
    
    def parse(html_str)
      Nokogiri::HTML(html_str)
    end

  end
end
