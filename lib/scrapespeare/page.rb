module Scrapespeare
  class Page < Struct.new(:status_code, :body, :headers)
  end
end
