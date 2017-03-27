require_relative "../lib/wayfarer"

class Gelbeseiten < Wayfarer::Job
  config.connection_count = 4
  config.reraise_exceptions = true
  config.frontier = :sidekiq
  config.ignore_uri_fragments = true
  # config.http_adapter = :selenium
  # config.selenium_argv = [:chrome]

  queue_as :gelbeseiten

  let(:entries) { [] }

  routes do
    draw :index do
      host "www.gelbeseiten.de" do
        path "/friseur"
        path "/branchenbuch/friseur"
      end

      host "www.gelbeseiten.de", path: "/friseur/:city"
    end

    draw :entry do
      host "adresse.gelbeseiten.de", path: "/:id/:slug/:city/:locality"
    end
  end

  def index
    puts "HIIIII"
    puts "INDEX: #{page.uri}"
    stage "/branchenbuch/friseur"
    stage page.links
  end

  def entry
    puts "ENTRY: #{page.uri}"

    name = doc.at_css(".name span").try(:text)
    address = doc.at_css(".adresse span").try(:text)
    zipcode = doc.at_css(".adresse span").try(:text)
    locality = doc.at_css(".adresse span").try(:text)

    number = doc.at_css(".teilnehmertelefon .nummer_ganz .nummer").try(:text)
    suffix = doc.at_css(".teilnehmertelefon .nummer_ganz .suffix").try(:text)

    website = doc.at_css(".website .link .text").try(:text)

    puts "#{name} at #{address}"

    stage page.links
  end

  private

  def index_uri(city)
    "/friseur/foobar"
  end
end
