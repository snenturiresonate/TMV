@bug @bug:87160
Feature: 33753 - Timetable - Additional Automated Testing - Timetable NFR Testing - Page Load

  Automated testing deferred from initial contract work

  Background:
    * I reset the stopwatch
    * I remove all trains from the trains list
    * I generate a new trainUID
    * I generate a new train description
    * I delete 'generated:today' from hash 'schedule-modifications-today'
    * I am on the home page
    * I restore to default train list config '1'

  #  Given the user is authenticated to use TMV
  #  And the user is viewing the trains list
  #  When the user selects a train from the trains list using the secondary mouse click
  #  And selects the "open timetable" option from the menu
  #  Then the train's timetable is opened in a new browser tab within 1 second
  #
  #  Notes:
  #  From Trains List, only matched services will be able to Open Timetable – unmatched will not have this option.
  Scenario Outline: 33753-8-1 - Open Timetable (Trains List) response time - secondary click
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN     | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | RDNGSTN                | today         | now                 |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | 1668      | 1664    | D1             | <trainDescription> |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I start the stopwatch
    And I open timetable from the context menu, without delay
    And the number of tabs open is 2
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |


  Scenario Outline: 33753-8-2 - Open Timetable (Trains List) response time - primary click
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN     | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | RDNGSTN                | today         | now                 |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | 1668      | 1664    | D1             | <trainDescription> |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    When I start the stopwatch
    And I primary click for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And the number of tabs open is 2
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |


  #  Given the user is authenticated to use TMV
  #  And the user is viewing a map
  #  When the user selects a train (occupied berth) from the map using the secondary click for a service which has been Schedule matched
  #  And selects the "open timetable" option from the menu
  #  Then the train's timetable is opened in a new browser tab within 1 second
  #
  #  Notes:
  #  Cannot open timetable from a service which has not been Schedule matched
  Scenario Outline: 33753-9-1 - Open Timetable (Map) response time - Secondary Click
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
    And I am viewing the map HDGW01paddington.v
    And I invoke the context menu on the map for train <trainDescription>
    When I start the stopwatch
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |


  Scenario Outline: 33753-9-2 - Open Timetable (Map) response time - Primary Click
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
    And I am viewing the map HDGW01paddington.v
    When I start the stopwatch
    And I click on the map for train <trainDescription>
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |


  #  Given the user is authenticated to use TMV
  #  And the user is viewing a search results list
  #  When the user selects a train search result using the secondary click
  #  And selects the "open timetable" option from the menu
  #  Then the train's timetable is opened in a new browser tab within 1 second
  Scenario Outline: 33753-10-1 - Open Timetable Response Time - Train Search
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
    And I am on the home page
    And I search Train for '<planningUid>' and wait for result
      | PlanningUid   |
      | <planningUid> |
    And the search table is shown
    When I start the stopwatch
    And I open today's timetable with planning UID <planningUid> from the search results
    And the number of tabs open is 2
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |

  Scenario Outline: 33753-10-2 - Open Timetable Response Time - Timetable Search
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
    And I am on the home page
    And I search Timetable for '<planningUid>' and wait for result
      | PlanningUid   |
      | <planningUid> |
    And the search table is shown
    When I start the stopwatch
    And I open today's timetable with planning UID <planningUid> from the search results
    And the number of tabs open is 2
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |

  #  Given the user is authenticated to use TMV
  #  And the user is viewing a timetable
  #  When the user refreshes the timetable
  #  Then the train's timetable is displayed within 1 second
  Scenario Outline: 33753-11 - Refresh open Timetable response time
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
    And I am on the timetable view for service '<planningUid>'
    When I start the stopwatch
    And I refresh the browser
    And the tab title is '<trainDescription> TMV Timetable'
    And the timetable header train UID is '<planningUid>'
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | planningUid  | trainDescription |
      | generated    | generated        |
