Feature: 79015 - TMV National Search Additions - National Berth Search Highlight Live

  Background:
    * I remove all trains from the trains list

  Scenario Outline:79190-1,79191-1 National Berth Search Highlight Live
    # Given the user is authenticated to use TMV
    # And the user is viewing the berth search results
    # When the user selects a map from the berth search results
    # Then the user is presented with a map that contains the berth
    # And the berth is highlighted for 10 seconds flashing between green and purple
    And I navigate to <pageName> page
    And I search Berth for '0259'
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
    And the tab title is 'TMV Map GW02'
    Then berth '0259' in train describer 'D4' is visible
    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | TrainsListConfig |
      | Maps             |
      | LogViewer        |
      | Admin            |
