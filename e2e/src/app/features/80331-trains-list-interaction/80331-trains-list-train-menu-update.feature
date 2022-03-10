@TMVPhase2 @P2.S3
Feature: 80331 - TMV Trains List Interaction - Trains List Train Menu Update

  As a TMV User
  I want the ability to interact with the trains list
  So that I can access additional functions or information

  # Given a user is viewing a trains list
  # And there are train entries
  # When the user performs secondary click on a train entry
  # Then the train menu is displayed containing live service information (if available)
  #
  # The values can either:
  # Minutes early including half minutes in seconds rounded up or down (as per timetable view)
  # Minutes late including  half minutes in seconds rounded up or down (as per timetable view)
  # For service that are on time display "On Time"
  # If a punctuality cannot be determined display "Unavailable"
  # The signal id(s) and/or berth id the train is currently residing

  Background:
    * I reset redis
    * I have cleared out all headcodes
    * I remove all trains from the trains list
    * I have not already authenticated
    * I am on the home page
    * I restore all train list configs for current user to the default

  Scenario Outline: 80335-1 - Train Menu Update (Trains List) - punctuality On time

    * I generate a new trainUID
    * I generate a new train description
    * I delete '<trainUid>:today' from hash 'schedule-modifications-today'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
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
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu is displayed
    And the map context menu contains 'SERVICE : ' on line 1
    And the map context menu contains 'Open Timetable' on line 2
    And the map context menu contains 'Find Train' on line 3
    And the map context menu contains 'Hide Train' on line 4
    And the map context menu contains 'Unmatch/Rematch' on line 5
    And the map context menu contains '<trainDescription>' on line 6
    And the map context menu punctuality is one of On time,+0m 30s,+1m,+1m 30s
    And the map context menu contains 'T1664' on line 7
    And the map context menu contains 'D11664' on line 8
    And the map context menu contains 'RDNGSTN - PADTON' on line 9
    And the map context menu contains 'Departs' on line 10
    And the map context menu contains 'Arrives' on line 11
    And I open timetable from the context menu
    And I switch to the new tab
    Then the tab title is '<trainDescription> TMV Timetable'

    Examples:
      | trainUid  | trainDescription |
      | generated | generated        |

  Scenario Outline: 80335-2 - Train Menu Update (Trains List) - punctuality late

    * I generate a new trainUID
    * I generate a new train description
    * I delete '<trainUid>:today' from hash 'schedule-modifications-today'
    Given the train in CIF file below is updated accordingly so time at the reference point is now - '5' minutes, and then received from LINX
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
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu is displayed
    And the map context menu contains 'SERVICE : ' on line 1
    And the map context menu contains 'Open Timetable' on line 2
    And the map context menu contains 'Find Train' on line 3
    And the map context menu contains 'Hide Train' on line 4
    And the map context menu contains 'Unmatch/Rematch' on line 5
    And the map context menu contains '<trainDescription>' on line 6
    And the map context menu punctuality is one of +5m,+5m 30s,+6m
    And the map context menu contains 'T1664' on line 7
    And the map context menu contains 'D11664' on line 8
    And the map context menu contains 'RDNGSTN - PADTON' on line 9
    And the map context menu contains 'Departs' on line 10
    And the map context menu contains 'Arrives' on line 11
    And I open timetable from the context menu
    And I switch to the new tab
    Then the tab title is '<trainDescription> TMV Timetable'

    Examples:
      | trainUid  | trainDescription |
      | generated | generated        |

  @bug
  @87596
  Scenario Outline: 80335-3 - Train Menu Update (Trains List) - punctuality early

    Given I set up a train that is -4 late at RDNGSTN using access-plan/2P77_RDNGSTN_PADTON.cif TD D1 interpose into 1698 step to 1676
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu is displayed
    And the map context menu contains 'SERVICE : ' on line 1
    And the map context menu contains 'Open Timetable' on line 2
    And the map context menu contains 'Find Train' on line 3
    And the map context menu contains 'Unmatch/Rematch' on line 4
    And the map context menu contains '<trainDescription>' on line 5
    And the map context menu punctuality is one of -3m,-3m 30s,-4m
    And the map context menu contains 'T1698' on line 6
    And the map context menu contains 'D11698' on line 7
    And the map context menu contains 'RDNGSTN - PADTON' on line 8
    And the map context menu contains 'Departs' on line 9
    And the map context menu contains 'Arrives' on line 10
    And I open timetable from the context menu
    And I switch to the new tab
    Then the tab title is '<trainDescription> TMV Timetable'

    Examples:
      | trainUid  | trainDescription |
      | generated | generated        |


  @bug
  @87596
  Scenario Outline: 80335-4 - Train Menu Update (Trains List) - Punctuality Status unavailable

    * I generate a new trainUID
    * I generate a new train description
    * I delete '<trainUid>:today' from hash 'schedule-modifications-today'
    Given the following train running information message is sent from LINX
      | trainUID   | trainNumber         | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <trainUid> | <trainDescription>  | today              | 73000               | PADTON                 | Departure from Origin |
    And I wait until today's train '<trainUid>' has loaded
    And I am on the trains list page 1
    And I save the trains list config
    And train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu is displayed
    And the map context menu contains 'SERVICE : ' on line 1
    And the map context menu contains 'Open Timetable' on line 2
    And the map context menu contains 'Find Train' on line 3
    And the map context menu contains 'Unmatch/Rematch' on line 4
    And the map context menu punctuality is one of Unavailable
    And the map context menu contains '-' on line 6
    And the map context menu contains 'Departs' on line 7
    And the map context menu contains 'Arrives' on line 8

    Examples:
      | trainUid  | trainDescription |
      | generated | generated    |

