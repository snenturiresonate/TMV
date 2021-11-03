Feature: 34393 - Replay page Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  Background:
    * I am viewing the map HDGW01paddington.v

  @replayTest
  Scenario: 34393 - 11 Subsidiary Signal State (Proceed)
    # Replay Setup - 34081 - 5 Subsidiary Signal State (Proceed)
    * I set up all signals for address 29 in D4 to be not-proceed
    * the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D4             | 29      | 00   | 10:45:00  |
    * the maximum amount of time is allowed for end to end transmission
    * the signal roundel for signal 'SN271' is red
    * the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D4             | 29      | 08   | 10:45:00  |
    * the maximum amount of time is allowed for end to end transmission
    * the signal roundel for signal 'SN271' is white

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with a subsidiary signal
    # And the S-Class message is setting the subsidiary signal to proceed
    # When a user is viewing a map that contains the subsidiary signal
    # Then the subsidiary signal will display a proceed aspect (white roundel)
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the signal roundel for signal 'SN271' is white

  @replayTest
  Scenario: 34393 - 12 Shunt Signal State (Proceed)
    # Replay Setup - 34081 - 6 Shunt Signal State (Proceed)
    * I set up all signals for address 8F in D3 to be not-proceed
    * the shunt signal state for signal 'SN6142' is red
    * the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 8F      | 03   | 10:02:06  |
    * the maximum amount of time is allowed for end to end transmission
    * the shunt signal state for signal 'SN6142' is white

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with a shunt signal
    # And the S-Class message is setting the shunt signal to proceed
    # When a user is viewing a map that contains the shunt signal
    # Then the shunt signal will display a proceed aspect (white quadrant)
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the shunt signal state for signal 'SN6142' is white

  @replayTest
  Scenario: 34393 - 13 Shunt Signal State (Not Proceed)
    # Replay Setup - 34081 - 7 Shunt Signal State (Not Proceed)
    * I set up all signals for address 8F in D3 to be proceed
    * the shunt signal state for signal 'SN6142' is white
    * the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D3             | 8F      | 00   | 10:02:06  |
    * the maximum amount of time is allowed for end to end transmission
    * the shunt signal state for signal 'SN6142' is red

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with a shunt signal
    # And the S-Class message is setting the shunt signal to not proceed
    # When a user is viewing a map that contains the shunt signal
    # Then the shunt signal will display a not proceed aspect (red quadrant)
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the shunt signal state for signal 'SN6142' is red
