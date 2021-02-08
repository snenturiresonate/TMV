Feature: 34375 - TMV Replay Timetable

  As a TMV User
  I want to view historic timetable during replay
  So that I can view what timetable the train was running to and its historic actuals

  Background:
    Given I load the replay data from scenario '33753-4 - View Timetable (Schedule Matched)'
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill
    And I move the replay to the end of the captured scenario

  @clf @tdd @replayTest
  Scenario: 34375-1 Replay - Open Timetable from Map (colour)
#    Given the user is authenticated to use TMV replay
#    And the user is viewing a map
#    When the user selects a timetable to view
#    Then the timetable is rendered in the same colour as the replay map background
    When I make a note of the main replay map background colour
    And I invoke the context menu on the map for train '1D46'
    And I open timetable from the map context menu
    And I switch to the new tab
    Then the timetable background colour is the same as the map background colour

  @tdd @replayTest
  Scenario: 34375-2 Replay - Open Timetable from Map (contents)
#    Given the user is authenticated to use TMV replay
#    And the user is viewing a map
#    When the user selects a train (occupied berth) from the map using the secondary click
#    And selects the "open timetable" option from the menu
#    Then the train's timetable is opened in a new browser tab
    When I invoke the context menu on the map for train '1D46'
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Replay Timetable 1D46'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM |
      | VAR       |            |            | L77777   |         |         |
    And the navbar punctuality indicator is displayed as 'green'
    And the punctuality is displayed as 'On Time'
    Then a matched service is visible
    And The timetable entries contains the following data
      | location                | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | PADTON                  |                    | 23:33:00        |                   | 23:33:00       | 4                 |                  | 1                |            |            |                 |              |           |          |          |             |
      | ROYAOJN                 |                    | 23:34:00        | 00:00:00          | 00:00:00       |                   |                  | 1                |            |            |                 |              |           |          |          |             |
      | PRTOBJP                 |                    | 23:35:00        | 00:00:00          | 00:00:00       |                   |                  | 1                |            |            |                 |              |           |          |          |             |
      | LDBRKJ                  |                    | 23:35:30        | 00:00:00          | 00:00:00       |                   | 1                | ML               |            |            |                 |              |           |          |          |             |
      | ACTONW Change-en-Route  |                    | 23:38:00        | 00:00:00          | 00:00:00       |                   | ML               | ML               |            |            |                 |              |           |          |          |             |
      | STHALL                  |                    | 23:40:00        | 00:00:00          | 00:00:00       | 1                 |                  | ML               |            |            |                 |              |           |          |          |             |
      | HTRWAJN                 |                    | 23:41:00        | 00:00:00          | 00:00:00       |                   |                  | ML               | (2)        |            |                 |              |           |          |          |             |
      | SLOUGH                  | 23:47:00           | 23:48:30        | 23:47:00          | 23:48:00       | 2                 |                  | ML               | (0.5)      |            |                 |              |           |          |          |             |
      | MDNHEAD                 | 23:53:30           | 23:55:30        | 23:54:00          | 23:55:00       | 1                 |                  | ML               | (0.5)      |            |                 |              |           |          |          |             |
      | TWYFORD                 |                    | 00:01:00        | 00:00:00          | 00:00:00       | 1                 |                  | ML               | [1] (1)    |            |                 |              |           |          |          |             |
      | RDNGKBJ                 |                    | 00:05:00        | 00:00:00          | 00:00:00       |                   |                  | DML              | (0.5)      |            |                 |              |           |          |          |             |
      | RDNGSTN                 | 00:06:30           | 00:10:00        | 00:07:00          | 00:10:00       | 9                 |                  | ML               |            |            |                 |              |           |          |          |             |
      | RDNGHLJ                 |                    | 00:11:00        | 00:00:00          | 00:00:00       |                   |                  | ML               |            |            |                 |              |           |          |          |             |
      | GORASTR                 |                    | 00:16:30        | 00:00:00          | 00:00:00       |                   |                  | ML               | [1] (1)    |            |                 |              |           |          |          |             |
      | DIDCTEJ                 |                    | 00:23:00        | 00:00:00          | 00:00:00       |                   |                  | RL               |            |            |                 |              |           |          |          |             |
      | DIDCOTP Change-en-Route | 00:24:00           | 00:26:00        | 00:24:00          | 00:26:00       | 3                 |                  | DOX              |            |            |                 |              |           |          |          |             |
      | DIDCTNJ                 |                    | 00:28:00        | 00:00:00          | 00:00:00       |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | RDLEY                   | 00:32:30           | 00:34:00        | 00:33:00          | 00:34:00       | 1                 |                  |                  |            |            |                 |              |           |          |          |             |
      | KNNGTNJ                 |                    | 00:37:30        | 00:00:00          | 00:00:00       |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | OXFDUDP                 |                    | 00:40:00        | 00:00:00          | 00:00:00       |                   |                  |                  | [1]        |            |                 |              |           |          |          |             |
      | OXFD                    | 00:43:00           |                 | 00:43:00          |                | 3                 |                  |                  |            |            |                 |              |           |          |          |             |
    And I toggle the inserted locations on
    And The timetable entries contains the following data
      | location                | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | PADTON                  |                    | 23:33:00        |                   | 23:33:00       | 4                 |                  | 1                |            |            |                 |              |           |          |          |             |
      | ROYAOJN                 |                    | 23:34:00        | 00:00:00          | 00:00:00       |                   |                  | 1                |            |            |                 |              |           |          |          |             |
      | PRTOBJP                 |                    | 23:35:00        | 00:00:00          | 00:00:00       |                   |                  | 1                |            |            |                 |              |           |          |          |             |
      | LDBRKJ                  |                    | 23:35:30        | 00:00:00          | 00:00:00       |                   | 1                | ML               |            |            |                 |              |           |          |          |             |
      | [ACTONML]               |                    | 23:37:22        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | ACTONW Change-en-Route  |                    | 23:38:00        | 00:00:00          | 00:00:00       |                   | ML               | ML               |            |            |                 |              |           |          |          |             |
      | [EALINGB]               |                    | 23:38:13        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | [WEALING]               |                    | 23:38:43        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | [HANWELL]               |                    | 23:39:07        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | [STHALEJ]               |                    | 23:39:49        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | STHALL                  |                    | 23:40:55        | 00:00:00          | 00:00:00       | 1                 |                  | ML               |            |            |                 |              |           |          |          |             |
      | [STHALWJ]               |                    | 23:41:00        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | [HANWELL]               |                    | 23:39:07        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | HTRWAJN                 |                    | 23:41:00        | 00:00:00          | 00:00:00       |                   |                  | ML               | (2)        |            |                 |              |           |          |          |             |
      | SLOUGH                  | 23:47:00           | 23:48:30        | 23:47:00          | 23:48:00       | 2                 |                  | ML               | (0.5)      |            |                 |              |           |          |          |             |
      | MDNHEAD                 | 23:53:30           | 23:55:30        | 23:54:00          | 23:55:00       | 1                 |                  | ML               | (0.5)      |            |                 |              |           |          |          |             |
      | TWYFORD                 |                    | 00:01:00        | 00:00:00          | 00:00:00       | 1                 |                  | ML               | [1] (1)    |            |                 |              |           |          |          |             |
      | RDNGKBJ                 |                    | 00:05:00        | 00:00:00          | 00:00:00       |                   |                  | DML              | (0.5)      |            |                 |              |           |          |          |             |
      | RDNGSTN                 | 00:06:30           | 00:10:00        | 00:07:00          | 00:10:00       | 9                 |                  | ML               |            |            |                 |              |           |          |          |             |
      | RDNGHLJ                 |                    | 00:11:00        | 00:00:00          | 00:00:00       |                   |                  | ML               |            |            |                 |              |           |          |          |             |
      | GORASTR                 |                    | 00:16:30        | 00:00:00          | 00:00:00       |                   |                  | ML               | [1] (1)    |            |                 |              |           |          |          |             |
      | DIDCTEJ                 |                    | 00:23:00        | 00:00:00          | 00:00:00       |                   |                  | RL               |            |            |                 |              |           |          |          |             |
      | DIDCOTP Change-en-Route | 00:24:00           | 00:26:00        | 00:24:00          | 00:26:00       | 3                 |                  | DOX              |            |            |                 |              |           |          |          |             |
      | DIDCTNJ                 |                    | 00:28:00        | 00:00:00          | 00:00:00       |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | RDLEY                   | 00:32:30           | 00:34:00        | 00:33:00          | 00:34:00       | 1                 |                  |                  |            |            |                 |              |           |          |          |             |
      | KNNGTNJ                 |                    | 00:37:30        | 00:00:00          | 00:00:00       |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | OXFDUDP                 |                    | 00:40:00        | 00:00:00          | 00:00:00       |                   |                  |                  | [1]        |            |                 |              |           |          |          |             |
      | OXFD                    | 00:43:00           |                 | 00:43:00          |                | 3                 |                  |                  |            |            |                 |              |           |          |          |             |

