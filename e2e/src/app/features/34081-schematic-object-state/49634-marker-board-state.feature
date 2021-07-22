Feature: 49634 - Schematic State - marker-board state
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    * I reset redis
    Given I am viewing the map gw15cambrian.v

  @replaySetup
  Scenario: 34081-8 - Marker Board State (Movement Authority Given)
    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a marker board
    #    And the S-Class message is setting the marker board to Movement Authority given
    #    When a user is viewing a map that contains the marker board
    #    Then the marker board will display a Movement Authority given (green triangle on blue background)
    And I set up all signals for address 31 in MH to be not-proceed
    And the marker board triangle for marker board 'MH1201' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | MH             | 31      | 02   | 10:45:00  |
    Then the marker board 'MH1201' will display a Movement Authority given [green triangle on blue background]

  @replaySetup
  Scenario: 34081-9 - Marker Board State (Movement Authority Not Given)
    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a marker board
    #    And the S-Class message is setting the marker board to Movement Authority not given
    #    When a user is viewing a map that contains the marker board
    #    Then the marker board will display a Movement Authority not given (red triangle on blue background)
    And I set up all signals for address 31 in MH to be proceed
    And the marker board triangle for marker board 'MH1201' is green
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | MH             | 31      | FC   | 10:45:00  |
    Then the marker board 'MH1201' will display a Movement Authority not-given [red triangle on blue background]

  @replaySetup
  Scenario: 34081-10 - Marker Board State (Movement Authority Unknown)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with a marker board
#    And the S-Class message is setting the marker board to Movement Authority unknown
#    When a user is viewing a map that contains the marker board
#    Then the marker board will display a Movement Authority unknown (grey triangle on blue background)
    Then the marker board 'MH1201' will display a Movement Authority unknown [grey triangle on blue background]

  @replaySetup
  Scenario: 34081-12 - Shunt Marker Board State (Movement Authority Given)
    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a shunt marker board
    #    And the S-Class message is setting the shunt marker board to Movement Authority given
    #    When a user is viewing a map that contains the shunt marker board
    #    Then the shunt marker board will display a Movement Authority given (white triangle with blue inner triangle)
    And I set up all signals for address 31 in MH to be not-proceed
    And the shunt marker board triangle for shunt marker board 'MH1199' is red
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | MH             | 31      | 01   | 10:45:00  |
    Then the shunt marker board 'MH1199' will display a Movement Authority given [white triangle with blue inner triangle]

  @replaySetup
  Scenario: 34081-13 - Shunt Marker Board State (Movement Authority Not Given)
    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a shunt marker board
    #    And the S-Class message is setting the shunt marker board to Movement Authority not given
    #    When a user is viewing a map that contains the shunt marker board
    #    Then the shunt marker board will display a Movement Authority not given (red triangle with blue inner triangle)
    And I set up all signals for address 31 in MH to be proceed
    And the shunt marker board triangle for shunt marker board 'MH1199' is white
    When the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | MH             | 31      | FE   | 10:45:00  |
    Then the shunt marker board 'MH1199' will display a Movement Authority not-given [red triangle with blue inner triangle]

  @replaySetup
  Scenario: 34081-14 - Shunt Marker Board State (Movement Authority Unknown)
    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a shunt marker board
    #    And the S-Class message is setting the shunt marker board to Movement Authority unknown
    #    When a user is viewing a map that contains the shunt marker board
    #    Then the shunt marker board will display a Movement Authority unknown (grey triangle with blue inner triangle)
    Then the shunt marker board 'MH1199' will display a Movement Authority unknown [grey triangle with blue inner triangle]
