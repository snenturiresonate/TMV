Feature: 33753 - TMV Timetable

  As a TMV dev team member
  I want end to end tests to be created for the Timetable functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  Scenario Outline: Scenario 1 -Open Timetable (Trains List)
     #Open Timetable (Trains List)
     #Given the user is authenticated to use TMV
     #And the user is viewing the trains list
     #When the user selects a train from the trains list using the secondary mouse click
     #And selects the "open timetable" option from the menu
     #Then the train's timetable is opened in a new browser tab
    Given I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu from train <trainNum> on the trains list
    And I wait for the context menu to display
    And the trains list context menu is displayed
    And I open timetable from the context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | trainNum |
      | 1        |

  @tdd
  Scenario Outline: Scenario 2 -Open Timetable (Map)
    #Given the user is authenticated to use TMV
    #And the user is viewing a map
    #When the user selects a train (occupied berth) from the map using the secondary click
    #And selects the "open timetable" option from the menu
    #Then the train's timetable is opened in a new browser tab
    Given I am viewing the map HDGW01paddington.v
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber | trainDescription |
      | 09:59:00  | 0099    | D3             | <trainNum>       |
    When I invoke the context menu on the map for train <trainNum>
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | trainNum |
      | 1G69     |

  Scenario Outline: Scenario - 3 Open Timetable (Search Result - Train, Timetable & Manual Match Search Results)
    #Given the user is authenticated to use TMV
    #And the user is viewing a search results list
    #When the user selects a train search result using the secondary click
    #And selects the "open timetable" option from the menu
    #Then the train's timetable is opened in a new browser tab
    Given I am on the home page
    When I click on the Train search
    When the user enter the value 'IT55'
    And I click on the Search icon
    Then the Train search table is shown
    And I invoke the context menu from trains <trainNum>
    And I wait for the train search context menu to display
    And the trains context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And I click on timetable link
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | trainNum |
      | 1        |
