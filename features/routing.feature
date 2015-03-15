Feature: URI Rules
    As a developer
    In order to filter URIs
    I want to describe desired URIs with Rules

  Scenario: Single HostRule with String matching
    Given the HostRule "example.com"
      And the following list of URIs:
        """
        http://example.com/
        https://example.com/
        http://sub.example.com/
        http://google.com/
        http://yahoo.com/
        """
    When I crawl "index.html"
    Then I get the following Result:
      """
      { site_title: "Employee listing" }
      """
