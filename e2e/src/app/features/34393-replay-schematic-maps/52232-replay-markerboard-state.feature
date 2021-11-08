Feature: 52232 - Replay page Schematic Object State Scenarios
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  Scenario: 34393-16 Marker Board State (Movement Authority Unknown)
    # Replay Setup - 34081-10 - Marker Board State (Movement Authority Unknown)
    * I reset redis
    * I am viewing the map gw15cambrian.v
    * the marker board 'MH1201' will display a Movement Authority unknown [grey triangle on blue background]

    # MH1221 for validation is not set in loaded replay scenario, should be in unknown state
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW15cambrian.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then the marker board 'MH1221' will display a Movement Authority unknown [grey triangle on blue background]

