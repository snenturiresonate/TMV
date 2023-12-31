@bug @bug_58561
Feature: 34393 - Replay page Schematic Object State Scenarios
  (From Gherkin for Feature 40680 and functionality developed in US34081)
  As a TMV User
  I want the view schematic maps in replay mode
  So that I can view the historic running railway

  @tdd @replayTest
  Scenario:34393 - 11 Subsidiary Signal State (Proceed)
#    Given an S-Class message is received and processed
#    And the S-Class message is associated with a subsidiary signal
#    And the S-Class message is setting the subsidiary signal to proceed
#    When a user is viewing a map that contains the subsidiary signal
#    Then the subsidiary signal will display a proceed aspect (white roundel)
    Given I load the replay data from scenario '34081 - 5 Subsidiary Signal State (Proceed)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the signal roundel for signal 'SN271' is white

  @tdd @replayTest
  Scenario:34393 - 12 Shunt Signal State (Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a shunt signal
    #And the S-Class message is setting the shunt signal to proceed
    #When a user is viewing a map that contains the shunt signal
    #Then the shunt signal will display a proceed aspect (white quadrant)
    Given I load the replay data from scenario '34081 - 6 Shunt Signal State (Proceed)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the shunt signal state for signal 'SN6142' is white

  @tdd @replayTest
  Scenario: 34393 - 13 Shunt Signal State (Not Proceed)
    #Given an S-Class message is received and processed
    #And the S-Class message is associated with a shunt signal
    #And the S-Class message is setting the shunt signal to not proceed
    #When a user is viewing a map that contains the shunt signal
    #Then the shunt signal will display a not proceed aspect (red quadrant)
    Given I load the replay data from scenario '34081 - 7 Shunt Signal State (Not Proceed)'
    And I am on the replay page
    When I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I wait for the buffer to fill
    And I select skip forward until the end of the replay is reached
    Then the shunt signal state for signal 'SN6142' is red
