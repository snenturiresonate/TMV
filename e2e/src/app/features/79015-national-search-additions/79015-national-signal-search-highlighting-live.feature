@blp
Feature: 79015 - TMV National Search Additions - National Signal Search Highlight Live

  Background:
    * I remove all trains from the trains list

  Scenario Outline:79193-1 National Signal Search Highlight Live - <pageName>
    # Given the user is authenticated to use TMV
    # And the user is viewing the signal search results
    # When the user selects a map from the signal search results
    # Then the user is presented with a map that contains the signal
    # And the berth associated to the signal is highlighted for 10 seconds flashing between green and purple with the letters "SGNL"
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
    Examples:
    | pageName         |
    | Home             |
    | TrainsList       |
    | TimeTable        |
    | TrainsListConfig |
    | Maps             |
    | LogViewer        |
    | Admin            |
