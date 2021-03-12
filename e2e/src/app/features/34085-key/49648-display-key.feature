Feature: 46482 - TMV Key - display key
  As a TMV User
  I want to view a symbol key
  So that I can understand what the schematic objects mean

  Background:
    Given The admin setting defaults are as originally shipped
    And I am viewing the map GW01paddington.v

    @bug @bug_57070
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
      | 4        | Right Time               | #00ff00          | #000000 |
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
      | 0        | Attention                | #2b78e4          | #ffffff |
      | 1        | Unknown Delay            | #ffffff          | #000000 |
      | 2        | No Timetable             | #dddddd          | #000000 |
      | 3        | Left Behind              | #999999          | #000000 |
      | 4        | Last Berth               | #f9cb9c          | #000000 |

  @tdd @tdd_54867
  Scenario: 34085-3 The TMV Key Symbol table is displayed when the Symbol tab is clicked
    When I click on the Help icon
    And I select the TMV Key option
    Then a modal displays with title 'Key'
    And I switch to the 'Symbol' key tab
    Then the active tab is 'Symbol'
    And the key table has columns
      | colName                |
      | Lineside Features      |
      | Line Status            |
    And the Lineside Features list contains the following data
      | position | feature              |
      | 0        | HABD                 |
      | 1        | OHNS                 |
      | 2        | WILD                 |
      | 3        | Block Section Marker |
    And the Line Status list contains the following data
      | position | status     |
      | 0        | Blockage   |
      | 1        | Not in use |
      | 2        | ESR        |
      | 3        | TSR        |
      | 4        | Possession |

  @tdd @tdd_54867
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
      | position | name                   |
      | 1        | WY Wembley             |
      | 2        | WS Willesden           |
      | 3        | WH West Hampstead      |
      | 4        | KX Kings Cross         |
      | 5        | PB Peterborough        |
      | 6        | AS Ashford             |
      | 7        | TB Three Bridges       |
      | 8        | SX Saxmundham          |
      | 9        | TB Three Bridges       |
      | 10       | TB Three Bridges       |
      | 11       | LB London Bridge       |
      | 12       | AW Acton Wells         |
      | 13       | NX New Cross           |
      | 14       | CC Colchester TD       |
      | 15       | SO South Tottenham TD  |
      | 16       | CT Channel Tunnel      |
      | 17       | CA Cambridge           |
