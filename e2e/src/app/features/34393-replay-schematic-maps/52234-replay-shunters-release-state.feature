Feature: 34393 - Replay page Schematic Object State Scenarios - Active Shunters Release
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  Background:
    Given I am viewing the map GW5Abristolparkway.v

  @replayTest
  Scenario: 34393 - 23 Active Shunters Release State (Given)
    # Replay Setup - 34081-15 - Active Shunters Release State (Given)
    * I set up all signals for address 53 in D0 to be not-proceed
    * the cross indication for shunters-release 'BL7023' is not visible
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D0             | 53      | 02   |
    * the shunters-release 'BL7023' will display a given state [a white cross in the white box]

    # Given an S-Class message is received and processed
    # And the S-Class message is an update to Latch
    # And the Latch is associated with a Shunters release
    # And the Shunters release is given
    # When a user is viewing a map that contains the Shunters Release
    # Then the Shunters Release will display a given state (white cross in the white box)
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW5Abristolparkway.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the shunters-release 'BL7023' will display a given state [a white cross in the white box]

  Scenario: 34393 - 24 Active Shunters Release State (Not Given)
    # Replay Setup - 34081-16 - Active Shunters Release State (Not Given)
    * I set up all signals for address 53 in D0 to be proceed
    * the cross indication for shunters-release 'BL7023' is visible
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | D0             | 53      | 02   |
    * the shunters-release 'BL7023' will display a not-given state [no white cross in the white box]

    # Given an S-Class message is received and processed
    # And the S-Class message is an update to Latch
    # And the Latch is associated with a Shunters release
    # And the Shunters release is not given
    # When a user is viewing a map that contains the Shunters Release
    # Then the Shunters Release will display a not given state (removal of the white cross in the white box)
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW5Abristolparkway.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the shunters-release 'BL7023' will display a not-given state [no white cross in the white box]
