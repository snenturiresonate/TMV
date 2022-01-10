@TMVPhase2 @P2.S1
Feature: 78815 - TMV Map Interaction - Launched Timetable Tab Name (Live and Replay)

  As a TMV User
  I want the ability to interact with the schematic maps
  So that I can access additional functions or information

  Scenario Outline: 78846-1 Live and Replay - Open Timetable (from Map - Schedule Matched not activated)
    # Replay Setup
    * I generate a new trainUID
    * I generate a new train description
    * I remove today's train '<planningUid>' from the Redis trainlist
    * the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
    | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
    | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    * the following live berth interpose message is sent from LINX (to indicate train is present)
    | toBerth | trainDescriber | trainDescription |
    | C007    | D3             | <trainNum>       |
    * the following live berth step message is sent from LINX (creating a match)
    | fromBerth | toBerth | trainDescriber | trainDescription |
    | C007      | A007    | D3             | <trainNum>       |
    * I am viewing the map HDGW01paddington.v
    * I invoke the context menu on the map for train <trainNum>
    * I open timetable from the map context menu
    * I switch to the new tab
    * the tab title is '<trainNum> TMV Timetable'

    #    Replay Test
    #    Given the user is authenticated to use TMV replay
    #    And the user is viewing a Replay map
    #    When the user selects a train (occupied berth) from the map using the secondary click for a service which has been Schedule Matched but not activated
    #    And selects the "open timetable" option from the menu
    #    Then the train's timetable is opened in a new browser tab
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    And I click Play button
    When I wait for the Open timetable option for train description <trainNum> in berth A007, describer D3 to be available
    And I invoke the context menu on the map for train <trainNum>
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is '<trainNum> TMV Replay Timetable'

    Examples:
    | trainNum  | planningUid |
    | generated | generated   |

Scenario Outline: 78846-2 Live and Replay - Open Timetable (from Map - Unmatched)
    # Replay Setup
    * I generate a new train description
    * I am viewing the map HDGW01paddington.v
    * I have cleared out all headcodes
    * the following live berth interpose message is sent from LINX (to indicate train is present)
    | toBerth | trainDescriber | trainDescription |
    | 0099    | D3             | <trainNum>       |
    * I invoke the context menu on the map for train <trainNum>
    * the map context menu contains 'No Timetable' on line 2

    #    Replay Test
    #    Given the user is authenticated to use TMV replay
    #    And the user is viewing a Replay map
    #    When the user selects a train (occupied berth) from the map using the secondary click for a service which has been Schedule Matched
    #    And selects the "open timetable" option from the menu
    #    Then the train's timetable is opened in a new browser tab
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    And I click Play button
    When I wait for the No timetable option for train description <trainNum> in berth 0099, describer D3 to be available
    And I invoke the context menu on the map for train <trainNum>
    Then the map context menu contains 'No Timetable' on line 2

    Examples:
    | trainNum  |
    | generated |

Scenario Outline: 78846-3 Live and Replay - Open Timetable (from Map secondary click - Activated and Schedule Matched)
    # Replay Setup
    * I generate a new trainUID
    * I generate a new train description
    * I remove today's train '<planningUid>' from the Redis trainlist
    * the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
    | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
    | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    * the following train activation message is sent from LINX
    | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
    | <planningUid> | <trainNum>  | now                    | 99999               | PADTON                 | today         | now                 |
    * the following live berth interpose message is sent from LINX (to indicate train is present)
    | toBerth | trainDescriber | trainDescription |
    | C007    | D3             | <trainNum>       |
    * the following live berth step message is sent from LINX (creating a match)
    | fromBerth | toBerth | trainDescriber | trainDescription |
    | C007      | A007    | D3             | <trainNum>       |
    * I am viewing the map HDGW01paddington.v
    * I invoke the context menu on the map for train <trainNum>
    * I open timetable from the map context menu
    * I switch to the new tab
    * the tab title is '<trainNum> TMV Timetable'

    #    Replay Test
    #    Given the user is authenticated to use TMV replay
    #    And the user is viewing a Replay map
    #    When the user selects a train (occupied berth) from the map using the secondary click for a service which has been Schedule Matched
    #    And selects the "open timetable" option from the menu
    #    Then the train's timetable is opened in a new browser tab
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    And I click Play button
    When I wait for the Open timetable option for train description <trainNum> in berth A007, describer D3 to be available
    And I invoke the context menu on the map for train <trainNum>
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is '<trainNum> TMV Replay Timetable'

    Examples:
    | trainNum  | planningUid |
    | generated | generated   |

  Scenario Outline: 78846-4 Live and Replay - Open Timetable (from Search Result - matched service (Train) and matched/unmatched services (Timetable) have timetables)
    # Replay Setup
    * I am on the home page
    * I generate a new trainUID
    * I generate a new train description
    * the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid>  |
    * I wait until today's train 'generatedTrainUId' has loaded
    * the following train activation message is sent from LINX
      | sendMessage        | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <activationNeeded> | <planningUid> | <trainNum>  | now                    | 99999               | PADTON                 | today         | now                 |
    * the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | C007    | D3             | <trainNum>       |
    * the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | C007      | A007    | D3             | <trainNum>       |
    * I give the Elastic Stack 2 seconds to update
    * I refresh the Elastic Search indices
    * I search <searchType> for '<planningUid>' and wait for result
      | PlanningUid   |
      | <planningUid> |
    * the search table is shown
    * I invoke the context menu from a <serviceStatus> service in the <searchType> list
    * I wait for the '<searchType>' search context menu to display
    * the '<searchType>' context menu is displayed
    * the '<searchType>' search context menu contains 'Open Timetable' on line 1
    * the '<searchType>' search context menu contains 'Select maps' on line 2
    * I click on timetable link
    * I switch to the new tab
    * the tab title contains 'TMV Timetable'
    * the tab title contains the selected Train

    #    Replay Test
    #    Given the user is authenticated to use TMV replay
    #    And the user is viewing a search results list within Replay
    #    When the user selects a search result using the secondary click
    #    And selects the "open timetable" option from the menu
    #    Then the timetable is opened in a new browser tab
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I give the Elastic Stack 2 seconds to update
    And I refresh the Elastic Search indices
    And I search <searchType> for '<planningUid>' and wait for result
      | PlanningUid   |
      | <planningUid> |
    And the search table is shown
    When I invoke the context menu from a <serviceStatus> service in the <searchType> list
    And I wait for the '<searchType>' search context menu to display
    And the '<searchType>' context menu is displayed
    And the '<searchType>' search context menu contains 'Open Timetable' on line 1
    And the '<searchType>' search context menu contains 'Select maps' on line 2
    And I click on timetable link
    And I switch to the new tab
    And the tab title contains 'TMV Replay Timetable'
    And the tab title contains the selected Train

    Examples:
      | searchType | trainNum  | planningUid | activationNeeded | serviceStatus |
      | Train      | generated | generated   | true             | ACTIVATED     |
      | Train      | generated | generated   | false            | UNCALLED      |
      | Timetable  | generated | generated   | true             | ACTIVATED     |
      | Timetable  | generated | generated   | false            | UNCALLED      |
