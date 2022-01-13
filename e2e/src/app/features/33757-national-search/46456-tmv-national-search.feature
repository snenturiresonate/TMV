Feature: 33757 - TMV National Search

  As a TMV dev team member
  I want end to end tests to be created for the National Search functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  Background:
    * I remove all trains from the trains list

  Scenario Outline: 33757-1a Train search window shown - Train Search entering trainUid - <pageName>
    #Given the user is authenticated to use TMV
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a train search option (default)
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #Then the trains search results list is displayed with zero or many results
    Given I navigate to <pageName> page
    And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
    And the access plan located in CIF file 'access-plan/1L24_PADTON_RDNGSTN.cif' is received from LINX
    And I wait until today's train 'A12345' has loaded
    And I give the timetable an extra 2 seconds to load
    And the following live berth interpose message is sent from LINX (to create a match)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | 1L24             |
    And I am viewing the map HDGW01paddington.v
    And berth 'A007' in train describer 'D3' contains '1L24' and is visible
    And I wait for the Open timetable option for train description 1L24 in berth A007, describer D3 to be available
    And I navigate to <pageName> page
    And I refresh the Elastic Search indices
    And I search Train for 'A'
    And Warning Message is displayed for minimum characters
    And I search Train for '#'
    And Warning Message is displayed for minimum characters
    When I search Train for '1L24' and wait for result
      | PlanningUid |
      | A12345      |
    And the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    And I click close button at the bottom of table
    Then the Train search table is not shown
    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

  Scenario: 33757-1b Train search window shown - Train Search entering trainUid - Replay page
    Given the access plan located in CIF file 'access-plan/1L24_PADTON_RDNGSTN.cif' is received from LINX
    And the following live berth interpose message is sent from LINX (to create a match)
      | toBerth | trainDescriber | trainDescription |
      | R029    | D3             | 1L24             |
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I click Skip forward button '4' times
    And I click Play button
    And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
    When I search Train for 'A'
    And Warning Message is displayed for minimum characters
    And I search Train for '#'
    And Warning Message is displayed for minimum characters
    When I search Train for '1L24' and wait for result
      | PlanningUid |
      | A12345      |
    And the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    And I click close button at the bottom of table
    Then the Train search table is not shown

  Scenario Outline: 33757-2a Timetable search window shown - Warning message - <pageName>
      #Given the user is authenticated to use TMV
      #And the user is viewing TMV screen with a national search in the title bar
      #When the user selects a timetable search option
      #And the user enters at least two alphanumeric characters
      #And the user submits the search
      #Then the timetable search results list is displayed with zero or many results
    * I remove today's train 'A12345' from the Redis trainlist
    Given I navigate to <pageName> page
    And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
    And the access plan located in CIF file 'access-plan/1L24_PADTON_RDNGSTN.cif' is received from LINX
    And I wait until today's train 'A12345' has loaded
    And I navigate to <pageName> page
    When I search Timetable for '1'
    Then Warning Message is displayed for minimum characters
    And I search Timetable for '&'
    And Warning Message is displayed for minimum characters

    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

  Scenario: 33757-2b Timetable search window shown - Warning message- Replay page
    Given the access plan located in CIF file 'access-plan/1L24_PADTON_RDNGSTN.cif' is received from LINX
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
    When I search Timetable for '1'
    Then Warning Message is displayed for minimum characters
    When I search Timetable for '&'
    Then Warning Message is displayed for minimum characters
    When I search Timetable for '£'
    Then Warning Message is displayed for minimum characters

  Scenario Outline: 33757-2c Timetable search - Old Schedules - <pageName>
    #
    Given I navigate to <pageName> page
    And there is a Schedule for '4F01'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid | stpIndicator | dateRunsFrom |
      | A137657  | P            | 2020-01-01   |
    And the schedule has a Date Run to of 'yesterday'
    And the schedule is received from LINX
    When I search Timetable for 'A137657'
    Then no results are returned with that planning UID 'A137657'

    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

  Scenario Outline: 33757-2d Timetable search - Future Schedules - <pageName>
    Given I navigate to <pageName> page
    And there is a Schedule for '4F03'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid | stpIndicator | dateRunsFrom |
      | A337657  | P            | tomorrow     |
    And the schedule is received from LINX
    When I search Timetable for '4F03'
    Then no results are returned with that planning UID 'A337657'

    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

  Scenario Outline: 33757-2e Timetable search - outside current period - <pageName>
    Given I navigate to <pageName> page
    And there is a Schedule for '4F05'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid | stpIndicator | dateRunsFrom |
      | A53765   | P            | 2020-01-01   |
    And the schedule does not run on a day that is today
    And the schedule is received from LINX
    When I search Timetable for '4F05'
    Then no results for today's train description '4F05' with planning UID 'A53765' are found
    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

  Scenario Outline: 33757-2f Timetable search - all days - <pageName>
    * I remove today's train 'F10001' from the Redis trainlist
    Given I navigate to <pageName> page
    #And there is a Schedule for '4F07'
    #And the schedule has schedule identifier characteristics
    #  | trainUid   | stpIndicator   | dateRunsFrom   |
    #  | B12345     | P              | 2020-01-01     |
    #And the schedule has a Date Run to of '2050-01-01'
    #And the schedule has a Days Run of all Days
    #And the schedule is received from LINX
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 4F07                | F10001         |
    And I wait until today's train 'F10001' has loaded
    And I navigate to <pageName> page
    When I search Timetable for '4F07' and wait for result
      | PlanningUid | Scheduletype  |
      | F10001      | LTP           |
    Then results are returned with that planning UID 'F10001'

    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

  Scenario Outline: 33757-3a Signal search window shown - <pageName>
      #Given the user is authenticated to use TMV
      #And the user is viewing TMV screen with a national search in the title bar
      #When the user selects a signal search option
      #And the user enters at least two alphanumeric characters
      #And the user submits the search
      #Then the signal search results list is displayed with zero or many results
    Given I navigate to <pageName> page
    And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
    When I search Signal for 'A'
    And Warning Message is displayed for minimum characters
    And I search Signal for '#'
    And Warning Message is displayed for minimum characters
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    And I click close button at the bottom of table
    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

  Scenario: 33757-3b Signal search window shown- Replay page
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
    When I search Signal for 'A'
    And Warning Message is displayed for minimum characters
    And I search Signal for '#'
    And Warning Message is displayed for minimum characters
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    And I click close button at the bottom of table

  Scenario Outline: 33757-4 Train search window shown - Train Search context menu - <pageName>
    #Given the user is authenticated to use TMV
    #And the user is viewing the train search results pop-up
    #When the user selects a train from search result by using the secondary mouse click
    #Then the user is presented with a menu to either view the timetable or open a map(s) that contains the train
    * I remove today's train 'A12345' from the Redis trainlist
    Given I navigate to <pageName> page
    And the access plan located in CIF file 'access-plan/1L24_PADTON_RDNGSTN.cif' is received from LINX
    And I wait until today's train 'A12345' has loaded
    And the following live berth interpose message is sent from LINX (to create a match)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | 1L24             |
    And the following live berth step message is sent from LINX (to move train)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | A007      | 0039    | D3             | 1L24             |
    And I am viewing the map HDGW01paddington.v
    And berth '0039' in train describer 'D3' contains '1L24' and is visible
    And I wait for the Open timetable option for train description 1L24 in berth 0039, describer D3 to be available
    And I navigate to <pageName> page
    And I give the train 2 seconds to load
    And I refresh the Elastic Search indices
    When I search Train for '1L24' and wait for result
      | PlanningUid |
      | A12345      |
    And results are returned with that planning UID 'A12345'
    And the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    And I invoke the context menu from train with planning UID 'A12345' on the search results table
    And I wait for the train search context menu to display
    And the trains context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      | mapName |
      | GW01    |
      | HDGW01  |
    And the following live berth step message is sent from LINX (to move train)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | A007      | 0039    | D3             | 1L24             |
    And I invoke the context menu from train with planning UID 'A12345' on the search results table
    And I wait for the train search context menu to display
    Then the trains context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      | mapName |
      | GW01    |
      | HDGW01  |
    And I click close button at the bottom of table
    When I search Train for 'A12345' and wait for result
      | PlanningUid |
      | A12345      |
    And the Train search table is shown
    And I invoke the context menu from train with planning UID 'A12345' on the search results table
    And I wait for the train search context menu to display
    And the trains context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      | mapName |
      | GW01    |
      | HDGW01  |
    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

  Scenario Outline:5 National Timetable Search Selection - <pageName>
    #Given the user is authenticated to use TMV
    #And the user is viewing the timetable search results pop-up
    #When the user selects a timetable from search result by using the secondary mouse click
    #Then the user is presented with a menu to either view the timetable or open a map(s) that contains the train (if running)
    Given I navigate to <pageName> page
    And the access plan located in CIF file 'access-plan/1L24_PADTON_RDNGSTN.cif' is received from LINX
    And the following live berth interpose message is sent from LINX (to create a match)
      | toBerth | trainDescriber | trainDescription |
      | R029    | D3             | 1L24             |
    When I search Timetable for 'A12345' and wait for result
      | TrainDesc | PlanningUid | Scheduletype  | StartDate |
      | 1L24      | A12345      | VAR           | today     |
    And results are returned with that planning UID 'A12345'
    And the window title is displayed as 'Timetable Search Results'
    And I invoke the context menu from train with planning UID 'A12345' and schedule date 'today' from the search results
    And I wait for the timetable search context menu to display
    And the timetable context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      | mapName |
      | GW01    |
      | HDGW01  |
    And the following live berth interpose message is sent from LINX (to move train)
      | toBerth | trainDescriber | trainDescription |
      | 0032    | D3             | 1L24             |
    And I invoke the context menu from train with planning UID 'A12345' and schedule date 'today' from the search results
    And I wait for the timetable search context menu to display
    Then the timetable context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      | mapName |
      | GW01    |
      | HDGW01  |
    And I click close button at the bottom of table
    When I search Timetable for 'A12345' and wait for result
      | TrainDesc | PlanningUid | Scheduletype  | StartDate |
      | 1L24      | A12345      | VAR           | today     |
    And results are returned with that planning UID 'A12345'
    And I invoke the context menu from train with planning UID 'A12345' and schedule date 'today' from the search results
    And I wait for the timetable search context menu to display
    And the timetable context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      | mapName |
      | GW01    |
      | HDGW01  |
    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

  Scenario Outline:33757-6 National Signal Search Selection - <pageName>
    #Given the user is authenticated to use TMV
    #And the user is viewing the signal search results pop-up
    #When the user selects a train from search result by using the secondary mouse click
    #Then the user is presented with a menu open a map(s) that contains the signal
    Given I navigate to <pageName> page
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    And I invoke the context menu for signal with ID 'SN259'
    And I wait for the signal search context menu to display
    And the signal context menu is displayed
    And the train search context menu contains 'Select maps' on line 1
    And I placed the mouseover on signal map option
    And the following signal map names can be seen
      | mapName |
      | GW02    |
      | HDGW01  |

    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

  Scenario Outline:33757-7 National Trains Search Highlight - <pageName>
    #Given the user is authenticated to use TMV
    #And the user is viewing the train search results
    #When the user selects a map from the train search results
    #Then the user is presented with a map that contains the train
    #And the train is highlighted for a brief period
    Given I navigate to <pageName> page
    And the access plan located in CIF file 'access-plan/1L24_PADTON_RDNGSTN.cif' is received from LINX
    When the following live berth interpose message is sent from LINX (to create a match)
      | toBerth | trainDescriber | trainDescription |
      | R029    | D3             | 1L24             |
    When I search Train for 'A12345' and wait for result
      | PlanningUid |
      | A12345      |
    And the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    And I invoke the context menu from train with planning UID 'A12345' on the search results table
    And I wait for the train search context menu to display
    And the trains context menu is displayed
    And the train search context menu contains 'Open Timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      | mapName |
      | GW01    |
      | HDGW01  |
    And I open the Map 'GW01'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the train in berth D3R029 is highlighted on page load
    And berth 'R029' in train describer 'D3' contains '1L24' and is visible
    And I click on the layers icon in the nav bar
    And I toggle the 'Berth' toggle 'On'
    Then the train in berth D3R029 is highlighted on page load
    And berth 'R029' in train describer 'D3' contains 'R029' and is visible
    Examples:
      | pageName         |
      | Home             |
      | TrainsList       |
      | TimeTable        |
      | Maps             |
      | LogViewer        |
      | Admin            |

