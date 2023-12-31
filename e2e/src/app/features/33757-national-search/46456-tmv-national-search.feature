Feature: 33757 - TMV National Search

  As a TMV dev team member
  I want end to end tests to be created for the National Search functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  @tdd
  Scenario Outline: 33757-1 Train search window shown - Train Search entering trainUid
    #Given the user is authenticated to use TMV
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a train search option (default)
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #Then the trains search results list is displayed with zero or many results
    Given I navigate to <pageName> page
    And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
    And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
    When I search Train for 'A'
    And Warning Message is displayed for minimum characters
    And I search Train for '#'
    And Warning Message is displayed for minimum characters
    And I search Train for '1234567890ABCDEFGH'
    And Warning Message is displayed for minimum characters
    And I search Train for 'A82345'
    Then results are returned with that planning UID 'A82345'
    And the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    And I click close button at the bottom of table
    Then the Train search table is not shown
    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |

    @tdd
  Scenario Outline: 33757-2a Timetable search window shown - Warning message
      #Given the user is authenticated to use TMV
      #And the user is viewing TMV screen with a national search in the title bar
      #When the user selects a timetable search option
      #And the user enters at least two alphanumeric characters
      #And the user submits the search
      #Then the timetable search results list is displayed with zero or many results
      Given I navigate to <pageName> page
      And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
      And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
      When I search Timetable for '1'
      Then Warning Message is displayed for minimum characters
      And I search Timetable for '&'
      And Warning Message is displayed for minimum characters
      And I search Timetable for '1234567890ABCDEFGH'
      And Warning Message is displayed for minimum characters

      Examples:
        |pageName            |
        |Home                |
        |TrainsList          |
        |TimeTable           |
        |Replay              |
        |UserManagement      |
        |TrainsListConfig    |
        |Maps                |
        |LogViewer           |
        |Admin               |

  Scenario Outline: 33757-2b Timetable search - Old Schedules
    Given I navigate to <pageName> page
    And there is a Schedule for '4F01'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | A137657    | P              | 2020-01-01     |
    And the schedule has a Date Run to of 'yesterday'
    And the schedule is received from LINX
    When I search Timetable for 'A137657'
    Then no results are returned with that planning UID 'A137657'

    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |

  Scenario Outline: 33757-2c Timetable search - Future Schedules
    Given I navigate to <pageName> page
    And there is a Schedule for '4F03'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | A337657    | P              | tomorrow       |
    And the schedule is received from LINX
    When I search Timetable for '4F03'
    Then no results are returned with that planning UID 'A337657'

    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |

  Scenario Outline: 33757-2d Timetable search - outside current period
    Given I navigate to <pageName> page
    And there is a Schedule for '4F05'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | A537657    | P              | 2020-01-01     |
    And the schedule does not run on a day that is today
    And the schedule is received from LINX
    When I search Timetable for '4F05'
    Then no results are returned with that planning UID 'A537657'
    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |

    @tdd
  Scenario Outline: 33757-2e Timetable search - all days
    Given I navigate to <pageName> page
    And there is a Schedule for '4F07'
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | A12345     | P              | 2020-01-01     |
    And the schedule has a Date Run to of '2050-01-01'
    And the schedule has a Days Run of all Days
    And the schedule is received from LINX
    When I search Timetable for '4F07'
    Then results are returned with that planning UID 'A12345'

    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |

  @tdd
  Scenario Outline: 33757-3 Signal search window shown
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
    And I search Signal for '1234567890ABCDEFGH'
    And Warning Message is displayed for minimum characters
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    And I click close button at the bottom of table
    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |

  @tdd
  Scenario Outline: 33757-4 Train search window shown - Train Search context menu
    #Given the user is authenticated to use TMV
    #And the user is viewing the train search results pop-up
    #When the user selects a train from search result by using the secondary mouse click
    #Then the user is presented with a menu to either view the timetable or open a map(s) that contains the train
    Given I navigate to <pageName> page
    And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | 0209      | D3 		             | 1F23  		          |
    And I search Train for 'A82345'
    And results are returned with that planning UID 'A82345'
    And the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    And I invoke the context menu from trains '1'
    And I wait for the train search context menu to display
    And the trains context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
    |mapName|
    |GW01   |
    |GW02   |
    |HDGW01 |
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 0209      | 10:02:06  | 0211    | D3             | 1F23             |
    And I invoke the context menu from trains '1'
    And I wait for the train search context menu to display
    Then the trains context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      |mapName|
      |GW01   |
      |GW02   |
      |HDGW01 |
    And I click close button at the bottom of table
    And I search Train for 'A82345'
    And results are returned with that planning UID 'A82345'
    And the Train search table is shown
    And I invoke the context menu from trains '1'
    And I wait for the train search context menu to display
    And the trains context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      |mapName|
      |GW02   |
      |HDGW01 |
    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |

  @tdd
  Scenario Outline:5 National Timetable Search Selection
    #Given the user is authenticated to use TMV
    #And the user is viewing the timetable search results pop-up
    #When the user selects a timetable from search result by using the secondary mouse click
    #Then the user is presented with a menu to either view the timetable or open a map(s) that contains the train (if running)
    Given I navigate to <pageName> page
    And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | 0209      | D3 		             | 1F23  		          |
    And I search Timetable for 'A82345'
    And results are returned with that planning UID 'A82345'
    And the window title is displayed as 'Timetable Search Results'
    And I invoke the context menu from timetable '1'
    And I wait for the train search context menu to display
    And the timetable context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      |mapName|
      |GW01   |
      |GW02   |
      |HDGW01 |
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 0209      | 10:02:06  | 0211    | D3             | 1F23             |
    And I invoke the context menu from timetable '1'
    And I wait for the timetable search context menu to display
    Then the timetable context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      |mapName|
      |GW01   |
      |GW02   |
      |HDGW01 |
    And I click close button at the bottom of table
    And I search Timetable for 'A82345'
    And results are returned with that planning UID 'A82345'
    And I invoke the context menu from timetable '1'
    And I wait for the timetable search context menu to display
    And the timetable context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      |mapName|
      |GW02   |
      |HDGW01 |
    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |

  @tdd
  Scenario Outline:33757-6 National Signal Search Selection
    #Given the user is authenticated to use TMV
    #And the user is viewing the signal search results pop-up
    #When the user selects a train from search result by using the secondary mouse click
    #Then the user is presented with a menu open a map(s) that contains the signal
    Given I navigate to <pageName> page
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    And I invoke the context menu from signal 'SN259'
    And I wait for the signal search context menu to display
    And the signal context menu is displayed
    And the train search context menu contains 'Select maps' on line 1
    And I placed the mouseover on signal map option
    And the following map names can be seen
      |mapName|
      |EA02   |
      |EA2A   |
      |EA03   |

    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |

  @tdd
  Scenario Outline:33757-7 National Trains Search Highlight
    #Given the user is authenticated to use TMV
    #And the user is viewing the train search results
    #When the user selects a map from the train search results
    #Then the user is presented with a map that contains the train
    #And the train is highlighted for a brief period
    Given I navigate to <pageName> page
    And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | 0209      | D3 		             | 1F23  		          |
    And I search Train for 'A82345'
    And results are returned with that planning UID 'A82345'
    And the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    And I invoke the context menu from trains '1'
    And I wait for the train search context menu to display
    And the trains context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      |mapName|
      |GW01   |
      |GW02   |
      |HDGW01 |
    And I open the Map 'GW01'
    And I switch to the new tab
    And I toggle the 'Berth' toggle 'On'
    And the berth '0209' is 'highlighted'
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 0209      | 10:02:06  | 0211    | D3             | 1F23             |
    And I invoke the context menu from trains '1'
    And I wait for the train search context menu to display
    Then the trains context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    And the following map names can be seen
      |mapName|
      |GW01   |
      |GW02   |
      |HDGW01 |
   And I open the Map 'HDGW01'
    And I switch to the new tab
    And I toggle the 'Berth' toggle 'On'
    And the berth '0211' is 'highlighted'
    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |

  @tdd
  Scenario Outline:33757-8 National Signal Search Highlight
    #Given the user is authenticated to use TMV
    #And the user is viewing the signal search results
    #When the user selects a map from the signal search results
    #Then the user is presented with a map that contains the signal
    #And the signal is highlighted for a brief period
    Given I navigate to <pageName> page
    And I search Signal for 'SN259'
    Then results are returned with that signal ID 'SN259'
    And the window title is displayed as 'Signal Search Results'
    And I invoke the context menu from signal 'SN259'
    And I wait for the signal search context menu to display
    And the signal context menu is displayed
    And the train search context menu contains 'Select maps' on line 1
    And I placed the mouseover on signal map option
    And the following map names can be seen
      |mapName|
      |EA02   |
      |EA2A   |
      |EA03   |
    And I open the Map 'EA02'
    And I switch to the new tab
    And the tab title is 'TMV Map EA02'
    And the signal 'SN254' is 'highlighted'
    Examples:
      |pageName            |
      |Home                |
      |TrainsList          |
      |TimeTable           |
      |Replay              |
      |UserManagement      |
      |TrainsListConfig    |
      |Maps                |
      |LogViewer           |
      |Admin               |
