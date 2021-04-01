@bug @bug_56581
Feature: 34393 - Replay page Schematic Object State Scenarios - Node Proved
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @tdd @replayTest
  Scenario: 34393 - 21 Node Proven State (Given)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Node Proved
#    And the S-Class message is setting the shunt marker board to Node Proven given
#    When a user is viewing a map that contains the shunt marker board
    Given I load the replay data from scenario '34081-15 - Node Proven State (Given)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the shunt-marker-board 'MH000C' will display a Node Proven given [a green cross next to the shunt marker board]

  @tdd @replayTest
  Scenario: 34393 - 22 Node Proven State (Not Given)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Node Proved
#    And the S-Class message is setting the shunt marker board to Node Proven not given
#    When a user is viewing a map that contains the shunt marker board
#    Then the shunt marker board will not display a Node Proven given (removal of the green cross next to the shunt marker board)
    Given I load the replay data from scenario '34081-16 - Node Proven State (Not Given)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the shunt-marker-board 'MH000C' will display a Node Proven not-given [no green cross next to the shunt marker board]
