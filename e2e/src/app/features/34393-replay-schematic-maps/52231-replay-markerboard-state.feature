Feature: 34393 - Replay page Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @replayTest
  Scenario: 34393 - 14 Marker Board State (Movement Authority Not Given)
    # Replay Setup - 34081-8 - Marker Board State (Movement Authority Given)
    * I reset redis
    * I am viewing the map GW15cambrian.v
    * I set up all signals for address 31 in MH to be not-proceed
    * the marker board triangle for marker board 'MH1201' is red
    * the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | MH             | 31      | 02   | 10:45:00  |
    * the marker board 'MH1201' will display a Movement Authority given [green triangle on blue background]

    #    Given an S-Class message is received and processed
    #    And the S-Class message is associated with a marker board
    #    And the S-Class message is setting the marker board to Movement Authority given
    #    When a user is viewing a map that contains the marker board
    #    Then the marker board will display a Movement Authority given (green triangle on blue background)
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the marker board 'MH1201' will display a Movement Authority given [green triangle on blue background]

  @replayTest
  Scenario: 34393 - 15 Marker Board State (Movement Authority Given)
    # Replay Setup - 34081-9 - Marker Board State (Movement Authority Not Given)
    * I reset redis
    * I am viewing the map GW15cambrian.v
    * I set up all signals for address 31 in MH to be proceed
    * the marker board triangle for marker board 'MH1201' is green
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | MH             | 31      | FC   |
    * the marker board 'MH1201' will display a Movement Authority not-given [red triangle on blue background]

#    Given an S-Class message is received and processed
#    And the S-Class message is associated with a marker board
#    And the S-Class message is setting the marker board to Movement Authority not given
#    When a user is viewing a map that contains the marker board
#    Then the marker board will display a Movement Authority not given (red triangle on blue background)
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the marker board 'MH1201' will display a Movement Authority not-given [red triangle on blue background]
