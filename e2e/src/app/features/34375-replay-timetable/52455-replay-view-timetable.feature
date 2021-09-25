@bug @bug_58561
Feature: 34375 - TMV Replay Timetable - View Timetable

  As a TMV User
  I want to view historic timetable during replay
  So that I can view what timetable the train was running to and its historic actuals

  @tdd @replayTest
  Scenario: 34375-4a Replay - View Timetable (Schedule Matched - live updates are applied)
#    Given the user is authenticated to use TMV replay
#    And the user has opened a timetable within Replay
#    And the schedule is matched to live stepping
#    When the user is viewing the timetable
#    Then the schedule is displayed with any predicted and live actual running information and header information
    Given I load the replay data from scenario '33753-4a - View Timetable (Schedule Matched - live updates are applied)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw02reading.v'
    And I wait for the buffer to fill
    And I select skip forward to just after replay scenario step '1'
    When I invoke the context menu on the map for train 1A06
    And I switch to the new tab
    Then the tab title is 'TMV Replay Timetable 1A06'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       | T519       |            | L10006   |         |         | 1A06     |
    And the navbar punctuality indicator is displayed as 'green' or 'yellow'
    And the punctuality is displayed as 'On Time'
    And The timetable entries contains the following data, with timings having recorded offset from '33753-4a - View Timetable (Schedule Matched - live updates are applied)' at '23:47:00'
      | location                | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities |
      | PADTON                  |                    | 23:33:00        |                   | 23:33:00       | 4                 |                  | 1                |            | TB         |
      | ROYAOJN                 |                    | 23:34:00        |                   |                |                   | 1                | 1                |            |            |
      | PRTOBJP                 |                    | 23:35:00        |                   |                |                   | 1                | 1                |            |            |
      | LDBRKJ                  |                    | 23:35:30        |                   |                |                   | 1                | ML               |            |            |
      | ACTONW\nChange-en-Route |                    | 23:38:00        |                   |                |                   | ML               | ML               |            |            |
      | STHALL                  |                    | 23:40:00        |                   |                | 1                 | ML               | ML               |            |            |
      | HTRWAJN                 |                    | 23:41:00        |                   |                |                   | ML               | ML               | <2>        |            |
      | SLOUGH                  | 23:47:00           | 23:48:30        | 23:47:00          | 23:48:00       | 2                 | ML               | ML               | (0.5)      | T          |
      | MDNHEAD                 | 23:53:30           | 23:55:30        | 23:54:00          | 23:55:00       | 1                 | ML               | ML               | [0.5]      | T          |
      | TWYFORD                 |                    | 00:01:00        |                   |                | 1                 | ML               | ML               | [1] (1)    |            |
      | RDNGKBJ                 |                    | 00:05:00        |                   |                |                   | ML               | DML              | [0.5]      |            |
      | RDNGSTN                 | 00:06:30           | 00:10:00        | 00:07:00          | 00:10:00       | 9                 | DML              | ML               |            | T          |
      | RDNGHLJ                 |                    | 00:11:00        |                   |                |                   | ML               | ML               |            |            |
      | GORASTR                 |                    | 00:16:30        |                   |                |                   | ML               | ML               | [1] (1)    |            |
      | DIDCTEJ                 |                    | 00:23:00        |                   |                |                   | ML               | RL               |            |            |
      | DIDCOTP                 | 00:24:00           | 00:26:00        | 00:24:00          | 00:26:00       | 3                 | RL               | DOX              |            | T          |
      | DIDCTNJ                 |                    | 00:28:00        |                   |                |                   | DOX              |                  |            |            |
      | RDLEY                   | 00:32:30           | 00:34:00        | 00:33:00          | 00:34:00       | 1                 |                  |                  |            | T          |
      | KNNGTNJ                 |                    | 00:37:30        |                   |                |                   |                  |                  |            |            |
      | OXFDUDP                 |                    | 00:40:00        |                   |                |                   |                  |                  | [1]        |            |
      | OXFD                    | 00:43:00           |                 | 00:43:00          |                | 3                 |                  |                  |            | TF         |
    And I toggle the inserted locations on
    And The timetable entries contains the following data, with timings having recorded offset from '33753-4a - View Timetable (Schedule Matched - live updates are applied)' at '23:47:00'
      | location                | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities |
      | PADTON                  |                    | 23:33:00        |                   | 23:33:00       | 4                 |                  | 1                |            | TB         |
      | ROYAOJN                 |                    | 23:34:00        |                   |                |                   | 1                | 1                |            |            |
      | PRTOBJP                 |                    | 23:35:00        |                   |                |                   | 1                | 1                |            |            |
      | LDBRKJ                  |                    | 23:35:30        |                   |                |                   | 1                | ML               |            |            |
      | [ACTONML]               |                    | 23:37:22        |                   |                |                   | ML               | ML               |            |            |
      | ACTONW\nChange-en-Route |                    | 23:38:00        |                   |                |                   | ML               | ML               |            |            |
      | [EALINGB]               |                    | 23:38:13        |                   |                |                   | ML               | ML               |            |            |
      | [WEALING]               |                    | 23:38:43        |                   |                |                   | ML               | ML               |            |            |
      | [HANWELL]               |                    | 23:39:07        |                   |                |                   | ML               | ML               |            |            |
      | [STHALEJ]               |                    | 23:39:49        |                   |                |                   | ML               | ML               |            |            |
      | STHALL                  |                    | 23:40:00        |                   |                | 1                 | ML               | ML               |            |            |
      | [STHALWJ]               |                    | 23:40:19        |                   |                |                   | ML               | ML               |            |            |
      | [HAYESAH]               |                    | 23:40:55        |                   |                |                   | ML               | ML               |            |            |
      | HTRWAJN                 |                    | 23:41:00        |                   |                |                   | ML               | ML               | <2>        |            |
      | SLOUGH                  | 23:47:00           | 23:48:30        | 23:47:00          | 23:48:00       | 2                 | ML               | ML               | (0.5)      | T          |
      | MDNHEAD                 | 23:53:30           | 23:55:30        | 23:54:00          | 23:55:00       | 1                 | ML               | ML               | [0.5]      | T          |
      | TWYFORD                 |                    | 00:01:00        |                   |                | 1                 | ML               | ML               | [1] (1)    |            |
      | RDNGKBJ                 |                    | 00:05:00        |                   |                |                   | ML               | DML              | [0.5]      |            |
      | RDNGSTN                 | 00:06:30           | 00:10:00        | 00:07:00          | 00:10:00       | 9                 | DML              | ML               |            | T          |
      | RDNGHLJ                 |                    | 00:11:00        |                   |                |                   | ML               | ML               |            |            |
      | GORASTR                 |                    | 00:16:30        |                   |                |                   | ML               | ML               | [1] (1)    |            |
      | DIDCTEJ                 |                    | 00:23:00        |                   |                |                   | ML               | RL               |            |            |
      | DIDCOTP                 | 00:24:00           | 00:26:00        | 00:24:00          | 00:26:00       | 3                 | RL               | DOX              |            | T          |
      | DIDCTNJ                 |                    | 00:28:00        |                   |                |                   | DOX              |                  |            |            |
      | RDLEY                   | 00:32:30           | 00:34:00        | 00:33:00          | 00:34:00       | 1                 |                  |                  |            | T          |
      | KNNGTNJ                 |                    | 00:37:30        |                   |                |                   |                  |                  |            |            |
      | OXFDUDP                 |                    | 00:40:00        |                   |                |                   |                  |                  | [1]        |            |
      | OXFD                    | 00:43:00           |                 | 00:43:00          |                | 3                 |                  |                  |            | TF         |
    And The live timetable actual time entries are populated as follows:
      | location | column          | valType   |
      | SLOUGH   | arrivalDateTime | actual    |
      | SLOUGH   | deptDateTime    | predicted |
    When I move the replay to the end of the captured scenario
    Then The live timetable actual time entries are populated as follows:
      | location | column          | valType |
      | SLOUGH   | arrivalDateTime | actual  |
      | SLOUGH   | deptDateTime    | actual  |

  @tdd @replayTest
  Scenario: 34375-4b Replay - View Timetable (Schedule Matched - becoming unmatched)
    Given I load the replay data from scenario '33753-4b - View Timetable (Schedule Matched - becoming unmatched)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I wait for the buffer to fill
    And I select skip forward to just after replay scenario step '1'
    And I invoke the context menu on the map for train 1A07
    And I open timetable from the map context menu
    And I switch to the new tab
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       | SN206      |            | L10007   |         |         | 1A07     |
    And The live timetable actual time entries are populated as follows:
      | location | column          | valType   |
      | EALINGB  | arrivalDateTime | actual    |
      | EALINGB  | deptDateTime    | predicted |
    When I select skip forward to just after replay scenario step '2'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       | SN202      |            | L10007   |         |         | 1A07     |
    And The live timetable actual time entries are populated as follows:
      | location | column          | valType |
      | EALINGB  | arrivalDateTime | actual  |
      | EALINGB  | deptDateTime    | actual  |
    When I move the replay to the end of the captured scenario
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       |            |            | L10007   |         |         | 1A07     |
    And The live timetable actual time entries are populated as follows:
      | location | column          | valType |
      | EALINGB  | arrivalDateTime | absent  |
      | EALINGB  | deptDateTime    | absent  |

  @tdd @replayTest
  Scenario: 34375-5 Replay - View Timetable (Schedule Not Matched - becoming matched)
