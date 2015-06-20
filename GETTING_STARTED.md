# Getting started
## Tasks
This guides.

```ruby
require "scrapespeare"

class GitHubIndexer < Scrapespeare::Indexer
end
```
Now you have an Indexer. Run it by calling `::crawl` on it and passing it a URI:

```ruby
GitHubIndexer.crawl("http://github.com/bauerd/scrapespeare") # => true
```

As expected, nothing happened. 

```ruby
class GitHubIndexer < Scrapespeare::Indexer
  def overview
  end

  def issues
  end

  def issue
  end
end
```

As expected, nothing happened. 

```ruby
class GitHubIndexer < Scrapespeare::Indexer

  draw host: "github.com", path: "/{user}/{repo}"
  def overview
  end

  draw host: "github.com", path: "/{user}/{repo}/issues"
  def issues
  end

  draw host: "github.com", path: "/{user}/{repo}/issues/{issue_id}"
  def issue
  end
end
```

As expected, nothing happened. 

```ruby
class GitHubIndexer < Scrapespeare::Indexer

  draw host: "github.com", path: "/{user}/{repo}"
  def overview
  end

  draw host: "github.com", path: "/{user}/{repo}/issues"
  def issues
  end

  draw host: "github.com", path: "/{user}/{repo}/issues/{issue_id}"
  def issue
  end
end
```

As expected, nothing happened. 

```ruby
class GitHubIndexer < Scrapespeare::Indexer
  @issues = []

  draw host: "github.com", path: "/{user}/{repo}"
  def overview
    user = params[:user]
    repo = params[:repo]
    issues_uri(user, repo)
  end

  draw host: "github.com", path: "/{user}/{repo}/issues"
  def issues
    page.links(".issue-title-link", "a.next_pages")
  end

  draw host: "github.com", path: "/{user}/{repo}/issues/{issue_id}"
  def issue
    issue = {}
    issue[:issue_id] = params[:issue_id"]
    issue[:title]    = issue_title
    issue[:comments] = issue_comments.map do |comment|
      {
        author: comment.search(".author").to_s,
        date:   comment.search(".timestamp time").attr("datetime"),
        text:   comment.search(".comment-body").to_s
      }
    end

    @issues << issue
  end

  private

  def issues_uri(user, repo)
    "http://github.com/#{user}/#{repo}/issues"
  end

  def issue_title
    doc.search("js-issue-title").to_s
  end

  def issue_comments
    doc.search(".comment")
  end
end
```