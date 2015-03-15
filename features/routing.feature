Feature: URI Rules
    As a developer
    In order to filter URIs
    I want to describe desired URIs with Rules

  Scenario: Single HostRule with String constraint
    Given the following Rule:
      """
      host "example.com"
      """
      And the following list of URIs:
        """
        http://example.com
        https://example.com
        http://sub.example.com
        http://google.com
        http://yahoo.com
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com
      https://example.com
      """

  Scenario: Single HostRule with RegExp constraint
    Given the following Rule:
      """
      host /example.com/
      """
      And the following list of URIs:
        """
        http://example.com
        https://example.com
        http://sub.example.com
        http://google.com
        http://yahoo.com
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com
      https://example.com
      http://sub.example.com
      """

  Scenario: Single HostRule with RegExp matching
    Given the following Rule:
      """
      host /example.com/
      """
      And the following list of URIs:
        """
        http://example.com
        https://example.com
        http://sub.example.com
        http://google.com
        http://yahoo.com
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com
      https://example.com
      http://sub.example.com
      """

  Scenario: QueryRule with String constraint
    Given the following Rule:
      """
      query foo: "bar"
      """
      And the following list of URIs:
        """
        http://example.com
        http://example.com?foo=bar
        http://example.com?foo=baz
        http://example.com?foo=42
        http://example.com/qux?foo=bar
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com?foo=bar
      http://example.com/qux?foo=bar
      """

  Scenario: QueryRule with RegExp constraint
    Given the following Rule:
      """
      query foo: /ba/
      """
      And the following list of URIs:
        """
        http://example.com
        http://example.com?foo=bar
        http://example.com?foo=baz
        http://example.com?foo=42
        http://example.com/qux?foo=bar
        http://example.com/qux?foo=baz
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com?foo=bar
      http://example.com?foo=baz
      http://example.com/qux?foo=bar
      http://example.com/qux?foo=baz
      """

  Scenario: QueryRule with Integer constraint
    Given the following Rule:
      """
      query foo: 42
      """
      And the following list of URIs:
        """
        http://example.com
        http://example.com?foo=bar
        http://example.com?foo=baz
        http://example.com?foo=42
        http://example.com/qux?foo=bar
        http://example.com/qux?foo=baz
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com?foo=42
      """

  Scenario: QueryRule with Range constraint
    Given the following Rule:
      """
      query foo: 1..99
      """
      And the following list of URIs:
        """
        http://example.com
        http://example.com?foo=0
        http://example.com?foo=25
        http://example.com?foo=50
        http://example.com?foo=75
        http://example.com?foo=100
        http://example.com/qux?foo=bar
        http://example.com/qux?foo=baz
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com?foo=25
      http://example.com?foo=50
      http://example.com?foo=75
      """
