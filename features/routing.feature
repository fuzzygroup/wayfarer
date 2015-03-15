Feature: Web scraping
    As a developer in need of data
    In order to extract data from a website
    I want to scrape the website

  Scenario: Scraping a single element
    Given a Crawler
    And the following Scraper:
      """
      css :site_title, 'title'
      """
    When I crawl "index.html"
    Then I get the following Result:
      """
      { site_title: "Employee listing" }
      """
