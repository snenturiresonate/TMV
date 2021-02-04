@bug @bug_54829
Feature: 49635 - Schematic State - node proved state
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map gw15cambrian.v

  @replaySetup
  Scenario: 34081-15 - Node Proven State (Given)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Node Proved
#    And the S-Class message is setting the shunt marker board to Node Proven given
#    When a user is viewing a map that contains the shunt marker board
#    Then the shunt marker board will display a Node Proven given (green cross next to the shunt marker board)
    And I set up all signals for address 14 in MH to be not-proceed
    And there is no text indication for shunt-marker-board 'MH000C'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | MH             | 14      | 01   | 10:45:00  |
    Then the shunt-marker-board 'MH000C' will display a Node Proven given [a green cross next to the shunt marker board]

  @replaySetup
  Scenario: 34081-16 - Node Proven State (Not Given)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Node Proved
#    And the S-Class message is setting the shunt marker board to Node Proven not given
#    When a user is viewing a map that contains the shunt marker board
#    Then the shunt marker board will not display a Node Proven given (removal of the green cross next to the shunt marker board)
    And I set up all signals for address 14 in MH to be proceed
    And there is a text indication for shunt-marker-board 'MH000C'
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | MH             | 14      | 00   | 10:45:00  |
    Then the shunt-marker-board 'MH000C' will display a Node Proven not-given [no green cross next to the shunt marker board]
