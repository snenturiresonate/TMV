Feature: 33750 - TMV Timetable

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
    And the trains list context menu is not displayed
    When I invoke the context menu from train <trainNum> on the trains list
    And I wait for the context menu to display
    And I open timetable from the context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | trainNum |
      | 1        |

  #Scenario Outline: Scenario 2 -Open Timetable (Trains List)
    #Open Timetable (Map)
    #Given the user is authenticated to use TMV
    #And the user is viewing a map
    #When the user selects a train (occupied berth) from the map using the secondary click
    #And selects the "open timetable" option from the menu
    #Then the train's timetable is opened in a new browser tab
    #Given I am viewing the map HDGW01paddington.v
    #When I invoke the context menu from train <trainNum> on the map
    #And I wait for the context menu to display
    #And I open timetable from the context menu
    #And I switch to the new tab
    #And the tab title is 'TMV Timetable'
    #Examples:
     # | trainNum |
     # | 1        |
