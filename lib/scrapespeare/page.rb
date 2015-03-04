module Scrapespeare
  class Page

    attr_reader :uri
    attr_reader :status_code
    attr_reader :body
    attr_reader :headers

    def initialize(*env)
      @uri, @status_code, @body, @headers = env
    end

    def parsed_document
      @parsed_document ||= Nokogiri::HTML(@body)
    end

  end
end
