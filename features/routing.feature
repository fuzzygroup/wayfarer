Feature: URI Rules
    As a developer
    In order to filter URIs
    I want to describe desired URIs with Rules

  Scenario: HostRule with String matcher
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

  Scenario: HostRule with RegExp matcher
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

      Scenario: Single PathRule
        Given the following Rule:
          """
          path "/foo"
          """
          And the following list of URIs:
            """
            http://example.com
            https://example.com
            http://example.com/foo
            https://example.com/foo
            http://example.com/foo?bar=1
            https://example.com/foo?bar=1
            http://example.com/foo/bar
            https://example.com/foo/bar
            """
        When I match the URIs against the Rule
        Then I get the following list of URIs:
          """
          http://example.com/foo
          https://example.com/foo
          http://example.com/foo?bar=1
          https://example.com/foo?bar=1
          """

  Scenario: Multiple HostRules
    Given the following Rule:
      """
      host "example.com"
      host /.org/
      """
      And the following list of URIs:
        """
        http://example.com
        https://example.com
        http://sub.example.com
        http://google.com
        http://yahoo.com
        http://fsf.org
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com
      https://example.com
      http://fsf.org
      """

  Scenario: QueryRule with String matcher
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

  Scenario: QueryRule with RegExp matcher
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

  Scenario: QueryRule with Integer matcher
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

  Scenario: QueryRule with Range matcher
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

  Scenario: HostRule with nested PathRule
    Given the following Rule:
      """
      host "example.com" do
        path "/foo/bar"
      end
      """
      And the following list of URIs:
        """
        http://example.com
        http://example.com/foo
        http://example.com/bar
        http://example.com/foo/bar
        https://example.com
        https://example.com/foo
        https://example.com/bar
        https://example.com/foo/bar
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com/foo/bar
      https://example.com/foo/bar
      """

  Scenario: HostRule with multiple nested PathRules
    Given the following Rule:
      """
      host "example.com" do
        path "/foo/bar"
        path "/qux"
      end
      """
      And the following list of URIs:
        """
        http://example.com
        http://example.com/foo
        http://example.com/bar
        http://example.com/foo/bar
        http://example.com/qux
        https://example.com
        https://example.com/foo
        https://example.com/bar
        https://example.com/foo/bar
        https://example.com/qux
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com/foo/bar
      http://example.com/qux
      https://example.com/foo/bar
      https://example.com/qux
      """

  Scenario: PathRule with nested QueryRule
    Given the following Rule:
      """
      path "/foo" do
        query bar: "qux"
      end
      """
      And the following list of URIs:
        """
        http://example.com
        http://example.com/foo
        http://example.com/foo?bar=qux
        https://google.com
        https://google.com/foo
        https://google.com/foo?bar=qux
        """
    When I match the URIs against the Rule
    Then I get the following list of URIs:
      """
      http://example.com/foo?bar=qux
      https://google.com/foo?bar=qux
      """
