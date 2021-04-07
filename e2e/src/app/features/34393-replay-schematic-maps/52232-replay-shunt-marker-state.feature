@bug @bug_56581
Feature: 52232 - Replay page Schematic Object State Scenarios - Shunt Markers
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @replayTest
  Scenario: 34393-18 Shunt Marker Board State (Movement Authority Given)
    Given I load the replay data from scenario '34081-12 - Shunt Marker Board State (Movement Authority Given)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the shunt marker board 'MH1199' will display a Movement Authority given [white triangle with blue inner triangle]

  @replayTest
  Scenario: 34393-19 Shunt Marker Board State (Movement Authority Not Given)
    Given I load the replay data from scenario '34081-13 - Shunt Marker Board State (Movement Authority Not Given)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the shunt marker board 'MH1199' will display a Movement Authority not-given [red triangle with blue inner triangle]

  @replayTest
  Scenario: 34393-20 Shunt Marker Board State (Movement Authority Unknown)
    # MH1219 for validation is not set in loaded replay scenario, should be in unknown state
    Given I load the replay data from scenario '34081-14 - Shunt Marker Board State (Movement Authority Unknown)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the shunt marker board 'MH1219' will display a Movement Authority unknown [grey triangle with blue inner triangle]
