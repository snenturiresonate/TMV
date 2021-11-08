Feature: 46446 - Schematic State - Signals
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map HDGW01paddington.v

  @replaySetup
  Scenario: 34081-1 Current Signal State
      #Given the existing state of the signals
      #And at least one signal has a known state
      #When the user opens a new map that contains the signals
      #Then the signal state align with the underlying signal state model
    Given I set up all signals for address 80 in D3 to be not-proceed
    And the maximum amount of time is allowed for end to end transmission
    And the signal roundel for signal 'SN128' is red
    When I launch a new map 'HDGW01'
    And I switch to the new tab
    And I wait for the tracks to be displayed
    Then the signal roundel for signal 'SN128' is red
    When I refresh the browser
    And I wait for the tracks to be displayed
    Then the signal roundel for signal 'SN128' is red

  @replaySetup
  Scenario: 34081 - 2  Main Signal State Proceed
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

  Scenario:34081 - 3 Main Signal State (Not Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to not proceed
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display a not proceed aspect (red roundel)
    * this replay setup test has been moved to become part of the replay test: 34393-9 Main Signal State (Not Proceed)

  Scenario: 34081 - 4  Main Signal State (Unknown)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to unknown
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display an unknown aspect (grey roundel)
    Then the signal roundel for signal 'SN145' is grey

  Scenario:34081 - 5 Subsidiary Signal State (Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a subsidiary signal
    #And the S-Class message is setting the subsidiary signal to proceed
    #When a user is viewing a map that contains the subsidiary signal
    #Then the subsidiary signal will display a proceed aspect (white roundel)
    * this replay setup test has been moved to become part of the replay test: 34393 - 11 Subsidiary Signal State (Proceed)

  Scenario:34081 - 6 Shunt Signal State (Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a shunt signal
    #And the S-Class message is setting the shunt signal to proceed
    #When a user is viewing a map that contains the shunt signal
    #Then the shunt signal will display a proceed aspect (white quadrant)
    * this replay setup test has been moved to become part of the replay test: 34393 - 12 Shunt Signal State (Proceed)

  Scenario: 34081 - 7 Shunt Signal State (Not Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a shunt signal
    #And the S-Class message is setting the shunt signal to not proceed
    #When a user is viewing a map that contains the shunt signal
    #Then the shunt signal will display a not proceed aspect (red quadrant)
    * this replay setup test has been moved to become part of the replay test: 34393 - 13 Shunt Signal State (Not Proceed)
