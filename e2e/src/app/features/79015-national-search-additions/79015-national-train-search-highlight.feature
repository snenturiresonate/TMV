@TMVPhase2 @P2.S2
@newSession
Feature: 79015 - TMV National Search Additions - National Train Search Highlight
  As a TMV User
  I want the ability to search for a berth
  So that I can open a map that is of interest

  # Given the user is authenticated to use TMV
  # And the user is viewing the train search results
  # When the user selects a map from the train search results
  # Then the user is presented with a map that contains the train
  # And the train is highlighted for 10 seconds flashing between green and purple

  Background:
    * I have cleared out all headcodes
    * I generate a new train description
    * I generate a new trainUID

  Scenario Outline: 82779-1 - National Train Search Highlight - Live
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUID>  |
    And I wait until today's train '<planningUID>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUID> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a train)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I am on the home page
    When I search Train for '<trainDescription>'
    Then results are returned with that planning UID '<planningUID>'
    And the window title is displayed as 'Train Search Results'
    When I invoke the context menu from train with planning UID '<planningUID>' and schedule date 'today' from the search results
    And I wait for the train search context menu to display
    Then the trains context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select Maps' on line 2
    When I place the mouseover on map arrow link
    Then the following map names can be seen
      | mapName |
      | HDGW01  |
      | GW01    |
    When I open the Map 'HDGW01'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the tab title is 'TMV Map HDGW01'
    And the train in berth D3A007 is highlighted on page load
    And berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible on map
    When I give the train 10 seconds to finish highlighting
    Then the train in berth D3A007 is not highlighted

    Examples:
      | trainDescription | planningUID |
      | generated        | generated   |

  Scenario Outline: 82779-2 - National Berth Search Highlight - Replay
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUID>  |
    And I wait until today's train '<planningUID>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUID> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a train)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name '<mapGroup>'
    And I select the map '<map>'
    When I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I search Train for '<trainDescription>'
    Then results are returned with that planning UID '<planningUID>'
    And the window title is displayed as 'Train Search Results'
    When I invoke the context menu from train with planning UID '<planningUID>' and schedule date 'today' from the search results
    And I wait for the train search context menu to display
    Then the trains context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select Maps' on line 2
    When I place the mouseover on map arrow link
    Then the following map names can be seen
      | mapName |
      | HDGW01  |
      | GW01    |
    When I open the Map 'HDGW01'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the tab title is 'TMV Replay HDGW01'
    And the train in berth D3A007 is highlighted on page load
    And berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible on map
    When I give the train 10 seconds to finish highlighting
    Then the train in berth D3A007 is not highlighted

    Examples:
      | trainDescription | planningUID | mapGroup               | map                |
      | generated        | generated   | Wales & Western        | HDGW02reading.v    |
