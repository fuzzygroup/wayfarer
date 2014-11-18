Feature: Web scraping
    In order to extract information from a website
    As a developer
    I want to scrape the website

  Scenario: Scrape the site title
    Given a website
    And the following Scraper:
      """
      css :site_title, 'title'
      """
    When I scrape the website
    Then I get the following result:
      """
      { site_title: "Employee listing" }
      """

    Scenario: Arbitrary nesting
      Given a website
      And the following Scraper:
        """
        group :meta do
          css :site_title, 'title'
        end
        """
      When I scrape the website
      Then I get the following result:
        """
        {
          meta: {
            site_title: "Employee listing"
          }
        }
        """

  Scenario: Scrape heading and tagline
    Given a website
    And the following Scraper:
      """
      css :heading, '#site-header h1'
      css :tagline, '#site-header p'
      """
    When I scrape the website
    Then I get the following result:
      """
      {
        heading: "Employee listing",
        tagline: "Tagline"
      }
      """

  Scenario: Scrape attribute of an element
  Given a website
  And the following Scraper:
    """
    css :site_header_role, "#site-header", "role"
    """
  When I scrape the website
  Then I get the following result:
    """
    { site_header_role: "banner" }
    """

  Scenario: Scrape multiple elements
  Given a website
  And the following Scraper:
    """
    css :employee_names, "#employees li .name"
    """
  When I scrape the website
  Then I get the following result:
    """
    {
      employee_names: [
        "Nickolas Howe",
        "Ivah Swift",
        "Lucy Walker",
        "Sherwood Cremin"
      ]
    }
    """

  Scenario: Scrape nested elements
  Given a website
  And the following Scraper:
    """
    css :employees, "#employees li" do
      css :name, ".name"
      css :department, ".department"
      css :phone_number, ".phone-number"
    end
    """
  When I scrape the website
  Then I get the following result:
    """
    {
      employees: [
        {
          name: "Nickolas Howe",
          department: "Music, Computers & Grocery",
          phone_number: "887.929.1880"
        },
        {
          name: "Ivah Swift",
          department: "Kids, Sports & Shoes",
          phone_number: "1-853-036-7835"
        },
        {
          name: "Lucy Walker",
          department: "Automotive, Tools & Sports",
          phone_number: "933-216-7009"
        },
        {
          name: "Sherwood Cremin",
          department: "Outdoors",
          phone_number: "1-856-928-9445"
        }
      ]
    }
    """

    Scenario: Scoping
    Given a website
    And the following Scraper:
      """
      scope css: "#nickolas-howe" do
        css :name, ".name"
      end
      """
    When I scrape the website
    Then I get the following result:
      """
      {
        name: "Nickolas Howe"
      }
      """