#    Given the user is authenticated to use TMV replay
#    And the user has opened a timetable within Replay
#    And the schedule is not matched live stepping
#    When the user is viewing the timetable
#    Then the schedule is displayed with no predicted or live actual running information or header information.
    Given I load the replay data from scenario '33753-5 - View Timetable (Schedule Not Matched - becoming matched)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw02reading.v'
    And I wait for the buffer to fill
    And I select skip forward to just after replay scenario step '1'
    And I search Timetable for '1A08'
    And the search table is shown
    When I invoke the context menu from train with planning UID 'L10008' on the search results table
    And I click on timetable link
    And I switch to the new tab
    Then the tab title contains 'TMV Replay Timetable 1A08'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       |            |            | L10008   |         |         | 1A08     |
    And the punctuality is displayed as 'Unmatched'
    And The timetable entries contains the following data, with timings having live offset from 'earlier' at 'the beginning of the test'
      | location | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities |
      | PADTON   |                    | 21:20:00        |                   | 21:19:00       | 14                |                  | 4                |            | TB         |
      | ROYAOJN  |                    | 21:21:00        |                   |                |                   | 4                | 4                |            |            |
      | PRTOBJP  |                    | 21:22:30        |                   |                |                   | 4                | 4                |            |            |
      | LDBRKJ   |                    | 21:23:00        |                   |                |                   | 4                | RL               |            |            |
      | ACTONW   |                    | 21:25:30        |                   |                |                   | RL               | RL               |            |            |
      | EALINGB  | 21:26:00           | 21:26:30        | 21:26:00          | 21:26:00       | 3                 | RL               | RL               |            | T          |
      | STHALL   |                    | 21:27:30        |                   |                | 3                 | RL               | RL               |            |            |
      | HTRWAJN  |                    | 21:28:30        |                   |                |                   | RL               | RL               |            |            |
      | SLOUGH   | 21:32:00           | 21:34:00        | 21:32:00          | 21:34:00       | 4                 | RL               | RL               |            | T          |
      | MDNHEAD  |                    | 21:40:00        |                   |                |                   | RL               | RL               |            |            |
      | TWYFORD  |                    | 21:44:30        |                   |                |                   | RL               | RL               | (1)        |            |
      | RDNGKBJ  |                    | 21:47:30        |                   |                |                   | RL               | DRL              | [1] (1.5)  |            |
      | RDNGSTN  | 21:48:30           | 21:50:30        | 21:48:00          | 21:50:00       | 12                | DRL              | RL               |            | T          |
      | REDGWJN  |                    | 21:52:30        |                   |                |                   | RL               | RL               |            |            |
      | GORASTR  |                    | 21:57:00        |                   |                |                   | RL               | RL               |            |            |
      | CHOLSEY  | 21:59:00           | 22:00:30        | 21:59:00          | 22:00:00       |                   | RL               | RL               | [1]        | T          |
      | DIDCTEJ  |                    | 22:04:00        |                   |                |                   | RL               | URL              |            |            |
      | DIDCOTP  | 22:05:00           |                 | 22:05:00          |                | 4                 | URL              |                  |            | TF         |
    And The live timetable actual time entries are populated as follows:
      | location | column          | valType |
      | CHOLSEY  | arrivalDateTime | absent  |
      | CHOLSEY  | deptDateTime    | absent  |
    When I move the replay to the end of the captured scenario
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       | T839       |            | L10008   |         |         | 1A08     |
    And The live timetable actual time entries are populated as follows:
      | location | column          | valType   |
      | CHOLSEY  | arrivalDateTime | actual    |
      | CHOLSEY  | deptDateTime    | predicted |

  @tdd @replayTest
  Scenario: 34375-6 Replay - View Timetable Detail (Schedule Matched - becoming unmatched)
