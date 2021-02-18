Feature: 34393 - Replay page Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @tdd @replayTest
  Scenario: 34393 - 14 Marker Board State (Movement Authority Not Given)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with a marker board
#    And the S-Class message is setting the marker board to Movement Authority given
#    When a user is viewing a map that contains the marker board
#    Then the marker board will display a Movement Authority given (green triangle on blue background)
    Given I load the replay data from scenario '34081-8 - Marker Board State (Movement Authority Given)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the marker board 'MH1201' will display a Movement Authority given [green triangle on blue background]

  @tdd @replayTest
  Scenario: 34393 - 15 Marker Board State (Movement Authority Given)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with a marker board
#    And the S-Class message is setting the marker board to Movement Authority not given
#    When a user is viewing a map that contains the marker board
#    Then the marker board will display a Movement Authority not given (red triangle on blue background)
    Given I load the replay data from scenario '34081-9 - Marker Board State (Movement Authority Not Given)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the marker board 'MH1201' will display a Movement Authority not-given [red triangle on blue background]
