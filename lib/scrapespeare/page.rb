module Scrapespeare
  Page = Struct.new(
    :response_body,
    :parsed_document,
    :status_code,
    :headers
  )
end
