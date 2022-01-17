@TMVPhase2 @P2.S2
Feature: 79015 - TMV National Search Additions - National Berth Search Response time
  As a TMV User
  I want the berth search results list to be displayed with zero or many results within 1 second

  Background:
    * I remove all trains from the trains list

  Scenario Outline:79192-1 - National Berth Search response time
    #Given the user is authenticated to use TMV
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a berth search option
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #Then the berth search results list is displayed with zero or many results within 1 second
    #
    # Comments:
    # * Invalid characters are not allowed - error message displayed
    # * At least 2 characters - error message displayed
    # * No upper limit, but check if the system behaves gracefully with a large number
    Given I navigate to <pageName> page
    When I start the stopwatch
    And I search Berth for '6207'
    Then results are returned with text 'D4'
    When I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | pageName         |
      | Home             |

  Scenario Outline: 79192-2 - invalid characters are rejected - <searchFor>
    Given I navigate to Home page
    When I start the stopwatch
    And I search Berth for '<searchFor>'
    Then a warning message is displayed for invalid characters
    When I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | map                | searchFor |
      | HDGW01paddington.v | ££££      |
      | GW22heartofwales.v | 00 9      |
      | NW22mpsccsig.v     | %!@*      |
      | MD01euston.v       | 00*9      |

  Scenario Outline: 79192-3 - National Berth at least two characters are required - <searchFor>
    Given I navigate to Home page
    When I start the stopwatch
    And I search Berth for '<searchFor>'
    Then Warning Message is displayed for minimum characters
    When I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | map                | searchFor |
      | HDGW01paddington.v | 0         |
      | GW22heartofwales.v | 9         |
      | NW22mpsccsig.v     | a         |
      | MD01euston.v       | Z         |

  Scenario Outline: 79192-4 - National Berth large search string is accepted
    Given I navigate to Home page
    When I start the stopwatch
    And I search Berth for '<searchFor>'
    Then a message is displayed stating that no results were found
    When I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | map                | searchFor                                                                                        |
      | HDGW01paddington.v | 0099A001NJUNSWSG0099A001NJUNSWSG0099A001NJUNSWSG0099A001NJUNSWSG0099A001NJUNSWSG0099A001NJUNSWSG |
