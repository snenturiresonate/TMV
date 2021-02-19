Feature: 34375 - TMV Replay Timetable

  As a TMV User
  I want to view historic timetable during replay
  So that I can view what timetable the train was running to and its historic actuals

  Background:
    Given I load the replay data from scenario '33753-4 - View Timetable (Schedule Matched - Trains List)'
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw02reading.v'
    And I have set replay time and date from the recorded session
    And I select Start
    And I wait for the buffer to fill


  @tdd @replayTest
  Scenario: 34375-1 Replay - Open Timetable from Map (colour)
#    Given the user is authenticated to use TMV replay
#    And the user is viewing a map
#    When the user selects a timetable to view
#    Then the timetable is rendered in the same colour as the replay map background
    When I move the replay to the end of the captured scenario
    And I make a note of the main replay map background colour
    And I invoke the context menu on the map for train '2K33'
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
    When I select skip forward to just after replay scenario step '1'
    And I invoke the context menu on the map for train '2K33'
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Replay Timetable 2K33'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       |            |            | L66666   |         |         | 2K33     |

  @tdd @replayTest
  Scenario Outline: 34375-3 Replay - Open Timetable from Search Results
#    Given the user is authenticated to use TMV replay
#    And the user is viewing a search results list
#    When the user selects a train search result using the secondary click
#    And selects the "open timetable" option from the menu
#    Then the train's timetable is opened in a new browser tab
    When I move the replay to the end of the captured scenario
    And I search <searchType> for '2K33'
    And results are returned with that planning UID 'L66666'
    And I invoke the context menu from train with planning UID 'L66666' on the search results table
    And I click on timetable link
    And I switch to the new tab
    Then the tab title is 'TMV Replay Timetable 2K33'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       |            |            | L66666   |         |         | 2K33     |

    Examples:
      | searchType |
      | Train      |
      | Timetable  |

  @tdd @replayTest
  Scenario: 34375-4 Replay - View Timetable (Schedule Matched)
