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
  # config.selenium_argv = [:phantomjs]

  queue_as :gelbeseiten

  before_crawl do
    conn = r.connect(host: "localhost", port: 28015)
    # r.db_create("gelbeseiten").run(conn)
    # r.db("gelbeseiten").table_create("barbershops").run(conn)
    locals[:conn] = conn
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
      locality: params[:locality],
      name: entry_name,
      address: entry_address,
      zipcode: entry_zipcode,
      geolocation: entry_geolocation,
      phone: entry_phone,
      website: entry_website,
      social: entry_social
    }

    r.db("gelbeseiten").table("barbershops").insert(doc).run(locals[:conn])
  end

  private

  def entry_name
    doc.at_css(".name span").try(:text)
  end

  def entry_address
    doc.at_css(".adresse span:nth-child(1)").try(:text)
  end

  def entry_zipcode
    doc.at_css(".adresse span:nth-child(2)").try(:text)
  end

  def entry_geolocation
    doc.at_css(".adresse span:nth-child(3)").try(:text)
  end

  def entry_phone
    doc.at_css(".nummer_ganz .encode_me").try(:text)
  end

  def entry_website
    doc.at_css(".website .link").try(:[], :href)
  end

  def entry_social
    doc.at_css("SocialMedia .link").try(:[], :href)
  end
end
