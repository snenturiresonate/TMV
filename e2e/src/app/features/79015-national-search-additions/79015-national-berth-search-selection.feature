@TMVPhase2 @P2.S2
@newSession
Feature: 79015 - TMV National Search Additions - National Berth Search Selection

  Background:
    * I remove all trains from the trains list

  Scenario Outline:79190-1,79191-1 National Berth Search Highlight Live
#    Given the user is authenticated to use TMV
#    And the user is viewing the berth search results pop-up
#    When the user selects a berth from search result by using the secondary mouse click
#    Then the user is presented with a menu to open a map(s) that contains the berth
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
    Examples:
      | pageName         |
      | Home             |
