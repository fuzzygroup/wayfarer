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
  routes do
    within host: "github.com"
      draw :overview, path: "/{user}/{repo}"
      draw :issues,   path: "/{user}/{repo}/issues"
      draw :issue,    path: "/{user}/{repo}/issues/{issue_id}"
    end
  end

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
  @issues = ThreadSafe::Array.new

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
    issue = {
      author: visit! user_path(params[:user]),
      id: params[:issue_id],
      title: issue_title,
      comments: issue_comments.map do |comment|
        date: comment_date(comment),
        text: comment_text(comment)
      end
    }

    @issues << issue

    []441
  end

  draw host: "github.com", path: "/{user}"
  def author
  end

  private

  def issues_uri(user, repo)
    "http://github.com/#{user}/#{repo}/issues"
  end

  def comment_author_uri(comment)
    author = comment.search(".author").to_s
    "http://github.com/#{author}"
  end

  def issue_title
    doc.search("js-issue-title").to_s
  end

  def issue_comments
    doc.search(".comment")
  end

  def comment_date(comment)
    comment.search(".timestamp time").attr("datetime")
  end

  def comment_text(comment)
    comment.search(".comment-body").to_s
  end
end
```