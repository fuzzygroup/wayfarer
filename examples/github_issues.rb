# frozen_string_literal: true
# require "wayfarer"
require_relative "../lib/wayfarer"
class CollectGithubIssues < Wayfarer::Job
  routes do
    draw :overview,      host: "github.com", path: "/:user/:repo"
    draw :issue_listing, host: "github.com", path: "/:user/:repo/issues"
    draw :issue,         host: "github.com", path: "/:user/:repo/issues/:id"

    host "github.com" do
      draw :overview, path: "/:user/:repo"
    end
  end

  def overview
    stage issue_listing_uri
  end

  def issue_listing
    stage issue_uris
  end

  def issue
    puts "Now that's an issue!"
  end

  private

  def issue_listing_uri
    page.links ".reponav-item"
  end

  def issue_uris
    page.links ".Box-row-link"
  end
end
