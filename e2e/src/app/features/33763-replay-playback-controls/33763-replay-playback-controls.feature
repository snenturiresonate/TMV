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

    @newSession @bug @bug_55794
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
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp |
      | Paddington | Last 15 minutes   |

    @newSession @bug @bug_55794
  Scenario: Replay - Time Range Selection (Manual Input)
    Given I am on the replay page as existing user
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    When I set the date and time for replay to
      | date       | time     | duration |
      | 01/01/2020 | 12:00:00 | 10       |
    And I select Start
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/01/2020 12:00:00 |

      @newSession @bug @bug_55794
  Scenario: Replay - Time Range Selection (Dropdowns)
    Given I am on the replay page as existing user
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    When I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |

  @newSession @bug @bug_55794
  Scenario: Scenario-6 Replay - Play
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #When the user presses play
    #Then the stepping and signalling objects are replayed at normal speed
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    Then the replay playback 'Speed' is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |

  @newSession @bug @bug_55794
  Scenario: Scenario8a Replay - Play and Skip forward
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And has started the replay
    #When the user skips forward
    #Then the replay is skipped forward a minute increment
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    Then the replay playback 'Speed' is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    Then my replay should skip '1' minute when I click forward button

  @newSession @bug @bug_55794
  Scenario: Scenario8b Replay - Pause and Skip forward
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I click Pause button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    Then my replay should skip '1' minute when I click forward button

  @newSession @bug @bug_55794
  Scenario: Scenario8c Replay - Stop and Skip forward
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I click Stop button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    Then my replay should skip '1' minute when I click forward button

  @newSession @bug @bug_55794
  Scenario: Scenario8d Replay - Skip forward to end the replay session
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 5       |
    And I select Start
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And my replay should skip '1' minute when I click forward button
    And my replay should skip '1' minute when I click forward button
    And my replay should skip '1' minute when I click forward button
    And my replay should skip '1' minute when I click forward button
    And my replay should skip '1' minute when I click forward button
    And the replay button 'forward' is 'disabled'

  @newSession @bug @bug_55794
  Scenario: Scenario9a Replay - Play and Skip backward
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And has started the replay
    #When the user skips backward
    #Then the replay is skipped backward a minute increment
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    Then the replay playback 'Speed' is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    Then my replay should skip '1' minute when I click backward button

  @newSession @bug @bug_55794
  Scenario: Scenario9b Replay - Pause and Skip backward
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I click Pause button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    Then my replay should skip '1' minute when I click backward button

  @newSession @bug @bug_55794
  Scenario: Scenario9c Replay - Stop and Skip forward
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I click Stop button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    Then my replay should skip '1' minute when I click backward button

  @newSession @bug @bug_55794
  Scenario: Scenario-10 a Replay - Stop (Play and Stop)
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And has started the replay
    #When the user stops the replay
    #Then the replay is stopped and taken to the beginning
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And I click Play button
    And the replay playback 'Speed' is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    When I click Stop button
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And the replay button 'backward' is 'disabled'

  @newSession @bug @bug_55794
  Scenario: Scenario-10 b Replay - Stop (Pause and stop)
    Given I am on the replay page
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Start
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And I click Play button
    And I click Pause button
    And the replay playback 'Speed' is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    When I click Stop button
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And the replay button 'backward' is 'disabled'
