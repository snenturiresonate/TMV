Feature: 79015 - TMV National Search Additions - National Berth Search
  As a TMV User
  I want the ability to search for a berth
  So that I can open a map that is of interest

  #  Given the user is authenticated to use TMV
  #  And the user is viewing TMV screen with a national search in the title bar
  #  When the user selects a berth search option
  #  And the user enters at least two alphanumeric characters
  #  And the user submits the search
  #  Then the berth search results list is displayed with zero or many results
  #
  #  Notes:
  #    Invalid characters are not allowed - error message displayed
  #    At least 2 characters required - error message displayed
  #    No upper limit, but check if the system behaves gracefully with a large number
  #    No results found message is displayed for zero results
  #    Alphanumeric characters only

  Scenario Outline: 79189-1 - less than 2 search characters are rejected - <searchFor>
    Given I am viewing the map <map>
    When I search Berth for '<searchFor>'
    Then Warning Message is displayed for minimum characters

    Examples:
    | map                | searchFor |
    | HDGW01paddington.v | 0         |
    | GW22heartofwales.v | 9         |
    | NW22mpsccsig.v     | a         |
    | MD01euston.v       | Z         |

  Scenario Outline: 79189-2 - invalid characters are rejected - <searchFor>
    Given I am viewing the map <map>
    When I search Berth for '<searchFor>'
    Then a warning message is displayed for invalid characters

    Examples:
      | map                | searchFor |
      | HDGW01paddington.v | ££££      |
      | GW22heartofwales.v | 00 9      |
      | NW22mpsccsig.v     | %!@*      |
      | MD01euston.v       | 00*9      |

  Scenario Outline: 79189-3 - 2 search characters are accepted - <searchFor>
    Given I am viewing the map <map>
    When I search Berth for '<searchFor>'
    Then the berth search results table is displayed

    Examples:
      | map                | searchFor |
      | HDGW01paddington.v | 00        |
      | GW22heartofwales.v | A0        |
      | NW22mpsccsig.v     | NJ        |
      | MD01euston.v       | SW        |

  Scenario Outline: 79189-4 - full berth name is accepted - <searchFor> - <expectedCount>
    Given I am viewing the map <map>
    When I search Berth for '<searchFor>'
    Then the berth search results table displays <expectedCount> results

    Examples:
      | map                | searchFor | expectedCount |
      # Searched for "berthName":"0099" within the 'configuraiton-berths' config and got 14 hits
      | HDGW01paddington.v | 0099      | 14            |
      # Searched for "berthName":"A001" within the 'configuraiton-berths' config and got 6 hits
      | GW22heartofwales.v | A001      | 6             |
      # Searched for "berthName":"NJUN" within the 'configuraiton-berths' config and got 1 hit
      | NW22mpsccsig.v     | NJUN      | 1             |
      # Searched for "berthName":"SWSG" within the 'configuraiton-berths' config and got 1 hit
      | MD01euston.v       | SWSG      | 1             |

  Scenario Outline: 79189-5 - no search results found - <searchFor>
    Given I am viewing the map <map>
    When I search Berth for '<searchFor>'
    Then a message is displayed stating that no results were found

    Examples:
      | map                | searchFor |
      | HDGW01paddington.v | NOTHING   |
      | GW22heartofwales.v | A0019999  |
      | NW22mpsccsig.v     | NADA      |
      | MD01euston.v       | ZZ99      |

  Scenario Outline: 79189-6 - large search string
    Given I am viewing the map <map>
    When I search Berth for '<searchFor>'
    Then a message is displayed stating that no results were found

    Examples:
      | map                | searchFor                                                                                        |
      | HDGW01paddington.v | 0099A001NJUNSWSG0099A001NJUNSWSG0099A001NJUNSWSG0099A001NJUNSWSG0099A001NJUNSWSG0099A001NJUNSWSG |

