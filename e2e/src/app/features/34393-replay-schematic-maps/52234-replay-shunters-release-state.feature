@bug @bug_56581
Feature: 34393 - Replay page Schematic Object State Scenarios - Active Shunters Release
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @tdd @replayTest
  Scenario: 34393 - 23 Active Shunters Release State (Given)
#    Given an S-Class message is received and processed
#    And the S-Class message is an update to Latch
#    And the Latch is associated with a Shunters release
#    And the Shunters release is given
#    When a user is viewing a map that contains the Shunters Release
#    Then the Shunters Release will display a given state (white cross in the white box)
    Given I load the replay data from scenario '34081-15 - Active Shunters Release State (Given)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw5abristolparkway.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the shunters-release 'BL7023' will display a given state [a white cross in the white box]

  @tdd @replayTest
  Scenario: 34393 - 24 Active Shunters Release State (Not Given)
#    Given an S-Class message is received and processed
#    And the S-Class message is an update to Latch
#    And the Latch is associated with a Shunters release
#    And the Shunters release is not given
#    When a user is viewing a map that contains the Shunters Release
#    Then the Shunters Release will display a not given state (removal of the white cross in the white box)
    Given I load the replay data from scenario '34081-16 - Active Shunters Release State (Not Given)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw5abristolparkway.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the shunters-release 'BL7023' will display a not-given state [no white cross in the white box]
