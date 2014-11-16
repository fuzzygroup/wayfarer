Feature: Web scraping
    In order to extract information from a website
    As a developer
    I want to scrape the website

  Scenario: Scrape the site title
    Given a website
    And the following Scraper:
      """
      site_title css: 'title'
      """
    When I scrape the website
    Then I get the following result:
      """
      { site_title: "Employee listing" }
      """

  Scenario: Scrape heading and tagline
    Given a website
    And the following Scraper:
      """
      heading css: '#site-header h1'
      tagline css: '#site-header p'
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
    site_header_role({ css: "#site-header" }, "role")
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
    employee_names css: "#employees li .name"
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
    employees css: "#employees li" do
      name css: ".name"
      department css: ".department"
      phone_number css: ".phone-number"
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