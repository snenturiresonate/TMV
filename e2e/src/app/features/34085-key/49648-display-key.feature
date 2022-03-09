Feature: 46482 - TMV Key - display key
  As a TMV User
  I want to view a symbol key
  So that I can understand what the schematic objects mean

  Background:
    Given I have not already authenticated
    And I am viewing the map HDGW01paddington.v
    And The admin setting defaults are as originally shipped
    And I refresh the browser

  Scenario: 34085-2a The TMV Key punctuality table is displayed within the modal when the tmv icon is clicked
    When I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    And The key punctuality table contains the following data
      | position | text                     | backgroundColour | colour  |
      | 0        | 20 minutes or more early | #ffb4b4          | #000000 |
      | 1        | 10 to 19 minutes early   | #e5b4ff          | #000000 |
      | 2        | 5 to 9 minutes early     | #78e7ff          | #000000 |
      | 3        | 1 to 4 minutes early     | #78ff78          | #000000 |
      | 4        | On Time                  | #00ff00          | #000000 |
      | 5        | 1 to 4 minutes late      | #ffff00          | #000000 |
      | 6        | 5 to 9 minutes late      | #ffa700          | #000000 |
      | 7        | 10 to 19 minutes late    | #ff0000          | #ffffff |
      | 8        | 20 minutes or more late  | #ff009c          | #ffffff |

  Scenario: 34085-2b The TMV Key berth table is displayed within the modal when the tmv icon is clicked
    When I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    And The key berth table contains the following data
      | position | text                     | backgroundColour | colour  |
      | 0        | Off Plan                 | #0000ff          | #ffffff |
      | 1        | Left Behind              | #969696          | #000000 |
      | 2        | No Timetable             | #e1e1e1          | #000000 |
      | 3        | Last Berth               | #ffffff          | #000000 |
      | 4        | Unknown Delay            | #ffffff          | #000000 |

  @TMVPhase2 @P2.S4 @bdd:87141
  Scenario: 34085-3 The TMV Key Symbol table is displayed when the Symbol tab is clicked
    When I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    And I switch to the 'Symbol' key tab
    Then the active tab is 'Symbol'
    And the key table has columns
      | colName           |
      | Lineside Features |
      | Line Status       |
    And the Lineside Features list contains the following data
      | position | feature              |
      | 0        | HABD                 |
      | 1        | OHNS                 |
      | 2        | WILD                 |
      | 3        | Block Section Marker |
    And the Line Status list contains the following data
      | position | status                               |
      | 0        | BLOK (Line Blockage)                 |
      | 1        | OOU (Out of Use)                     |
      | 2        | POSS (Possession)                    |
      | 3        | ESR (Emergency Speed Restriction)    |
      | 4        | TSR (Temporary Speed Restriction)    |
      | 5        | BTET (Blocked to Electric Traction)  |
      | 6        | CAU (Cautioning of Trains)           |
      | 7        | Multiple Restrictions Apply          |

  Scenario: 34085-4 The TMV Key train describer table is displayed when the Train Describer tab is clicked
    When I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    And I switch to the 'Train Describer' key tab
    Then the active tab is 'Train Describer'
    And the key table has columns
      | colName |
      | ID      |
      | Name    |
    And the TD list contains the following data
      | position | name                    |
      | 1        | D4 TVSC Hayes IECC      |
      | 2        | D6 TVSC Maidenhead IECC |
      | 3        | D3 TVSC Paddington IECC |
