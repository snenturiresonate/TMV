@bug @bug_56581
Feature: 34393 - Replay page Schematic Object State Scenarios - Route Indication
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @tdd @replayTest
  Scenario: 34393 - 25a Route Indication State (Set - Main Signal)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Roue Indication
#    And the S-Class message is setting the Route Indication for a Main or Shunt Signal
#    When a user is viewing a map that contains the Main or Shunt Signal
#    Then the Main or Shunt Signal will display a Route Indication (1-3 alphanumeric char next to the signal)
    Given I load the replay data from scenario '34081-19a - Route Indication State (Set - Main Signal)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw01paddington.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the s-class-berth 'D30105' will display a Route indication of 'DM'

  @tdd @replayTest
  Scenario: 34393 - 25b Route Indication State (Set - Shunt Signal)
    Given I load the replay data from scenario '34081-19b - Route Indication State (Set - Shunt Signal)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw01paddington.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the s-class-berth 'D36003' will display a Route indication of 'A'

  @tdd @replayTest
  Scenario: 34393 - 25c Route Indication State (Set - Main Signal into platforms with several different indications possible 1-3 alphanumeric)
    Given I load the replay data from scenario '34081-19c - Route Indication State (Set - Main Signal into platforms with several different indications possible 1-3 alphanumeric)'
    And I am on the replay page
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw01paddington.v'
    And I wait for the buffer to fill
    When I select skip forward to just after replay scenario step '3'
    Then the s-class-berth 'D30032' will display a Route indication of '9'
    When I select skip forward to just after replay scenario step '4'
    Then the s-class-berth 'D30032' will display a Route indication of '10C'
    When I select skip forward to just after replay scenario step '5'
    Then the s-class-berth 'D30032' will display a Route indication of '10'

  @tdd @replayTest
  Scenario: 34393 - 26a Route Indication State (Not Set - Main Signal)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with an S-Class berth of type Roue Indication
#    And the S-Class message is setting the Route Indication for a Main or Shunt Signal
#    When a user is viewing a map that contains the Main or Shunt Signal
#    Then the Main or Shunt Signal will not display a Route Indication (remove the 1-3 alphanumeric char next to the signal)
    Given I load the replay data from scenario '34081-20a - Route Indication State (Not Set - Main Signal)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw01paddington.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the s-class-berth 'D30105' will display no Route indication of 'anything'

  @tdd @replayTest
  Scenario: 34393 - 26b Route Indication State (Not Set - Shunt Signal)
    Given I load the replay data from scenario '34081-20b - Route Indication State (Not Set - Shunt Signal)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'gw01paddington.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the s-class-berth 'D36003' will display no Route indication of 'anything'
