@newSession
Feature: 52214 - TMV Trains List - menu
  (From Gherkin for Feature 33764)

  As a TMV User
  I want the ability to have a tabular view of live trains that is filtered
  So that I have tailored list trains that I am interested in

  Background:
    * I remove all trains from the trains list
    * I generate a new trainUID


  Scenario Outline: 33764-5b Trains List - Context menu contains information specific to the train on that row, matching the grid values
    #    Given the user is authenticated to use TMV
    #    And the user is viewing the trains list
    #    And there are train entries present
    #    When the user performs a secondary click using their mouse
    #    Then the train's menu is opened
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
    And I am on the trains list page 1
    And I restore to default train list config '1'
    And I refresh the browser
    And I save the trains list config
    And The trains list table is visible
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu contains 'SERVICE : ' on line 1
    And the trains list context menu contains 'Open Timetable' on line 2
    And the trains list context menu contains 'Find Train' on line 3
    And the trains list context menu contains 'Departs' on line 7
    And the trains list context menu contains 'Arrives' on line 8
    And I can click away to clear the menu

    Examples:
      | trainUid  | trainDescription |
      | generated | 2P72             |

  Scenario Outline: 33764-5c Trains List Context menu - matched service
    #    Given the user is authenticated to use TMV
    #    And the user is viewing the trains list
    #    And there are train entries present
    #    When the user performs a secondary click using their mouse
    #    Then the train's menu is opened
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
    And I am on the trains list page 1
    And I restore to default train list config '1'
    And I refresh the browser
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu contains '<trainDescription>' on line 1
    And the Matched version of the trains list context menu is displayed
    And the trains list context menu contains 'RDNGSTN' on line 6
    And the trains list context menu contains 'PADTON' on line 6

    Examples:
    | trainUid  | trainDescription |
    | generated | 2P73             |

  # unmatched services from stepping is part of CCN1
  @tdd
  Scenario: 33764-5d Trains List Context menu - unmatched train with unknown direction
    #    Given the user is authenticated to use TMV
    #    And the user is viewing the trains list
    #    And there are train entries present
    #    When the user performs a secondary click using their mouse
    #    Then the train's menu is opened
    Given the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 0535    | D6             | 5N68             |
    And I am on the trains list page 1
    And I restore to default train list config '1'
    And I refresh the browser
    And I save the trains list config
    And The trains list table is visible
    And train description '5N68' is visible on the trains list with schedule type ''
    When I invoke the context menu for todays train '5N68' schedule uid 'UNPLANNED' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu contains '5N68' on line 1
    Then the trains list context menu contains 'No timetable' on line 2
    And the trains list context menu contains 'Match' on line 4
    And the trains list context menu contains 'D60535' on line 6
    And the trains list context menu contains 'T535' on line 7
    And the trains list context menu contains 'T6284' on line 7
    When I click on Match in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching 5N68'
    And no matched service is visible
    * the access plan located in CIF file 'access-plan/trains_list_sort_cancelled.cif' is received from LINX


