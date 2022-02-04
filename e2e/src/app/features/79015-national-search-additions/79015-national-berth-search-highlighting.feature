@TMVPhase2 @P2.S2
@newSession
Feature: 79015 - TMV National Search Additions - National Berth Search Highlight

  Background:
    * I remove all trains from the trains list

  Scenario Outline:79190-1,79191-1 National Berth Search Highlight - Live
    # Given the user is authenticated to use TMV
    # And the user is viewing the berth search results
    # When the user selects a map from the berth search results
    # Then the user is presented with a map that contains the berth
    # And the berth is highlighted for 10 seconds flashing between green and purple
    And I have cleared out all headcodes
    And I navigate to <pageName> page
    And I search Berth for '6207'
    Then results are returned with text 'D4'
    And the window title is displayed as 'Berth Search Results'
    And I invoke the context menu for berth containing text 'D4'
    And I wait for the berth search context menu to display
    And the berth context menu is displayed
    And the train search context menu contains 'Select Maps' on line 1
    And I place the mouseover on map arrow link
    And the following map names can be seen for the berth
      | mapName |
      | GW02    |
      | HDGW01  |
    And I open the Map 'GW02'
    Then the number of tabs open is 2
    When I switch to the new tab
    And the tab title is 'TMV Map GW02'
    Then the train in berth D46207 is highlighted on page load
    And berth '6207' in train describer 'D4' contains '6207' and is visible on map
    When the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | 6207    | D4             | 1G69             |
    Then berth '6207' in train describer 'D4' contains '6207' and is visible on map
    When I give the Map 10 seconds to highlight
    Then berth '6207' in train describer 'D4' contains '1G69' and is visible on map
    Examples:
      | pageName         |
      | Home             |

  Scenario Outline:79190-1,79191-1 National Berth Search Highlight with train in berth - Live
    # Given the user is authenticated to use TMV
    # And the user is viewing the berth search results
    # When the user selects a map from the berth search results
    # Then the user is presented with a map that contains the berth
    # And the berth is highlighted for 10 seconds flashing between green and purple
    And I have cleared out all headcodes
    And I navigate to <pageName> page
    And I search Berth for '6207'
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | 6207    | D4             | 1G69             |
    Then results are returned with text 'D4'
    And the window title is displayed as 'Berth Search Results'
    And I invoke the context menu for berth containing text 'D4'
    And I wait for the berth search context menu to display
    And the berth context menu is displayed
    And the train search context menu contains 'Select Maps' on line 1
    And I place the mouseover on map arrow link
    And the following map names can be seen for the berth
      | mapName |
      | GW02    |
      | HDGW01  |
    And I open the Map 'GW02'
    Then the number of tabs open is 2
    When I switch to the new tab
    And the tab title is 'TMV Map GW02'
    Then the train in berth D46207 is highlighted on page load
    And berth '6207' in train describer 'D4' contains '6207' and is visible on map
    When I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'On'
    Then berth '6207' in train describer 'D4' contains '6207' and is visible on map
    When I give the Map 10 seconds to highlight
    Then berth '6207' in train describer 'D4' contains '6207' and is visible on map
    Examples:
      | pageName         |
      | Home             |


  @tdd @tdd:82112
  Scenario:79190-2,79191-2 National Berth Search Highlight Replay
    # Given the user is authenticated to use TMV
    # And the user is viewing the berth search results
    # When the user selects a map from the berth search results
    # Then the user is presented with a map that contains the berth
    # And the berth is highlighted for 10 seconds flashing between green and purple
    Given I have not already authenticated
    And I have cleared out all headcodes
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

    And I search Berth for '6207'
    And I give the system 2 seconds to load
    Then results are returned with text 'D4'
    And the window title is displayed as 'Berth Search Results'
    And I invoke the context menu for berth containing text 'D4'
    And I wait for the berth search context menu to display
    And the berth context menu is displayed
    And the train search context menu contains 'Select Maps' on line 1
    And I place the mouseover on map arrow link
    And the following map names can be seen for the berth
      | mapName |
      | GW02    |
      | HDGW01  |
    And I open the Map 'GW02'
    Then the number of tabs open is 2
    When I switch to the new tab
    And the tab title is 'TMV Replay GW02'
    And I give the system 2 seconds to load
    Then the train in berth D46207 is highlighted on page load
    And berth '6207' in train describer 'D4' contains '6207' and is visible on map
