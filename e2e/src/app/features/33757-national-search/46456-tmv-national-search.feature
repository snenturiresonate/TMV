Feature: 33757 - TMV National Search

  As a TMV dev team member
  I want end to end tests to be created for the National Search functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  @tdd
  Scenario Outline: Scenario1 Train search window shown - Train Search entering trainUid
    #Given the user is authenticated to use TMV
    #And the user is viewing TMV screen with a national search in the title bar
    #When the user selects a train search option (default)
    #And the user enters at least two alphanumeric characters
    #And the user submits the search
    #Then the trains search results list is displayed with zero or many results
    Given I navigate to <pageName> page
    And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
    And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
    When I search Train for '<trainUid>'
    Then results are returned with that planning UID '<trainUid>'
    And the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    And I click close button at the bottom of table
    Then the Train search table is not shown

    Examples:
      |pageName            |trainUid|
      |Home                |A82345  |
      |TrainsList          |        |
      |TimeTable           |        |
      |Replay              |        |
      |UserManagement      |        |
      |TrainsListConfig    |        |
      |Maps                |        |
      |LogViewer           |        |
      |Admin               |        |

    @tdd
  Scenario Outline: Timetable search window shown - Search by entering trainUid
      #Given the user is authenticated to use TMV
      #And the user is viewing TMV screen with a national search in the title bar
      #When the user selects a timetable search option
      #And the user enters at least two alphanumeric characters
      #And the user submits the search
      #Then the timetable search results list is displayed with zero or many results
      Given I navigate to <pageName> page
      And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
      And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
      When I search Timetable for '<trainUid>'
      Then results are returned with that planning UID '<trainUid>'
      And the Train search table is shown
      And the window title is displayed as 'Timetable Search Results'
      And I click on the Search icon
      And the Train search table is shown
      And I click close button at the bottom of table
      And the Train search table is not shown

    Examples:
      |pageName            |trainUid|
      |Home                |A82345  |
      |TrainsList          |        |
      |TimeTable           |        |
      |Replay              |        |
      |UserManagement      |        |
      |TrainsListConfig    |        |
      |Maps                |        |
      |LogViewer           |        |
      |Admin               |        |

  @tdd
  Scenario Outline: 4 Train search window shown - Train Search context menu
    #Given the user is authenticated to use TMV
    #And the user is viewing the train search results pop-up
    #When the user selects a train from search result by using the secondary mouse click
    #Then the user is presented with a menu to either view the timetable or open a map(s) that contains the train
    Given I navigate to <pageName> page
    And the Train Search Box has the value 'Train Desc, Trust ID, Planning UID'
    And the access plan located in CIF file 'access-plan/schedules_BS_type_O.cif' is received from LINX
    And I search Train for '<trainUid>'
    And results are returned with that planning UID '<trainUid>'
    And the Train search table is shown
    And the window title is displayed as 'Train Search Results'
    When I invoke the context menu from trains <trainNum>
    And I wait for the train search context menu to display
    Then the trains context menu is displayed
    And the train search context menu contains 'Open timetable' on line 1
    And the train search context menu contains 'Select maps' on line 2
    Examples:
      |pageName            |trainUid|trainNum|
      |Home                |A82345  |1       |
      |TrainsList          |        |        |
      |TimeTable           |        |        |
      |Replay              |        |        |
      |UserManagement      |        |        |
      |TrainsListConfig    |        |        |
      |Maps                |        |        |
      |LogViewer           |        |        |
      |Admin               |        |        |