#    Given the user is authenticated to use TMV replay
#    And the user has opened a timetable within Replay
#    And the schedule is matched to live stepping
#    When the user selects the details tab of the timetable
#    Then the train's CIF information and header information with any TJM, Association and Change-en-route is displayed
    Given I load the replay data from scenario '33753-6 - View Timetable Detail (Schedule Matched - becoming unmatched)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw01paddington.v'
    And I wait for the buffer to fill
    And I select skip forward to just after replay scenario step '2'
    And I invoke the context menu on the map for train 1A07
    And I open timetable from the map context menu
    And I switch to the new tab
    When I switch to the timetable details tab
    Then The timetable details tab is visible
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       | SN37       |            | L10009   |         |         | 1A07     |
    And The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed           | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 04/01/2021 to 25/03/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             | 0037    | GW       | 25507005         | P               | XX            |           | ,            | 1     | B ,          | A ,          | 802 , 811  | EMU , DMU | 120mph , 144mph | ,         | m , m       | D , D,B,A                    |                 |
    And The entry of the change en route table contains the following data
      | columnName |
      | ACTONW     |
      | DMU        |
      | 811        |
      | 144mph     |
      | D,B,A      |
    And there are no records in the modifications table
    When I select skip forward to just after replay scenario step '3'
    Then the current headcode in the header row is '1X09'
    Then the old headcode in the header row is '(1A09)'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM                                  | headCode |
      | LTP       | SN37       |            | L10009   |         | Change of Identity, Paddington, 12:00:00 | 1X09     |
    And there is a record in the modifications table
      | description        | location   | time     | type |
      | Change of Identity | Paddington | 12:00:00 | 07   |
    When I move the replay to the end of the captured scenario
    Then The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed           | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 04/01/2021 to 25/03/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             |         | GW       | 25507005         | P               | XX            |           | ,            | 1     | B ,          | A ,          | 802 , 811  | EMU , DMU | 120mph , 144mph | ,         | m , m       | D , D,B,A                    |                 |
    And The entry of the change en route table contains the following data
      | columnName |
      | ACTONW     |
      | DMU        |
      | 811        |
      | 144mph     |
      | D          |
    And the current headcode in the header row is '1A09'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       |            |            | L10009   |         |         | 1A09     |
    And there are no records in the modifications table

  @tdd @replayTest
  Scenario: 34375-7 Replay - View Timetable Detail (Not Schedule Matched - becoming matched)
