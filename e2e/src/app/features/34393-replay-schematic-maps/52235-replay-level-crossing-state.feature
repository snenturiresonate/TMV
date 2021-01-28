Feature: 34393 - Replay page Schematic Object State Scenarios - Level Crossing and Direction Lock
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @tdd @replayTest
  Scenario: 34393 - 27 Level Crossing State (Up)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Level Crossing
#    And the S-Class message is setting the Level Crossing to "Proved up"
#    When a user is viewing a map that contains the Level Crossing
#    Then the Level Crossing will display an "Up" lefthand side
    Given I load the replay data from scenario '34081 - 21 Level Crossing State (Up)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw08cardiffswml.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the level crossing barrier status of 'C2LXPN' is Up
    And the level crossing barrier status of 'C2PNWK' is Wk

  @tdd @replayTest
  Scenario: 34393 - 28 Level Crossing State (Down)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Level Crossing
#    And the S-Class message is setting the Level Crossing to "Down"
#    When a user is viewing a map that contains the Level Crossing
#    Then the Level Crossing will display a "Dn" on the left side and a "Wk" for the working on the right side
    Given I load the replay data from scenario '34081 - 22 Level Crossing State (Down)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'md19marstonvale.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the level crossing barrier status of 'RTFSUD' is Dn

  @tdd @replayTest
  Scenario: 34393 - 29 Level Crossing State (Failed)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Level Crossing
#    And the S-Class message is setting the Level Crossing to "Failed"
#    When a user is viewing a map that contains the Level Crossing
#    Then the Level Crossing will display an "F" righthand side
    Given I load the replay data from scenario '34081 - 23 Level Crossing State - verification of non-working state display'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'md19marstonvale.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the level crossing barrier status of 'RTLLUD' is Dn
    Then the level crossing barrier status of 'RTLLFL' is Fal

  @tdd @replayTest
  Scenario: 34393 - 30a Direction Lock State (Locked)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Direction Lock
#    And the S-Class message is setting the Direction Lock to not locked
#    When a user is viewing a map that contains the Direction Lock
#    Then the Direction Lock will display a chevron in the direction of the lock
    Given I load the replay data from scenario '34081 - 24a Direction Lock State (Locked)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the direction lock chevron of 'MHSBWP' is <

  @tdd @replayTest
  Scenario: 34393 - 30b Direction Lock State (Locked) both directions
    Given I load the replay data from scenario '34081 - 24b Direction Lock State (Locked) both directions'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the direction lock chevron of 'MHDJMH' is >
    And the direction lock chevron of 'MHMHDJ' is <

  @tdd @replayTest
  Scenario: 34393 - 31 Direction Lock State (Not Locked)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Direction Lock
#    And the S-Class message is setting the Direction Lock to not locked
#    When a user is viewing a map that contains the Direction Lock
#    Then the Direction Lock will not display a chevron
    Given I load the replay data from scenario '34081 - 25 Direction Lock State (Not Locked)'
    And I am on the replay page
    When I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw15cambrian.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the direction lock chevrons are not displayed
