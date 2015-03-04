module Scrapespeare
  class Page

    attr_reader :status_code
    attr_reader :body
    attr_reader :headers

    def initialize(*env)
      @status_code, @body, @headers = env
    end

  end
end
