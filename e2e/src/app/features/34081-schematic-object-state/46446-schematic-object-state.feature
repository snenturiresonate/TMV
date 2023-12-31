Feature: 46446 - Schematic State - Signals
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map hdgw01paddington.v

  @tdd @replaySetup
  Scenario: 34081-1 Current Signal State
      #Given the existing state of the signals
      #And at least one signal has a known state
      #When the user opens a new map that contains the signals
      #Then the signal state align with the underlying signal state model
    Given I set up all signals for address 80 in D3 to be red
    And the maximum amount of time is allowed for end to end transmission
    And the signal roundel for signal 'SN208' is red
    When I launch a new map 'HDGW02' the new map should have start time from the moment it was opened
    And I switch to the new tab
    Then the signal roundel for signal 'SN200' is red
    And I refresh the browser
    And the signal roundel for signal 'SN200' is red

  @replaySetup
  Scenario:34081 - 2  Main Signal State Proceed
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to proceed
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display a proceed aspect (green roundel)
    And I set up all signals for address 80 in D3 to be not-proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN128' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | FF   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN128' is green

    @replaySetup
  Scenario:34081 - 3 Main Signal State (Not Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to not proceed
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display a not proceed aspect (red roundel)
    And I set up all signals for address 80 in D3 to be proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | FF   | 10:45:00  |
    Then the signal roundel for signal 'SN128' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN128' is red

  @bug @bug_51929
  Scenario: 34081 - 4  Main Signal State (Unknown)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to unknown
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display an unknown aspect (grey roundel)
    Then the signal roundel for signal 'SN128' is grey


  @replaySetup
  Scenario:34081 - 5 Subsidiary Signal State (Proceed)

    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a subsidiary signal
    #And the S-Class message is setting the subsidiary signal to proceed
    #When a user is viewing a map that contains the subsidiary signal
    #Then the subsidiary signal will display a proceed aspect (white roundel)
    And I set up all signals for address 29 in D4 to be not-proceed
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D4             | 29      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN271' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D4             | 29      | 08   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN271' is white

  @replaySetup
  Scenario:34081 - 6 Shunt Signal State (Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a shunt signal
    #And the S-Class message is setting the shunt signal to proceed
    #When a user is viewing a map that contains the shunt signal
    #Then the shunt signal will display a proceed aspect (white quadrant)
    When I set up all signals for address 8F in D3 to be not-proceed
    And the shunt signal state for signal 'SN6142' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 8F      | 03   | 10:02:06  |
    And the maximum amount of time is allowed for end to end transmission
    Then the shunt signal state for signal 'SN6142' is white

  @replaySetup
  Scenario: 34081 - 7 Shunt Signal State (Not Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a shunt signal
    #And the S-Class message is setting the shunt signal to not proceed
    #When a user is viewing a map that contains the shunt signal
    #Then the shunt signal will display a not proceed aspect (red quadrant)
    When I set up all signals for address 8F in D3 to be proceed
    And the shunt signal state for signal 'SN6142' is white
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 8F      | 00   | 10:02:06  |
    And the maximum amount of time is allowed for end to end transmission
    Then the shunt signal state for signal 'SN6142' is red
