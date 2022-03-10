Feature: 53790 - Schematic State - NFR Testing (Page load)
  As a TMV dev team member
  I want performance tests for Schematic State page load
  So that I can have early sight of any performance issues

  Background:
    * I am on the home page
    * I generate a new trainUID
    * I generate a new train description
    * I delete 'generated:today' from hash 'schedule-modifications-today'
    * I reset the stopwatch

  Scenario Outline: 34081 - 34 Opening a map (response time)
    #
    # Given a user is authorised
    # When a user selects to opens a new map
    # Then then the map is displayed within 1 second
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <CIF>     | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth interpose messages is sent from LINX
      | toBerth   | trainDescriber   | trainDescription   |
      | <toBerth> | <trainDescriber> | <trainDescription> |
    When I start the stopwatch
    And I am viewing the map GW01paddington.v
    And berth '<toBerth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '1000' milliseconds

    Examples:
    | CIF                              | trainDescription | trainUid  | toBerth | trainDescriber |
    | access-plan/1D46_PADTON_OXFD.cif | generated        | generated | A001    | D3             |

  Scenario Outline: 34081 - 35 Refreshing a map (response time)
    # Given a user is authorised
    # When a user refreshes a map
    # Then then the map is displayed within 1 second
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <CIF>     | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth interpose messages is sent from LINX
      | toBerth   | trainDescriber   | trainDescription   |
      | <toBerth> | <trainDescriber> | <trainDescription> |
    And I am viewing the map GW01paddington.v
    And berth '<toBerth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When I start the stopwatch
    And I refresh the browser
    And berth '<toBerth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '1000' milliseconds

    Examples:
      | CIF                              | trainDescription | trainUid  | toBerth | trainDescriber |
      | access-plan/1D46_PADTON_OXFD.cif | generated        | generated | A001    | D3             |
