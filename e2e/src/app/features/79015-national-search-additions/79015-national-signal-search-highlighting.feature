@newSession
Feature: 79015 - TMV National Search Additions - National Signal Search Highlight Live

  Scenario Outline:79193-1 National Signal Search Highlight Live - <pageName>
    # Given the user is authenticated to use TMV
    # And the user is viewing the signal search results
    # When the user selects a map from the signal search results
    # Then the user is presented with a map that contains the signal
    # And the berth associated to the signal is highlighted for 10 seconds flashing between green and purple with the letters "SGNL"
    Given I remove all trains from the trains list
    And I navigate to <pageName> page
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    When I invoke the context menu for signal with ID 'SN259'
    And I wait for the signal search context menu to display
    And the signal context menu is displayed
    And the train search context menu contains 'Select maps' on line 1
    And I placed the mouseover on signal map option
    And the following signal map names can be seen
    | mapName |
    | GW02    |
    | HDGW01  |
    And I open the Map 'GW02'
    Then the number of tabs open is 2
    When I switch to the new tab
    And the tab title is 'TMV Map GW02'
    Then the train in berth D40259 is highlighted on page load
    And berth '0259' in train describer 'D4' contains 'SGNL' and is visible on page load
    When I give the Map 10 seconds to highlight
    Then berth '0259' in train describer 'D4' and is not visible
    Examples:
    | pageName         |
    | Home             |

  Scenario:  79193-2 National Signal Search Highlight
    # Given the user is authenticated to use TMV
    # And the user is viewing the signal search results
    # When the user selects a map from the signal search results
    # Then the user is presented with a map that contains the signal
    # And the berth associated to the signal is highlighted for 10 seconds flashing between green and purple with the letters "SGNL"
    Given I have not already authenticated
    And I remove today's train 'L10006' from the Redis trainlist
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | SLOUGH      | WTT_arr       | 1A06                | L10006         |
    And I wait until today's train 'L10006' has loaded
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | L10006    | 1A06        | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0519    | D6             | 1A06             |
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW02reading.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    And I click Play button
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
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the tab title is 'TMV Replay HDGW01'
    Then the train in berth D3A015 is highlighted on page load
    And berth 'A015' in train describer 'D3' contains 'SGNL' and is visible on page load
