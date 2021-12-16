@newSession
Feature: 79015 - TMV National Search Additions - National Berth Search Highlight Replay

  Background:
    * I have not already authenticated
    * I remove today's train 'L10006' from the Redis trainlist
    * the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | SLOUGH      | WTT_arr       | 1A06                | L10006         |
    * I wait until today's train 'L10006' has loaded
    * the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | L10006    | 1A06        | now                    | 99999               | PADTON                 | today         | now                 |
    * the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0519    | D6             | 1A06             |
    * I am on the replay page
    * I select Next
    * I expand the replay group of maps with name 'Wales & Western'
    * I select the map 'HDGW02reading.v'
    * I wait for the buffer to fill
    * I click Skip forward button '4' times
    * I increase the replay speed at position 15
    * I click Play button

  @tdd @tdd:82112
  Scenario:79190-2,79191-2 National Berth Search Highlight Replay
    # Given the user is authenticated to use TMV
    # And the user is viewing the berth search results
    # When the user selects a map from the berth search results
    # Then the user is presented with a map that contains the berth
    # And the berth is highlighted for 10 seconds flashing between green and purple
    And I search Berth for '0259'
    And I give the system 2 seconds to load
    Then results are returned with text 'D4'
    And the window title is displayed as 'Berth Search Results'
    And I invoke the context menu for berth containing text 'D4'
    And I wait for the berth search context menu to display
    And the berth context menu is displayed
    And the train search context menu contains 'Select maps' on line 1
    And I placed the mouseover on map arrow link
    And the following map names can be seen for the berth
      | mapName |
      | GW02    |
      | HDGW01  |
    And I open the Map 'GW02'
    And I switch to the new tab
    And the tab title is 'TMV Replay GW02'
    And I give the system 2 seconds to load
    Then berth '0259' in train describer 'D4' is visible
