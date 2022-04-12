@SmokeTest @newSession
Feature: 80780 - Smoke Test TMV Environments
  As a TMV dev team member
  I want to smoke test the TMV environments
  So that the automated tests can fail quickly if there are environment issues


  Background:
    * I am on the home page
    * I generate a new trainUID
    * I generate a new train description
    * I delete 'generated:today' from hash 'schedule-modifications-today'

  Scenario Outline: 81123-1 - Smoke Test - Timetable Service and Live Maps Service are Working
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <CIF>     | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth interpose messages is sent from LINX
      | toBerth   | trainDescriber   | trainDescription   |
      | <toBerth> | <trainDescriber> | <trainDescription> |
    And I am viewing the map GW01paddington.v
    And berth '<toBerth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | CIF                              | trainDescription | trainUid  | toBerth | trainDescriber |
      | access-plan/1D46_PADTON_OXFD.cif | generated        | generated | A001    | D3             |

    

  Scenario Outline: 81123-2 - Smoke Test - Trains List is Working
    Given I am on the home page
    * I reset redis
    * I restore to default train list config '1'
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <CIF>    | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    * I wait until today's train 'generated' has loaded
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    When I click the app 'trains-list-1'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the url contains 'trains-list/1'
    When I save the trains list config
    Then The trains list table is visible
    And The default trains list columns are displayed in order
    Then train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list

    Examples:
      | CIF                              | trainDescription | trainUid  |
      | access-plan/1D46_PADTON_OXFD.cif | generated        | generated |
