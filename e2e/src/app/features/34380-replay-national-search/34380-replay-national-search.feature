@newSession
Feature: 34380 - TMV Replay National Search

  As a TMV User
  I want the ability to search for schematic objects, trains and schedules within a replay session
  So that I can focus on a particular area of the railway or train

  Background:
    * I have not already authenticated
    * I remove today's train 'L10006' from the trainlist
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

  Scenario: 34380-1a Train search window shown - Train Search entering trainUid
    #Given the user is authenticated to use TMV replay
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a train search option (default)
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #Then the trains search results list is displayed with zero or many results
    Given I search Train for 'A'
    Then Warning Message is displayed for minimum characters
    When I search Train for '#'
    Then Warning Message is displayed for minimum characters
    When I search Train for 'L10006' and wait for result
      | PlanningUid |
      | L10006      |
    Then the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    And I click close button at the bottom of table
    And the Train search table is not shown

  Scenario: 33757-2a Timetable search window shown - Warning message
    #Given the user is authenticated to use TMV replay
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a timetable search option
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #Then the timetable search results list is displayed with zero or many results
    Given I search Timetable for '1'
    Then Warning Message is displayed for minimum characters
    When I search Timetable for '&'
    Then Warning Message is displayed for minimum characters

  Scenario: 33757-2b Timetable search - all days
    Given I search Timetable for '1A06'
    Then results are returned with that planning UID 'L10006'

  Scenario: 33757-3 Signal search window shown
    #Given the user is authenticated to use TMV replay
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a signal search option
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #Then the signal search results list is displayed with zero or many results
    Given I search Signal for 'A'
    Then Warning Message is displayed for minimum characters
    When I search Signal for '#'
    Then Warning Message is displayed for minimum characters
    When I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    And I click close button at the bottom of table

  Scenario: 33757-4 Berth search window shown
    #Given the user is authenticated to use TMV replay
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a signal search option
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #Then the signal search results list is displayed with zero or many results
    Given I search Berth for 'A'
    Then Warning Message is displayed for minimum characters
    When I search Berth for '#'
    Then Warning Message is displayed for minimum characters
    When I search Berth for 'A001'
    Then results are returned with that signal ID 'A001'
    And the window title is displayed as 'Berth Search Results'
    And I click close button at the bottom of table

  Scenario: 34380-4 National Train Search Selection
    #Given the user is authenticated to use TMV replay
    #And the user is viewing the train search results pop-up
    #When the user selects a train from search result by using the secondary mouse click
    #Then the user is presented with a menu to either view the timetable or open a map(s) that contains the train
    When I search Train for 'L10006' and wait for result
      | PlanningUid |
      | L10006      |
    And the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    When I invoke the context menu from train with planning UID 'L10006' and schedule date 'today' from the search results
    And I wait for the train search context menu to display
    And the trains context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select Maps' on line 2
    Then the following map names can be seen
      | mapName |
      | GW2A    |

  Scenario: 34380-5 National Timetable Search Selection
    # Given the user is authenticated to use TMV replay
    # And the user is viewing the timetable search results pop-up
    # When the user selects a timetable from search result by using the secondary mouse click
    # Then the user is presented with a menu to either view the timetable or open a map(s) that contains the train (if running)
    Given I search Timetable for 'L10006' and wait for result
      | PlanningUid |
      | L10006      |
    Then results are returned with that planning UID 'L10006'
    And the timetable search table is shown
    And the window title is displayed as 'Timetable Search Results'
    When I invoke the context menu from train with planning UID 'L10006' and schedule date 'today' from the search results
    And I wait for the timetable search context menu to display
    Then the timetable context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select Maps' on line 2
    And the following map names can be seen
      |mapName|
      |GW2A   |

  Scenario: 34380-6 National Signal Search Selection
    # Given the user is authenticated to use TMV replay
    # And the user is viewing the signal search results pop-up
    # When the user selects a train from search result by using the secondary mouse click
    # Then the user is presented with a menu open a map(s) that contains the signal
    Given I search Signal for 'SN15'
    And the signal search table is shown
    And the window title is displayed as 'Signal Search Results'
    And I invoke the context menu for signal with ID 'SN15'
    And I wait for the signal search context menu to display
    And the signal context menu is displayed
    And the 'signal' search context menu contains 'Select Maps' on line 1
    Then the following map names can be seen for the signal
      |mapName|
      |HDGW01 |
      |GW01   |

  @manual @manual:93513
  @flaky
  Scenario: 34380-7 National Train Search Highlight
    # Given the user is authenticated to use TMV replay
    # And the user is viewing the train search results
    # When the user selects a map from the train search results
    # Then the user is presented with a map that contains the train
    # And the train is highlighted for a brief period
    Given I search Train for 'L10006' and wait for result
      | PlanningUid |
      | L10006      |
    Then the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    When I invoke the context menu from train with planning UID 'L10006' and schedule date 'today' from the search results
    And I wait for the train search context menu to display
    Then the trains context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select Maps' on line 2
    When I open the Map 'GW2A'
    And I switch to the new tab
    And the tab title is 'TMV Replay GW2A'
    Then the train in berth D60519 is highlighted on page load
