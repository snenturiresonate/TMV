@TMVPhase2 @P2.S1
Feature: 78852 - Trains Menu Consistency

  # Given a user is viewing TMV
  # When the uses the train menu
  # Then the hover behaviour are consistent

  # For elements that open a new tab (e.g. "Open Timetable" or "Highlight" or Map e.g "GW02"):
  #   the text should be blue
  #   on hover over blue underline
  #
  # For elements which have a sub menu (e.g. "Select maps" and "Find Train":
  #   the text should be Black text
  #   on hover over black underline
  #
  # For elements that do not open into a tab as they are disabled (e.g. "No timetable")
  #   the text should be blue
  #   on hover over no underlining

  Background:
    * I reset redis
    * I have cleared out all headcodes
    * I am on the home page
    * I restore to default train list config '1'

  Scenario Outline: 83105-1 - Trains Menu Consistency - Open Timetable | Find Train | Unmatch/Rematch
    Given I remove all trains from the trains list
    And I remove today's train '<planningUid>' from the trainlist
    And I generate a new trainUID
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainNum>  | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainNum>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    Then the trains list context menu contains 'Open Timetable' on line 2
    * the trains list context menu on line 2 has text colour 'blue'
    * the trains list context menu on line 2 has text underline 'none'
    When I hover over the trains list context menu on line 2
    * the trains list context menu on line 2 has text colour 'blue'
    * the trains list context menu on line 2 has text underline 'underline'
    Then the trains list context menu contains 'Find Train' on line 3
    * the trains list context menu on line 3 has text colour 'black'
    * the trains list context menu on line 3 has text underline 'none'
    When I hover over the trains list context menu on line 3
    * the trains list context menu on line 3 has text colour 'hoverBlack'
    * the trains list context menu on line 3 has text underline 'underline'
    Then the trains list context menu contains 'Hide Train' on line 4
    * the trains list context menu on line 4 has text colour 'black'
    * the trains list context menu on line 4 has text underline 'none'
    When I hover over the trains list context menu on line 4
    * the trains list context menu on line 4 has text colour 'hoverBlack'
    * the trains list context menu on line 4 has text underline 'underline'
    Then the trains list context menu contains 'Unmatch/Rematch' on line 5
    * the trains list context menu on line 5 has text colour 'blue'
    * the trains list context menu on line 5 has text underline 'none'
    When I hover over the trains list context menu on line 5
    * the trains list context menu on line 5 has text colour 'blue'
    * the trains list context menu on line 5 has text underline 'underline'

    Examples:
      | planningUid | trainNum  |
      | generated   | 1A86      |

  Scenario Outline: 83105-2 - Trains Menu Consistency - No Timetable | Find Train | Match
    * I generate a new train description
    Given I am viewing the map HDGW04bristolparkway.v
    And the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription   |
      | 1168    | D7             | <trainDescription> |
    And berth '1168' in train describer 'D7' contains '<trainDescription>' and is visible
    And 'no' toggle is displayed in the title bar
    When I invoke the context menu on the map for train <trainDescription>>
    Then the map context menu contains 'No Timetable' on line 2
    * the trains list context menu on line 2 has text colour 'blue'
    * the trains list context menu on line 2 has text underline 'none'
    When I hover over the trains list context menu on line 2
    * the trains list context menu on line 2 has text colour 'blue'
    * the trains list context menu on line 2 has text underline 'none'
    Then the trains list context menu contains 'Match' on line 3
    * the trains list context menu on line 3 has text colour 'blue'
    * the trains list context menu on line 3 has text underline 'none'
    When I hover over the trains list context menu on line 3
    * the trains list context menu on line 3 has text colour 'blue'
    * the trains list context menu on line 3 has text underline 'underline'
    Then the trains list context menu contains 'Highlight' on line 4
    * the trains list context menu on line 4 has text colour 'blue'
    * the trains list context menu on line 4 has text underline 'none'
    When I hover over the trains list context menu on line 4
    * the trains list context menu on line 4 has text colour 'blue'
    * the trains list context menu on line 4 has text underline 'underline'

    Examples:
      | trainDescription |
      | generated        |


