Feature: 52232 - Replay page Schematic Object State Scenarios
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @replayTest
  Scenario: 34393-16 Marker Board State (Movement Authority Unknown)
    # MH1221 for validation is not set in loaded replay scenario, should be in unknown state
    Given I load the replay data from scenario '34081-10 - Marker Board State (Movement Authority Unknown)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the marker board 'MH1221' will display a Movement Authority unknown [grey triangle on blue background]

