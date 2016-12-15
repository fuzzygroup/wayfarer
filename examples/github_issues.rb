# frozen_string_literal: true
# require "wayfarer"
require_relative "../lib/wayfarer"

class CollectGithubIssues < Wayfarer::Job
  route.draw :overview, uri: "https://github.com/rails/rails"

  def overview
    puts "This looks like Rails to me!"
  end
end

# So we get more detailed output
# I'll omit this line hereafter
Wayfarer.log.level = :debug

# Perform this job now. I'll omit this line hereafter
CollectGithubIssues.perform_now("https://github.com/rails/rails", "https://example.com")
