@TMVPhase2 @P2.S3
Feature: 80331 - TMV Trains List Interaction - Trains List Timetable Primary Click

  As a TMV User
  I want the ability to interact with the trains list
  So that I can access additional functions or information

  Background:
    * I remove all trains from the trains list

  Scenario Outline: 80333 - Trains List Timetable Primary Click - Matched
#    Given a user is viewing a trains list
#    And there are trains
#    When user selects a train entry with the primary click
#    And the train has a timetable
#    Then the train's timetable is opened in a new tab
    * I generate a new trainUID
    * I generate a new train description
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN     | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    When the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | RDNGSTN                | today         | now                 |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | 1668      | 1664    | D1             | <trainDescription> |
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    And I primary click for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And the number of tabs open is 2
    And I switch to the new tab
    Then the tab title is '<trainDescription> TMV Timetable'

    Examples:
      | trainUid  | trainDescription |
      | generated | generated        |