#    Given the user is authenticated to use TMV replay
#    And the user has opened a timetable within Replay
#    And the schedule is not matched to live stepping
#    When the user selects the details tab of the timetable
#    Then the schedule’s basic header information is displayed
    Given I load the replay data from scenario '33753-7 - View Timetable Detail (Not Schedule Matched - becoming matched)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw02reading.v'
    And I wait for the buffer to fill
    And I select skip forward to just after replay scenario step '1'
    And I search Timetable for '1A10'
    And the search table is shown
    When I invoke the context menu from train with planning UID 'L10010' on the search results table
    And I click on timetable link
    And I switch to the new tab
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       |            |            | L10010   |         |         | 1A10     |
    And the punctuality is displayed as 'Unmatched'
    When I switch to the timetable details tab
    And The timetable details tab is visible
    Then The timetable details table contains the following data in each row
      | daysRun                  | runs                                                       | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed  | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 15/12/2019 to 10/05/2023 | Monday,Tuesday,Wednesday,Thursday,Friday,Saturday & Sunday |             |         | GW       | 25507005         | P               | OO            |           |              | 1     | S            |              |            | EMU       | 110mph |           | m           | D                            |                 |
    And I select skip forward to just after replay scenario step '2'
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       | T1628      |            | L10010   |         |         | 1A10     |
    And the punctuality is displayed as 'On Time'
    And The timetable details table contains the following data in each row
      | daysRun                  | runs                                                       | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed  | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 15/12/2019 to 10/05/2023 | Monday,Tuesday,Wednesday,Thursday,Friday,Saturday & Sunday |             | 1628    | GW       | 25507005         | P               | OO            |           |              | 1     | S            |              |            | EMU       | 110mph |           | m           | D                            |                 |

  @tdd @replayTest
  Scenario: 34375-8 Replay - View Timetable Detail (Replay Control - covering play and stop)
#    Given the user is authenticated to use TMV replay
#    And the user has opened a timetable within Replay
#    And the schedule is matched to live stepping
#    When the user uses the replay controls
#    Then the train's live information is updated accordingly (actuals, predicated, TJM, last reported, TRI, berth name)
    Given I load the replay data from scenario '33753-4b - View Timetable (Schedule Matched - becoming unmatched)'
    And I am on the replay page as existing user
    And I have set replay time and date from the recorded session
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'hdgw02reading.v'
    And I wait for the buffer to fill
    And I search Timetable for 'L10007'
    And the search table is shown
    Then no results are returned with that planning UID 'L10007'
    And I click close button at the bottom of table
    And I select skip forward to just after replay scenario step '1'
    And I search Timetable for 'L10007'
    And the search table is shown
    Then results are returned with that planning UID 'L10007'
    When I invoke the context menu from train with planning UID 'L10007' on the search results table
    And I click on timetable link
    And I switch to the new tab
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      | LTP       | SN206      |            | L10007   |         |         | 1A07     |
    And I switch to the timetable details tab
    And The timetable details tab is visible
    When I click Play button
    Then The values for 'berthId' are the following as time passes
      | values            |
      | 0206, 0202, blank |
    When I click Stop button
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid | trustId | lastTJM | headCode |
      |           |            |            |          |         |         |          |


