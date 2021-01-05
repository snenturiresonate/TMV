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
  Scenario Outline: Scenario 2 -#Open Timetable (Map)
    #Given the user is authenticated to use TMV
    #And the user is viewing a map
    #When the user selects a train (occupied berth) from the map using the secondary click
    #And selects the "open timetable" option from the menu
    #Then the train's timetable is opened in a new browser tab
    Given I am viewing the map HDGW01paddington.v
    #When I invoke the context menu from train <trainNum> on the map
    And I wait for the context menu to display
    And I open timetable from the context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | trainNum |
      | 1        |

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
      |trainNum|
      | 1      |

  Scenario: Scenario 4 - View Timetable (Schedule Matched)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is schedule matched
    #When the user is viewing the timetable
    #Then the train's schedule is displayed with any predicted and live running information and header information
    Given I am on the live timetable page with schedule id '2C34'
    When The timetable table tab is visible
    And The timetable entries contains the following data
      | entryId | location               | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1       | NuneatonTest           |                    | 11:11:30        |                   |                | 2                 | D2               | RL               | [2] <1>    |            |                 |              |           | D2       |          | +1m 40s     |
      | 4       | Rugby Trent Valley Jn  |                    | 11:21:30        |                   |                |                   |                  |                  | [2] <1>    |            |                 |              |           |          |          | +1m 3s      |
      | 7       | Rugby\nChange-en-Route | 11:23:30           | 11:25:30        | 11:23             | 11:25          | 2                 | D2               | RL               | [2] <1>    | T          | 11:23:30        | 11:25:30     | 2         | D2       | RL       | +1m         |
      | 13      | Oxford                 | 11:33:30           | 11:35:30        | 11:33             | 11:35          | 2                 | D2               | RL               | [2] <1>    | T          | 11:33:30        | 11:35:30     | 2         | D2       | RL       | +1m         |
    When I toggle the inserted locations on
    Then The timetable entries contains the following data
      | entryId | location               | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1       | NuneatonTest           |                    | 11:11:30        |                   |                | 2                 | D2               | RL               | [2] <1>    |            |                 |              |           | D2       |          | +1m 40s     |
      | 4       | Rugby Trent Valley Jn  |                    | 11:21:30        |                   |                |                   |                  |                  | [2] <1>    |            |                 |              |           |          |          | +1m 3s      |
      | 7       | Rugby\nChange-en-Route | 11:23:30           | 11:25:30        | 11:23             | 11:25          | 2                 | D2               | RL               | [2] <1>    | T          | 11:23:30        | 11:25:30     | 2         | D2       | RL       | +1m         |
      | 10      | [Marylebone]           |                    |                 |                   |                |                   |                  |                  |            |            | 11:31:30        | 11:32:30     | 2         | D2       | RL       |             |
      | 13      | Oxford                 | 11:33:30           | 11:35:30        | 11:33             | 11:35          | 2                 | D2               | RL               | [2] <1>    | T          | 11:33:30        | 11:35:30     | 2         | D2       | RL       | +1m         |
      | 16      | [Reading]              |                    |                 |                   |                |                   |                  |                  |            |            | (11:43:30)      | (11:44:30)   | 2         | D2       | RL       |             |

  Scenario: Scenario - 5 View Timetable (Not Schedule Matched)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is not schedule matched
    #When the user is viewing the timetable
    #Then the train's blank schedule is displayed with basic header information
    Given I am on the live timetable page with schedule id '2C34'
    When The timetable table tab is visible
    And The timetable header contains the following property labels:
      | property       |
      | Schedule Type: |
      | Train UID:     |
      | Signal:        |
      | Trust ID:      |
      | Last Reported: |
      | Last TJM:      |
    And The timetable entries contains the following data
      | entryId | location               | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1       | NuneatonTest           |                    | 11:11:30        |                   |                | 2                 | D2               | RL               | [2] <1>    |            |                 |              |           | D2       |          | +1m 40s     |
      | 4       | Rugby Trent Valley Jn  |                    | 11:21:30        |                   |                |                   |                  |                  | [2] <1>    |            |                 |              |           |          |          | +1m 3s      |
      | 7       | Rugby\nChange-en-Route | 11:23:30           | 11:25:30        | 11:23             | 11:25          | 2                 | D2               | RL               | [2] <1>    | T          | 11:23:30        | 11:25:30     | 2         | D2       | RL       | +1m         |
      | 13      | Oxford                 | 11:33:30           | 11:35:30        | 11:33             | 11:35          | 2                 | D2               | RL               | [2] <1>    | T          | 11:33:30        | 11:35:30     | 2         | D2       | RL       | +1m         |
    When I toggle the inserted locations on
    Then The timetable entries contains the following data
      | entryId | location               | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1       | NuneatonTest           |                    | 11:11:30        |                   |                | 2                 | D2               | RL               | [2] <1>    |            |                 |              |           | D2       |          | +1m 40s     |
      | 4       | Rugby Trent Valley Jn  |                    | 11:21:30        |                   |                |                   |                  |                  | [2] <1>    |            |                 |              |           |          |          | +1m 3s      |
      | 7       | Rugby\nChange-en-Route | 11:23:30           | 11:25:30        | 11:23             | 11:25          | 2                 | D2               | RL               | [2] <1>    | T          | 11:23:30        | 11:25:30     | 2         | D2       | RL       | +1m         |
      | 10      | [Marylebone]           |                    |                 |                   |                |                   |                  |                  |            |            | 11:31:30        | 11:32:30     | 2         | D2       | RL       |             |
      | 13      | Oxford                 | 11:33:30           | 11:35:30        | 11:33             | 11:35          | 2                 | D2               | RL               | [2] <1>    | T          | 11:33:30        | 11:35:30     | 2         | D2       | RL       | +1m         |
      | 16      | [Reading]              |                    |                 |                   |                |                   |                  |                  |            |            | (11:43:30)      | (11:44:30)   | 2         | D2       | RL       |             |
    When I toggle the inserted locations off
    Then The timetable entries contains the following data
      | entryId | location               | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1       | NuneatonTest           |                    | 11:11:30        |                   |                | 2                 | D2               | RL               | [2] <1>    |            |                 |              |           | D2       |          | +1m 40s     |
      | 4       | Rugby Trent Valley Jn  |                    | 11:21:30        |                   |                |                   |                  |                  | [2] <1>    |            |                 |              |           |          |          | +1m 3s      |
      | 7       | Rugby\nChange-en-Route | 11:23:30           | 11:25:30        | 11:23             | 11:25          | 2                 | D2               | RL               | [2] <1>    | T          | 11:23:30        | 11:25:30     | 2         | D2       | RL       | +1m         |
      | 13      | Oxford                 | 11:33:30           | 11:35:30        | 11:33             | 11:35          | 2                 | D2               | RL               | [2] <1>    | T          | 11:33:30        | 11:35:30     | 2         | D2       | RL       | +1m         |

