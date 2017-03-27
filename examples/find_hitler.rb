require_relative "../lib/wayfarer"
require "securerandom"

class FindHitler < Wayfarer::Job
  config.connection_count = 4
  config.reraise_exceptions = true

  always_route content_type: :json, to: :article
  always_route response_code: 500,  to: :error

  def article
    puts page.lede
    stage page.links
  end
end
