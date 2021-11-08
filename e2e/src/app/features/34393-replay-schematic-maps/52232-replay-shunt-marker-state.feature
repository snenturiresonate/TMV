Feature: 52232 - Replay page Schematic Object State Scenarios - Shunt Markers
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  Background:
    * I reset redis
    * I am viewing the map gw15cambrian.v

  Scenario: 34393-18 Shunt Marker Board State (Movement Authority Given)
    # Replay Setup - 34081-12 - Shunt Marker Board State (Movement Authority Given)
    * I set up all signals for address 31 in MH to be not-proceed
    * the shunt marker board triangle for shunt marker board 'MH1199' is red
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | MH             | 31      | 01   |
    * the shunt marker board 'MH1199' will display a Movement Authority given [white triangle with blue inner triangle]

    # Replay Test
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the shunt marker board 'MH1199' will display a Movement Authority given [white triangle with blue inner triangle]

  Scenario: 34393-19 Shunt Marker Board State (Movement Authority Not Given)
    # Replay Setup - 34081-13 - Shunt Marker Board State (Movement Authority Not Given)
    * I set up all signals for address 31 in MH to be proceed
    * the shunt marker board triangle for shunt marker board 'MH1199' is white
    * the following live signalling update message is sent from LINX
      | trainDescriber | address | data |
      | MH             | 31      | FE   |
    * the shunt marker board 'MH1199' will display a Movement Authority not-given [red triangle with blue inner triangle]

    # Replay Test
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the shunt marker board 'MH1199' will display a Movement Authority not-given [red triangle with blue inner triangle]

  Scenario: 34393-20 Shunt Marker Board State (Movement Authority Unknown)
    # Replay Setup - 34081-14 - Shunt Marker Board State (Movement Authority Unknown)
    * the shunt marker board 'MH1199' will display a Movement Authority unknown [grey triangle with blue inner triangle]

    # MH1219 for validation is not set in loaded replay scenario, should be in unknown state
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the shunt marker board 'MH1219' will display a Movement Authority unknown [grey triangle with blue inner triangle]
