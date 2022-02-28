@bug @bug:87160
Feature: 33753 - Timetable - Additional Automated Testing - Replay Timetable NFR Testing - Page Load

  Automated testing deferred from initial contract work

  Background:
    * I reset the stopwatch
    * I generate a new trainUID
    * I generate a new train description
    * I delete 'generated:today' from hash 'schedule-modifications'

  #  34375-9-1 Open Timetable (Map) response time - secondary click
  #    Given the user is authenticated to use TMV replay
  #    And the user is viewing a Replay map
  #    When the user selects a train (occupied berth) from the map using the secondary click for a service which has been Schedule Matched
  #    And selects the "open timetable" option from the menu
  #    Then the train's timetable is opened in a new browser tab within 1 second
  #
  #  Notes:
  #  Cannot open timetable from a service which has not been Schedule matched
  #
  Scenario Outline: 34375-9-1 - Open Replay Timetable (Map) response time - secondary click
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following live berth step message is sent from LINX (stepping the train)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0096    | D3             | <trainDescription> |
    And I give the replay data 2 seconds to be recorded
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I invoke the context menu on the map for train <trainDescription>
    When I start the stopwatch
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Replay Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |


  Scenario Outline: 34375-9-2 - Open Timetable (Map) response time - primary click
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following live berth step message is sent from LINX (stepping the train)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0096    | D3             | <trainDescription> |
    And I give the replay data 2 seconds to be recorded
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    When I start the stopwatch
    And I click on the map for train <trainDescription>
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Replay Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |


  #  34375-10 Open Timetable (Search Result - Train, Timetable & Manual Match Search Results) response time
  #    Given the user is authenticated to use TMV replay
  #    And the user is viewing a search results list within Replay
  #    When the user selects a search result using the secondary click
  #    And selects the "open timetable" option from the menu
  #    Then the timetable is opened in a new browser tab within 1 second
  #
  #  Notes
  #  No Manual Match in Replay
  #  See scenario 3 for pre-conditions for "open timetable"
  #
  Scenario Outline: 34375-10-1 - Open Timetable Response Time - Train Search
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a train)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I give the replay data 2 seconds to be recorded
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I search Train for '<planningUid>' and wait for result
      | PlanningUid   |
      | <planningUid> |
    And the search table is shown
    When I start the stopwatch
    And I open today's timetable with planning UID <planningUid> from the search results
    And the number of tabs open is 2
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Replay Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |


  Scenario Outline: 34375-10-2 - Open Timetable Response Time - Timetable Search
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a train)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I give the replay data 2 seconds to be recorded
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I search Timetable for '<planningUid>' and wait for result
      | PlanningUid   |
      | <planningUid> |
    And the search table is shown
    When I start the stopwatch
    And I open today's timetable with planning UID <planningUid> from the search results
    And the number of tabs open is 2
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Replay Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |


  #  34375-11 Refresh open Timetable response time
  #    Given the user is authenticated to use TMV replay
  #    And the user is viewing a timetable within Replay
  #    When the user refreshes the timetable
  #    Then the train's timetable is displayed within 1 second
  Scenario Outline: 34375-11 - Refresh open Timetable response time
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a train)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I give the replay data 2 seconds to be recorded
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    When I start the stopwatch
    And I click on the map for train <trainDescription>
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Replay Timetable'
    And the timetable header train UID is '<planningUid>'
    When I start the stopwatch
    And I refresh the browser
    And the tab title is '<trainDescription> TMV Replay Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |
