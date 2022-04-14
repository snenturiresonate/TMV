Feature: 49634 - Schematic State - marker-board state
  (From Gherkin for Feature 34081)
  As a TMV User
  I want to schematic objects displayed with the latest state
  So that I have a live view of the railway


  Background:
    * I reset redis
    * I am viewing the map gw15cambrian.v

  Scenario: 34081-8 - Marker Board State (Movement Authority Given)
    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a marker board
    #    And the S-Class message is setting the marker board to Movement Authority given
    #    When a user is viewing a map that contains the marker board
    #    Then the marker board will display a Movement Authority given (green triangle on blue background)
    * this replay setup test has been moved to become part of the replay test: 34393 - 14 Marker Board State (Movement Authority Not Given)

  Scenario: 34081-9 - Marker Board State (Movement Authority Not Given)
    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a marker board
    #    And the S-Class message is setting the marker board to Movement Authority not given
    #    When a user is viewing a map that contains the marker board
    #    Then the marker board will display a Movement Authority not given (red triangle on blue background)
    * this replay setup test has been moved to become part of the replay test: 34393 - 15 Marker Board State (Movement Authority Given)

  Scenario: 34081-10 - Marker Board State (Movement Authority Unknown)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with a marker board
#    And the S-Class message is setting the marker board to Movement Authority unknown
#    When a user is viewing a map that contains the marker board
#    Then the marker board will display a Movement Authority unknown (grey triangle on blue background)
    Then the marker board 'MH1201' will display a Movement Authority unknown [grey triangle on blue background]

  Scenario: 34081-12 - Shunt Marker Board State (Movement Authority Given)
    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a shunt marker board
    #    And the S-Class message is setting the shunt marker board to Movement Authority given
    #    When a user is viewing a map that contains the shunt marker board
    #    Then the shunt marker board will display a Movement Authority given (white triangle with blue inner triangle)
    * this replay setup test has been moved to become part of the replay test: 34393-18 Shunt Marker Board State (Movement Authority Given)

  Scenario: 34081-13 - Shunt Marker Board State (Movement Authority Not Given)
    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a shunt marker board
    #    And the S-Class message is setting the shunt marker board to Movement Authority not given
    #    When a user is viewing a map that contains the shunt marker board
    #    Then the shunt marker board will display a Movement Authority not given (red triangle with blue inner triangle)
    * this replay setup test has been moved to become part of the replay test: 34393-19 Shunt Marker Board State (Movement Authority Not Given)

  Scenario: 34081-14 - Shunt Marker Board State (Movement Authority Unknown)
    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a shunt marker board
    #    And the S-Class message is setting the shunt marker board to Movement Authority unknown
    #    When a user is viewing a map that contains the shunt marker board
    #    Then the shunt marker board will display a Movement Authority unknown (grey triangle with blue inner triangle)
    * this replay setup test has been moved to become part of the replay test: 34393-20 Shunt Marker Board State (Movement Authority Unknown)
