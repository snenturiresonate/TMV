@tdd
Feature: 52214 - TMV Trains List - menu
  (From Gherkin for Feature 33764)

  As a TMV User
  I want the ability to have a tabular view of live trains that is filtered
  So that I have tailored list trains that I am interested in

  Scenario: 33764-5a Trains List (Train Menu - random train)
#  Given the user is authenticated to use TMV
#  And the user is viewing the trains list
#  And there are train entries present
#  When the user performs a secondary click using their mouse
#  Then the train's menu is opened
    Given I am authenticated to use TMV
    And I am on the trains list page
    And The trains list table is visible
    And there are train entries present on the trains list
    When I perform a secondary click on a random service using the mouse
    And I wait for the trains list context menu to display
    Then the trains list context menu is displayed

  Scenario Outline: 33764-5b Trains List - Context menu contains information specific to the train on that row, matching the grid values
    Given I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu from train <trainNum> on the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu contains 'SERVICE : ' on line 1
    And the trains list context menu contains the only 'SERVICE' of train <trainNum> on line 1
    And the trains list context menu contains the only 'TOC/FOC' of train <trainNum> on line 1
    And the trains list context menu contains 'Open timetable' on line 2
    And the trains list context menu contains 'Find train' on line 4
    And the trains list context menu contains the only 'SERVICE' of train <trainNum> on line 5
    And the trains list context menu contains the only 'PUNCT.' of train <trainNum> on line 5
    And the trains list context menu contains 'Departs' on line 9
    And the trains list context menu contains the first 'PLANNED' of train <trainNum> on line 9
    And the trains list context menu contains the first 'ACTUAL / PREDICT' of train <trainNum> on line 9
    And the trains list context menu contains 'Arrives' on line 10
    And the trains list context menu contains the second 'PLANNED' of train <trainNum> on line 10
    And the trains list context menu contains the second 'ACTUAL / PREDICT' of train <trainNum> on line 10
    And the number of predicted times for train <trainNum> tallies
    And I can click away to clear the menu

    Examples:
      | trainNum |
      | 1        |
      | 2        |
      | 3        |
      | 4        |
      | 5        |

  @bug @bug:66859
  Scenario: 33764-5c Trains List Context menu - matched service
    Given the access plan located in CIF file 'access-plan/2P77_RDNGSTN_PADTON.cif' is amended so that all services start within the next hour and then received from LINX
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | D11664        | 2P77        | now                    | 99999               | RDNGSTN                | today         | now                 |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1668      | 1664    | D1             | 2P77             |
    And I am on the trains list page
    And The trains list table is visible
    And train '2P77' with schedule id 'D11664' for today is visible on the trains list
    When I invoke the context menu for todays train '2P77' schedule uid 'D11664' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu contains '2P77' on line 1
    And the trains list context menu contains 'Unmatch / Rematch' on line 3
    And the trains list context menu contains 'D11664' on line 6
    And the trains list context menu contains 'T1664' on line 7
    And the trains list context menu contains 'RDNGSTN' on line 8
    And the trains list context menu contains 'PADTON' on line 8
    When I open timetable from the context menu
    And the number of tabs open is 2
    And I switch to the new tab
    Then the tab title is 'TMV Timetable'
    And the timetable header train description is '2P77'
    When I close the last tab
    And I invoke the context menu for todays train '2P77' schedule uid 'D11664' from the trains list
    And I wait for the trains list context menu to display
    And I click on Unmatch in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching 2P77'
    And a matched service is visible

  # unmatched services from stepping is part of CCN1
  @tdd
  Scenario: 33764-5d Trains List Context menu - unmatched train with unknown direction
    Given the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 0535    | 5N68           | D6               |
    And I am on the trains list page
    And The trains list table is visible
    And train '5N68' with schedule id 'D60535' for today is visible on the trains list
    When I invoke the context menu for todays train '5N68' schedule uid 'D60535' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu contains '5N68' on line 1
    And the trains list context menu contains 'Match' on line 3
    And the trains list context menu contains 'D60535' on line 6
    And the trains list context menu contains 'T535' on line 7
    And the trains list context menu contains 'T6284' on line 7
    When I click on Match in the context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching 5N68'
    And no matched service is visible


