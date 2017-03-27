require_relative "../lib/wayfarer"
require "rethinkdb"

Entry = Struct.new(
  :id,
  :slug,
  :city,
  :locality,
  :name,
  :address,
  :zipcode,
  :geo_locality,
  :phone,
  :website
)

class Gelbeseiten < Wayfarer::Job
  include RethinkDB::Shortcuts

  config.connection_count = 12
  config.reraise_exceptions = true
  config.frontier = :sidekiq
  config.ignore_uri_fragments = true
  # config.http_adapter = :selenium
  # config.selenium_argv = [:chrome]

  queue_as :gelbeseiten

  before_crawl do
    locals[:conn] = r.connect(host: "localhost", port: 28015)
    # r.db_create("gelbeseiten").run(@conn)
    # r.db("gelbeseiten").table_create("barbershops").run(@conn)
  end

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
    stage "/branchenbuch/friseur"
    stage page.links
  end

  def entry
    doc = {
      id: params[:id],
      slug: params[:slug],
      city: params[:city],
      locality: params[:locality]
    }

    r.db("gelbeseiten").table("barbershops").insert(doc).run(locals[:conn])
  end

  private

  def entry_name
    doc.at_css(".name span").try(:text)
  end

  def entry_address
    doc.at_css(".adresse span").try(:text)
  end

  def entry_zipcode
    doc.at_css(".adresse span").try(:text)
  end

  def entry_geolocation
    at_css(".adresse span").try(:text)
  end
end