#    Given the user is authenticated to use TMV replay
#    And the user has opened a timetable
#    And the train is schedule matched
#    When the user is viewing the timetable
#    Then the train's schedule is displayed with any predicted and live running information and header information
    When I search Timetable for 'L66666'
    And I invoke the context menu from train with planning UID 'L66666' on the search results table
    And I click on timetable link
    And I switch to the new tab
    Then the tab title is 'TMV Replay Timetable 2K33'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       |            |            | L66666   |         |         | 2K33     |
    And the navbar punctuality indicator is displayed as 'green'
    And the punctuality is displayed as 'On Time'
    And The timetable entries contains the following data, with timings having recorded offset from '33753-4 - View Timetable (Schedule Matched - Trains List)' at '23:47:00'
      | location                | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | PADTON                  |                    | 23:33:00        |                   | 23:33:00       | 4                 |                  | 1                |            | TB         |                 |              |           |          |          |             |
      | ROYAOJN                 |                    | 23:34:00        | 00:00:00          | 00:00:00       |                   |                  | 1                |            |            |                 |              |           |          |          |             |
      | PRTOBJP                 |                    | 23:35:00        | 00:00:00          | 00:00:00       |                   |                  | 1                |            |            |                 |              |           |          |          |             |
      | LDBRKJ                  |                    | 23:35:30        | 00:00:00          | 00:00:00       |                   | 1                | ML               |            |            |                 |              |           |          |          |             |
      | ACTONW\nChange-en-Route |                    | 23:38:00        | 00:00:00          | 00:00:00       |                   | ML               | ML               |            |            |                 |              |           |          |          |             |
      | STHALL                  |                    | 23:40:00        | 00:00:00          | 00:00:00       | 1                 |                  | ML               |            |            |                 |              |           |          |          |             |
      | HTRWAJN                 |                    | 23:41:00        | 00:00:00          | 00:00:00       |                   |                  | ML               | <2>        |            |                 |              |           |          |          |             |
      | SLOUGH                  | 23:47:00           | 23:48:30        | 23:47:00          | 23:48:00       | 2                 |                  | ML               | (0.5)      | T          |                 |              |           |          |          |             |
      | MDNHEAD                 | 23:53:30           | 23:55:30        | 23:54:00          | 23:55:00       | 1                 |                  | ML               | [0.5]      | T          |                 |              |           |          |          |             |
      | TWYFORD                 |                    | 00:01:00        | 00:00:00          | 00:00:00       | 1                 |                  | ML               | [1] (1)    |            |                 |              |           |          |          |             |
      | RDNGKBJ                 |                    | 00:05:00        | 00:00:00          | 00:00:00       |                   |                  | DML              | [0.5]      |            |                 |              |           |          |          |             |
      | RDNGSTN                 | 00:06:30           | 00:10:00        | 00:07:00          | 00:10:00       | 9                 |                  | ML               |            | T          |                 |              |           |          |          |             |
      | RDNGHLJ                 |                    | 00:11:00        | 00:00:00          | 00:00:00       |                   |                  | ML               |            |            |                 |              |           |          |          |             |
      | GORASTR                 |                    | 00:16:30        | 00:00:00          | 00:00:00       |                   |                  | ML               | [1] (1)    |            |                 |              |           |          |          |             |
      | DIDCTEJ                 |                    | 00:23:00        | 00:00:00          | 00:00:00       |                   |                  | RL               |            |            |                 |              |           |          |          |             |
      | DIDCOTP                 | 00:24:00           | 00:26:00        | 00:24:00          | 00:26:00       | 3                 |                  | DOX              |            | T          |                 |              |           |          |          |             |
      | DIDCTNJ                 |                    | 00:28:00        | 00:00:00          | 00:00:00       |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | RDLEY                   | 00:32:30           | 00:34:00        | 00:33:00          | 00:34:00       | 1                 |                  |                  |            | T          |                 |              |           |          |          |             |
      | KNNGTNJ                 |                    | 00:37:30        | 00:00:00          | 00:00:00       |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | OXFDUDP                 |                    | 00:40:00        | 00:00:00          | 00:00:00       |                   |                  |                  | [1]        |            |                 |              |           |          |          |             |
      | OXFD                    | 00:43:00           |                 | 00:43:00          |                | 3                 |                  |                  |            | TF         |                 |              |           |          |          |             |
    And I toggle the inserted locations on
    And The timetable entries contains the following data, with timings having recorded offset from '33753-4 - View Timetable (Schedule Matched - Trains List)' at '23:47:00'
      | location                | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | PADTON                  |                    | 23:33:00        |                   | 23:33:00       | 4                 |                  | 1                |            | TB         |                 |              |           |          |          |             |
      | ROYAOJN                 |                    | 23:34:00        | 00:00:00          | 00:00:00       |                   |                  | 1                |            |            |                 |              |           |          |          |             |
      | PRTOBJP                 |                    | 23:35:00        | 00:00:00          | 00:00:00       |                   |                  | 1                |            |            |                 |              |           |          |          |             |
      | LDBRKJ                  |                    | 23:35:30        | 00:00:00          | 00:00:00       |                   | 1                | ML               |            |            |                 |              |           |          |          |             |
      | [ACTONML]               |                    | 23:37:22        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | ACTONW\nChange-en-Route |                    | 23:38:00        | 00:00:00          | 00:00:00       |                   | ML               | ML               |            |            |                 |              |           |          |          |             |
      | [EALINGB]               |                    | 23:38:13        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | [WEALING]               |                    | 23:38:43        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | [HANWELL]               |                    | 23:39:07        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | [STHALEJ]               |                    | 23:39:49        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | STHALL                  |                    | 23:40:00        | 00:00:00          | 00:00:00       | 1                 |                  | ML               |            |            |                 |              |           |          |          |             |
      | [STHALWJ]               |                    | 23:40:19        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | [HAYESAH]               |                    | 23:40:55        |                   |                |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | HTRWAJN                 |                    | 23:41:00        | 00:00:00          | 00:00:00       |                   |                  | ML               | <2>        |            |                 |              |           |          |          |             |
      | SLOUGH                  | 23:47:00           | 23:48:30        | 23:47:00          | 23:48:00       | 2                 |                  | ML               | (0.5)      | T          |                 |              |           |          |          |             |
      | MDNHEAD                 | 23:53:30           | 23:55:30        | 23:54:00          | 23:55:00       | 1                 |                  | ML               | [0.5]      | T          |                 |              |           |          |          |             |
      | TWYFORD                 |                    | 00:01:00        | 00:00:00          | 00:00:00       | 1                 |                  | ML               | [1] (1)    |            |                 |              |           |          |          |             |
      | RDNGKBJ                 |                    | 00:05:00        | 00:00:00          | 00:00:00       |                   |                  | DML              | [0.5]      |            |                 |              |           |          |          |             |
      | RDNGSTN                 | 00:06:30           | 00:10:00        | 00:07:00          | 00:10:00       | 9                 |                  | ML               |            | T          |                 |              |           |          |          |             |
      | RDNGHLJ                 |                    | 00:11:00        | 00:00:00          | 00:00:00       |                   |                  | ML               |            |            |                 |              |           |          |          |             |
      | GORASTR                 |                    | 00:16:30        | 00:00:00          | 00:00:00       |                   |                  | ML               | [1] (1)    |            |                 |              |           |          |          |             |
      | DIDCTEJ                 |                    | 00:23:00        | 00:00:00          | 00:00:00       |                   |                  | RL               |            |            |                 |              |           |          |          |             |
      | DIDCOTP                 | 00:24:00           | 00:26:00        | 00:24:00          | 00:26:00       | 3                 |                  | DOX              |            | T          |                 |              |           |          |          |             |
      | DIDCTNJ                 |                    | 00:28:00        | 00:00:00          | 00:00:00       |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | RDLEY                   | 00:32:30           | 00:34:00        | 00:33:00          | 00:34:00       | 1                 |                  |                  |            | T          |                 |              |           |          |          |             |
      | KNNGTNJ                 |                    | 00:37:30        | 00:00:00          | 00:00:00       |                   |                  |                  |            |            |                 |              |           |          |          |             |
      | OXFDUDP                 |                    | 00:40:00        | 00:00:00          | 00:00:00       |                   |                  |                  | [1]        |            |                 |              |           |          |          |             |
      | OXFD                    | 00:43:00           |                 | 00:43:00          |                | 3                 |                  |                  |            | TF         |                 |              |           |          |          |             |
    And The timetable entries are populated as follows:
      | location | column          | value     |
      | SLOUGH   | arrivalDateTime | actual    |
      | SLOUGH   | deptDateTime    | predicted |
    When I move the replay to the end of the captured scenario
    Then The timetable entries are populated as follows:
      | location | column          | value  |
      | SLOUGH   | arrivalDateTime | actual |
      | SLOUGH   | deptDateTime    | actual |
