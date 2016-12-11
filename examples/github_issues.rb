# require "wayfarer"
require_relative "../lib/wayfarer"

class DummyJob < Wayfarer::Job
  routes do
    draw :overview,      host: "github.com", path: "/:user/:repo"
    draw :issue_listing, host: "github.com", path: "/:user/:repo/issues"
    draw :issue,         host: "github.com", path: "/:user/:repo/issues/:issue_id"
  end

  def overview
    puts "OVERVIEEW, #{issue_listing_uri}"
    visit issue_listing_uri
  end

  def issue_listing
    puts "LISTING"
    visit issue_uris
    visit next_issue_listing_uri
  end

  def issue
    puts "ISSUE"
    id = params["issue_id"]
    title = doc.css(".js-issue-title").text
    puts "#{id}: #{title}"
  end

  private

  def issue_listing_uri
    page.links ".sunken-menu-group:first-child li:nth-child(2) a"
  end

  def issue_uris
    page.links ".issue-title-link"
  end

  def next_issue_listing_uri
    page.links ".next_page"
  end
end

DummyJob.perform_now("https://github.com/rails/rails")
