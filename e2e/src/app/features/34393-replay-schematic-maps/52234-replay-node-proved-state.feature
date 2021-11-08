Feature: 34393 - Replay page Schematic Object State Scenarios - Node Proved
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  Background:
    * I am viewing the map GW15cambrian.v

  Scenario: 34393 - 21 Node Proven State (Given)
    # Replay Setup - 34081-15 - Node Proven State (Given)
    * I set up all signals for address 14 in MH to be not-proceed
    * there is no text indication for shunt-marker-board 'MH000C'
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | MH             | 14      | 01   |
    * the shunt-marker-board 'MH000C' will display a Node Proven given [a green cross next to the shunt marker board]

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with an S-Class berth of type Node Proved
    # And the S-Class message is setting the shunt marker board to Node Proven given
    # When a user is viewing a map that contains the shunt marker board
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the shunt-marker-board 'MH000C' will display a Node Proven given [a green cross next to the shunt marker board]

  Scenario: 34393 - 22 Node Proven State (Not Given)
    # Replay Setup - 34081-16 - Node Proven State (Not Given)
    * I set up all signals for address 14 in MH to be proceed
    * there is a text indication for shunt-marker-board 'MH000C'
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | MH             | 14      | 00   |
    * the shunt-marker-board 'MH000C' will display a Node Proven not-given [no green cross next to the shunt marker board]

    # Given an S-Class message is received and processed
    # And the S-Class message is associated with an S-Class berth of type Node Proved
    # And the S-Class message is setting the shunt marker board to Node Proven not given
    # When a user is viewing a map that contains the shunt marker board
    # Then the shunt marker board will not display a Node Proven given (removal of the green cross next to the shunt marker board)
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the shunt-marker-board 'MH000C' will display a Node Proven not-given [no green cross next to the shunt marker board]
