Feature: 40680 - Basic UI - Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am on the home page
    And I expand the group of maps with name 'Wales & Western'
    And I navigate to the maps view with id hdgw01paddington.v
    And I switch to the new tab

  Scenario: 34081-1 Current Signal State
    #Given the existing state of the signals
    #And at least one signal has a known state
    #When the user opens a new map that contains the signals
    #Then the signal state align with the underlying signal state model
    Then the signal roundel for signal 'SN128' is grey
    And the shunt signal state for signal 'SN6142' is grey
    And I refresh the browser
    Then the signal roundel for signal 'SN128' is grey
    And the shunt signal state for signal 'SN6142' is grey

  Scenario:34081 - 2  Main Signal State (Proceed
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to proceed
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display a proceed aspect (green roundel)
    And I set up all signals for address 80 in D3 to be red
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
    And I set up all signals for address 80 in D3 to be green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | FF   | 10:45:00  |
    Then the signal roundel for signal 'SN128' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 80      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN128' is red

  Scenario: 34081 - 4  Main Signal State (Unknown)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a main signal
    #And the S-Class message is setting the main signal to unknown
    #When a user is viewing a map that contains the main signal
    #Then the main signal will display an unknown aspect (grey roundel)
    Then the signal roundel for signal 'SN128' is grey


  Scenario:34081 - 5 Subsidiary Signal State (Proceed)

    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a subsidiary signal
    #And the S-Class message is setting the subsidiary signal to proceed
    #When a user is viewing a map that contains the subsidiary signal
    #Then the subsidiary signal will display a proceed aspect (white roundel)
    And I set up all signals for address 80 in D3 to be red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 00   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | FF   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 92      | 08   | 10:45:00  |
    And the maximum amount of time is allowed for end to end transmission
    Then the signal roundel for signal 'SN212' is white

  Scenario:34081 - 6 Shunt Signal State (Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a shunt signal
    #And the S-Class message is setting the shunt signal to proceed
    #When a user is viewing a map that contains the shunt signal
    #Then the shunt signal will display a proceed aspect (green quadrant)
    And the shunt signal state for signal 'SN6142' is grey
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 8F      | 03   | 10:02:06  |
    And the maximum amount of time is allowed for end to end transmission
    Then the shunt signal state for signal 'SN6142' is green

  Scenario: 34081 - 7 Shunt Signal State (Not Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a shunt signal
    #And the S-Class message is setting the shunt signal to not proceed
    #When a user is viewing a map that contains the shunt signal
    #Then the shunt signal will display a not proceed aspect (red quadrant)
    And the shunt signal state for signal 'SN6142' is grey
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 8F      | 00   | 10:02:06  |
    And the maximum amount of time is allowed for end to end transmission
    Then the shunt signal state for signal 'SN6142' is red
