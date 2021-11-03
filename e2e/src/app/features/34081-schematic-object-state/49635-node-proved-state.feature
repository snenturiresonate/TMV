Feature: 49635 - Schematic State - node proved state
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway

  Background:
    Given I am viewing the map gw15cambrian.v

  @replaySetup
  Scenario: 34081-15 - Node Proven State (Given)
    # Given an S-Class message is received and processed
    # And the S-Class message is associated with an S-Class berth of type Node Proved
    # And the S-Class message is setting the shunt marker board to Node Proven given
    # When a user is viewing a map that contains the shunt marker board
    # Then the shunt marker board will display a Node Proven given (green cross next to the shunt marker board)
    * this replay setup test has been moved to become part of the replay test: 34393 - 21 Node Proven State (Given)

  @replaySetup
  Scenario: 34081-16 - Node Proven State (Not Given)
    # Given an S-Class message is received and processed
    # And the S-Class message is associated with an S-Class berth of type Node Proved
    # And the S-Class message is setting the shunt marker board to Node Proven not given
    # When a user is viewing a map that contains the shunt marker board
    # Then the shunt marker board will not display a Node Proven given (removal of the green cross next to the shunt marker board)
    * this replay setup test has been moved to become part of the replay test: 34393 - 22 Node Proven State (Not Given)
