@bug @bug_56581
Feature: 33763 - TMV Replay Playback Controls
  As a TMV User
  I want the replay to have a rich set of controls
  So that I can manipulate the replay playback

  @newSession @bug @bug_55794
  Scenario: Replay - Time Range
    Given I am on the home page
    When I select the replay button from the home page
    And I switch to the new tab
    Then the replay time selection is presented

  @tdd
  Scenario: Replay - Time Range / Selection (Quick Select)
    # system date is fixed to 08/02/2020
    Given I am on the replay page as existing user
    When I select time period 'Last 15 minutes' from the quick dropdown
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp |
      | Paddington | Last 15 minutes   |

  @newSession @bug @bug_55794
  Scenario: Replay - Time Range Selection (Manual Input)
    Given I am on the replay page as existing user
    When I set the date and time for replay to
      | date       | time     | duration |
      | 01/01/2020 | 12:00:00 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/01/2020 12:00:00 |

  @newSession @bug @bug_55794
  Scenario: Replay - Time Range Selection (Dropdowns)
    Given I am on the replay page as existing user
    When I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |

  Scenario: Replay - Open Replay
    Given I am on the home page
    When I select the replay button from the home page
    And I switch to the new tab
    And I set time period 'Last 15 minutes' from the quick dropdown
    Then the replay map selection is presented

  Scenario: Replay - Search Map
    Given I am on the replay page as existing user
    And I set time period 'Last 15 minutes' from the quick dropdown
    When I search for replay map 'Paddington'
    Then all replay map search results contain 'Paddington'

  Scenario: Replay - Map Tree
    Given I am on the replay page as existing user
    And I set time period 'Last 15 minutes' from the quick dropdown
    When I expand the replay group of maps with name 'Wales & Western'
    Then replay map 'HDGW01 Paddington' is present in the tree view


  @newSession @bug @bug_55794
  Scenario: 33763-6 Replay - Play
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #When the user presses play
    #Then the stepping and signalling objects are replayed at normal speed
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I wait for the buffer to fill
    Then the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |

  @newSession @bug @bug_55794
  Scenario: 33763-7 Replay - Speed
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And has started the replay
    #When the user changes the speed
    #Then the stepping and signalling objects are replayed at the new speed
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And I click Play button
    And I wait for the buffer to fill
    And the replay playback speed is 'Normal'
    When I increase the replay speed at position 5
    Then the replay playback speed is 'x 5'
    And I increase the replay speed at position 6
    And the replay playback speed is 'x 10'
    And I increase the replay speed at position 7
    And the replay playback speed is 'x 15'

  @newSession @bug @bug_55794
  Scenario: 33763-8a Replay - Play and Skip forward
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And has started the replay
    #When the user skips forward
    #Then the replay is skipped forward a minute increment
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I wait for the buffer to fill
    Then the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    Then my replay should skip '1' minute when I click forward button

  @newSession @bug @bug_55794
  Scenario: 33763-8b Replay - Pause and Skip forward
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I wait for the buffer to fill
    And I click Pause button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    Then my replay should skip '1' minute when I click forward button

  @newSession @bug @bug_55794
  Scenario: 33763-8c Replay - Stop and Skip forward
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I wait for the buffer to fill
    And I click Stop button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    Then my replay should skip '1' minute when I click forward button

  @newSession @bug @bug_55794
  Scenario: 33763-8d Replay - Skip forward to end the replay session
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 5       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I wait for the buffer to fill
    And my replay should skip '1' minute when I click forward button
    And my replay should skip '1' minute when I click forward button
    And my replay should skip '1' minute when I click forward button
    And my replay should skip '1' minute when I click forward button
    And my replay should skip '1' minute when I click forward button
    And the replay button 'forward' is 'disabled'

  @newSession @bug @bug_55794
  Scenario: 33763-9a Replay - Play and Skip backward
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And has started the replay
    #When the user skips backward
    #Then the replay is skipped backward a minute increment
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 5       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I wait for the buffer to fill
    And the replay playback speed is 'Normal'
    And I move the replay forward until time '12:53:03'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:53:03 |
    Then my replay should skip '1' minute when I click backward button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:52:03 |

  @newSession @bug @bug_55794
  Scenario: 33763-9b Replay - Pause and Skip backward
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 5       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    When I click Play button
    And I wait for the buffer to fill
    And I move the replay forward until time '12:53:03'
    And I click Pause button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:53:03 |
    Then my replay should skip '1' minute when I click backward button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:52:03 |

  @newSession @bug @bug_55794
  Scenario: 33763-9c Replay - Stop and Skip backward
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I wait for the buffer to fill
    And I move the replay forward until time '12:53:03'
    And I click Stop button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:53:03 |
    Then my replay should skip '1' minute when I click backward button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:52:03 |
    And my replay should skip '1' minute when I click backward button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:51:03 |
    Then my replay should skip '1' minute when I click backward button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:50:03 |
  @newSession @bug @bug_55794
  Scenario: 33763-10 a Replay - Stop (Play and Stop)
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And has started the replay
    #When the user stops the replay
    #Then the replay is stopped and taken to the beginning
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And I click Play button
    And I wait for the buffer to fill
    And the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    When I click Stop button
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And the replay button 'backward' is 'disabled'

  @newSession @bug @bug_55794
  Scenario: 33763-10 b Replay - Stop (Pause and stop)
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And I click Play button
    And I wait for the buffer to fill
    And I click Pause button
    And the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    When I click Stop button
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And the replay button 'backward' is 'disabled'

  @newSession @bug @bug_55794
  Scenario: 33763-11 Replay - Pause with Skip forward and Skip backward
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And has started the replay
    #When the user pauses the replay forward
    #Then the replay is paused
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 5       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    When I click Play button
    And I wait for the buffer to fill
    And I move the replay forward until time '12:53:03'
    And I click Play button
    And I click Pause button
    Then the replay is paused
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:53:03 |
    And my replay should skip '1' minute when I click backward button
    And I click Play button
    And I click Pause button
    And the replay is paused
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:52:03 |


  @newSession @bug @bug_55794
  Scenario: 33763-13 Replay - Replay the Replay
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And the replay has reached the end
    #When the user uses the replay
    #Then the replay is started again from the beginning
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 5       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I click Play button
    And I wait for the buffer to fill
    And I move the replay forward until time '12:54:03'
    When I click replay button
    Then the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And the replay button 'play' is 'enabled'

  @newSession @bug @bug_55794
  Scenario: 33763-14a Replay - Minimise control Play and forward button
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And the user is viewing the replay map
    #When the user uses the minimise control icon
    #Then the controls are minimised
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click minimise button
    Then the replay play back control is 'collapsed'
    And I click Play button
    And I wait for the buffer to fill
    And the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    And my replay should skip '1' minute when I click forward button

  @newSession @bug @bug_55794
  Scenario: 33763-14b Replay - Minimise control Stop and Skip backward
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    When I click Play button
    And I wait for the buffer to fill
    And I move the replay forward until time '12:53:03'
    And I click minimise button
    Then the replay play back control is 'collapsed'
    And I click Stop button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:53:03 |
    And my replay should skip '1' minute when I click backward button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:52:03 |
    And my replay should skip '1' minute when I click backward button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:51:03 |
    And my replay should skip '1' minute when I click backward button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:50:03 |

  @newSession @bug @bug_55794
  Scenario:33763-14c Replay - Minimise control Replay - Multiple Map Synchronisation with Pause
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And I click Play button
    And I wait for the buffer to fill
    When I click minimise button
    Then the replay play back control is 'collapsed'
    And I click Pause button
    And the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    And I launch a new map 'HDGW02' the new map should have start time from the moment it was opened
    And I switch to the new tab
    And the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    And I click Stop button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And the replay button 'backward' is 'disabled'
    And I switch back to the home page tab
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And the replay button 'backward' is 'disabled'

  @newSession @bug @bug_55794
  Scenario:33763-14d Replay - Minimise control and Replay icon
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 5       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I click Play button
    And I wait for the buffer to fill
    And I move the replay forward until time '12:54:03'
    When I click minimise button
    Then the replay play back control is 'collapsed'
    And I click replay button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And the replay button 'play' is 'enabled'

  @newSession @bug @bug_55794
  Scenario: 33763-15a Replay - Multiple Map Synchronisation (Play and Increase the speed two diff maps synch)
    #Given the user has selected a map to start the replay
    #And has selected a timeframe
    #And the user is viewing multiple maps from the same replay session
    #When the user uses the replay control
    #Then the replay playback is synchronised between all open maps
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And I click Play button
    And I wait for the buffer to fill
    And the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    When I launch a new map 'HDGW02' the new map should have start time from the moment it was opened
    And I switch to the new tab
    Then the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    And I increase the replay speed at position 5
    And the replay playback speed is 'x 5'
    And I switch back to the home page tab
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:50:04 |
    And the replay playback speed is 'x 5'

  @newSession @bug @bug_55794
  Scenario: 33763-15b Replay - Multiple Map Synchronisation (Skip forward and backward two diff maps synch)
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And I click Play button
    And I wait for the buffer to fill
    And the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    And my replay should skip '1' minute when I click forward button
    When I launch a new map 'HDGW02' the new map should have start time from the moment it was opened
    And I switch to the new tab
    Then the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:50:04 |
    And my replay should skip '1' minute when I click backward button
    And the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    And I switch back to the home page tab
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    And the replay playback speed is 'Normal'

  @newSession @bug @bug_55794
  Scenario: 33763-15c Replay - Multiple Map Synchronisation (Pause and stop two diff maps synch)
    Given I am on the replay page as existing user
    And I set the date and time using the dropdowns for replay to
      | date       | time     | duration |
      | 01/02/2020 | 12:49:03 | 10       |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And I click Play button
    And I wait for the buffer to fill
    And I click Pause button
    And the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    When I launch a new map 'HDGW02' the new map should have start time from the moment it was opened
    And I switch to the new tab
    Then the replay playback speed is 'Normal'
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:04 |
    And I click Stop button
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And the replay button 'backward' is 'disabled'
    And I switch back to the home page tab
    And the map view is opened ready for replaying with timestamp
      | mapName    | expectedTimestamp   |
      | Paddington | 01/02/2020 12:49:03 |
    And the replay button 'backward' is 'disabled'
