Feature: 33757 - TMV National Search

  As a TMV dev team member
  I want end to end tests to be created for the National Search functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  @tdd
  Scenario Outline: Train search window shown - Train Search entering trainUid
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
