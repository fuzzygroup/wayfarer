Feature: URI Rules
    As a developer
    In order to filter URIs
    I want to describe desired URIs with Rules

  Scenario: Single HostRule with String matching
    Given the following Rule:
      """
      host "example.com"
      """
      And the following list of URIs:
        """
        http://example.com/
        https://example.com/
        http://sub.example.com/
        http://google.com/
        http://yahoo.com/
        """
    When I match the URIs against the HostRule
    Then I get the following list of URIs:
      """
      http://example.com/
      https://example.com/
      """

  Scenario: Single HostRule with RegExp matching
    Given the following Rule:
      """
      host /example.com/
      """
      And the following list of URIs:
        """
        http://example.com/
        https://example.com/
        http://sub.example.com/
        http://google.com/
        http://yahoo.com/
        """
    When I match the URIs against the HostRule
    Then I get the following list of URIs:
      """
      http://example.com/
      https://example.com/
      http://sub.example.com/
      """

  Scenario: HostRule with nested PathRule
    Given the following Rule:
      """
      host "example.com" do
        path "/foo"
      end
      """
      And the following list of URIs:
        """
        http://example.com/
        http://example.com/foo
        http://example.com/bar
        http://example.com/foo/bar
        """
    When I match the URIs against the HostRule
    Then I get the following list of URIs:
      """
      http://example.com/foo
      """