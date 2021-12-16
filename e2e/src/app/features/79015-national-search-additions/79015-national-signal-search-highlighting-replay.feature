@newSession
Feature: 79015 - TMV National Search Additions - National Signal Search Highlight Replay

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

  Scenario: 34380-8 National Signal Search Highlight
    # Given the user is authenticated to use TMV
    # And the user is viewing the signal search results
    # When the user selects a map from the signal search results
    # Then the user is presented with a map that contains the signal
    # And the berth associated to the signal is highlighted for 10 seconds flashing between green and purple with the letters "SGNL"
    Given I search Signal for 'SN15'
    Then the signal search table is shown
    And the window title is displayed as 'Signal Search Results'
    When I invoke the context menu for signal with ID 'SN15'
    And I wait for the signal search context menu to display
    Then the signal context menu is displayed
    And the 'signal' search context menu contains 'Select maps' on line 1
    And the following map names can be seen for the signal
      |mapName|
      |HDGW01 |
      |GW01   |
    And I open the Map 'HDGW01'
    And I switch to the new tab
    Then the tab title is 'TMV Replay HDGW01'
    Then the train in berth D3A015 is highlighted on page load
    Then berth 'A015' in train describer 'D3' is visible
