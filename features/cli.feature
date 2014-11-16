@live
Feature: Command-line interface
    In order to extract information from a website
    As a user
    I want to scrape the website from the command-line

  Scenario: YAML output
    Given a file named "scraper.rb" with:
      """
      site_title css: "title"
      """
    When I run `scrapespeare yaml scraper.rb http://example.com`
    Then the exit status should be 0
    And the output should contain exactly:
      """
      ---
      :site_title: Example Domain

      """

  Scenario: JSON output
    Given a file named "scraper.rb" with:
      """
      site_title css: "title"
      """
    When I run `scrapespeare json scraper.rb http://example.com`
    Then the exit status should be 0
    And the output should contain exactly:
      """
      {"site_title":"Example Domain"}

      """