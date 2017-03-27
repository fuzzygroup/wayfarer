require_relative "../lib/wayfarer"

class Integration < Wayfarer::Job
  config.connection_count = 12
  config.reraise_exceptions = true
  config.frontier = :sidekiq
  config.ignore_uri_fragments = true

  queue_as :integration

  let(:data) { [] }

  before_crawl { puts "before_crawl" }

  after_crawl do
    puts "Collected:"
    puts locals[:data]
  end

  draw host: "salomatic.de"
  def article
    puts page.uri
    # locals[:data] << page_details
    stage page.links
  end

  private

  def page_details
    OpenStruct.new(
      uri: page.uri,
      summary: page.lede,
      keywords: page.keywords,
      link_count: page.links.count,
      author: page.author
    )
  end
end
