require "thread_safe"
require_relative "../lib/schablone"
require "mustermann"

Celluloid.task_class = Celluloid::TaskThread

Schablone.config do |c|
  c.scraper_pool_size = 64
end

class MyCrawler < Schablone::Task
  draw host: "github.com", path: "/:user/:repo"
  def repo
    user = params["user"]
    repo = params["repo"]
    visit issues_uri(user, repo)
  end

  draw host: "github.com", path: "/:user/:repo/issues"
  def issues
    issue_links     = page.links ".issue-title-link"
    pagination_link = page.links ".next_page"
    visit issue_links, pagination_link
  end

  draw host: "github.com", path: "/:user/:repo/issues/:issue_id"
  def issue
  end

  private

  def issues_uri(user, repo)
    "https://github.com/#{user}/#{repo}/issues"
  end
end

MyCrawler.crawl("http://github.com/rails/rails")
