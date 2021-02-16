Feature: 33763 - TMV Replay Playback Controls
  As a TMV User
  I want the replay to have a rich set of controls
  So that I can manipulate the replay playback

  Scenario: Replay - Open Replay
    Given I am on the home page
    When I select the replay button from the home page
    And I switch to the new tab
    Then the replay map selection is presented

  Scenario: Replay - Search Map
    Given I am on the replay page
    When I search for replay map 'Paddington'
    Then all replay map search results contain 'Paddington'

  Scenario: Replay - Map Tree
    Given I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    Then replay map 'HDGW01 Paddington' is present in the tree view

    @newSession
  Scenario: Replay - Time Range
    Given I am on the replay page as existing user
    And I expand the replay group of maps with name 'Wales & Western'
    When I select the map 'hdgw01paddington.v'
    Then the replay time selection is presented

  @tdd
  Scenario: Replay - Time Rang/ Selection (Quick Select)
    # system date is fixed to 08/02/2020
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    When I select time period 'Last 15 minutes' from the quick dropdown
    And I select Start
    Then the map view is opened ready for replaying
      | mapName    | expectedTimestamp |
      | Paddington | Last 15 minutes   |

    @newSession
  Scenario: Replay - Time Range Selection (Manual Input)
    Given I am on the replay page as existing user
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    When I set the date and time for replay to
      | date       | time     | duration |
      | 01/01/2020 | 12:00:00 | 10       |
    And I select Start
    Then the map view is opened ready for replaying
      | mapName    | expectedTimestamp   |
      | Paddington | 01/01/2020 12:00:00 |

      @newSession
  Scenario: Replay - Time Range Selection (Dropdowns)
    Given I am on the replay page as existing user
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    When I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    Then the map view is opened ready for replaying
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |



