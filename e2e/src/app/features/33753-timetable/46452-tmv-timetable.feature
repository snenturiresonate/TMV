Feature: 33753 - TMV Timetable

  As a TMV dev team member
  I want end to end tests to be created for the Timetable functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  Background:
    * I am on the home page
    * I restore to default train list config

  Scenario Outline: 33753-1 -Open Timetable (Trains List)
     #Open Timetable (Trains List)
     #Given the user is authenticated to use TMV
     #And the user is viewing the trains list
     #When the user selects a train from the trains list using the secondary mouse click
     #And selects the "open timetable" option from the menu
     #Then the train's timetable is opened in a new browser tab
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | RDNGSTN     | WTT_arr       | <trainNum>          | <planningUid>  |
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    When I invoke the context menu from train '<trainNum>' on the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    And I open timetable from the context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | trainNum | planningUid |
      | 1A01     | L10001      |

  @replaySetup
  Scenario Outline: 33753-2a -Open Timetable (from Map - Schedule Matched)
#    Given the user is authenticated to use TMV
#    And the user is viewing a map
#    When the user selects a train (occupied berth) from the map using the secondary click for a service which has been Schedule Matched
#    And selects the "open timetable" option from the menu
#    Then the train's timetable is opened in a new browser tab
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid>  |
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | 0037    | D3             | <trainNum>       |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0037      | 0057    | D3             | <trainNum>       |
    And I am viewing the map HDGW01paddington.v
    When I invoke the context menu on the map for train <trainNum>
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | trainNum | planningUid |
      | 1A02     | L10002      |

  @tdd @tdd:60684 @replaySetup
  Scenario Outline: 33753-2b -Open Timetable (from Map - Unmatched)
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And the following berth interpose message is sent from LINX (to indicate train is present)
      | timestamp | toBerth | trainDescriber | trainDescription |
      | 09:59:00  | 0099    | D3             | <trainNum>       |
    When I invoke the context menu on the map for train <trainNum>
    Then the map context menu contains 'No timetable' on line 2
    Examples:
      | trainNum |
      | 1A03     |

  @tdd @replaySetup
  Scenario Outline: 33753-3a Open Timetable (from Search Result - matched service (Train) and matched/unmatched services (Timetable) have timetables)
#    Given the user is authenticated to use TMV
#    And the user is viewing a search results list
#    When the user selects a train search result using the secondary click
#    And selects the "open timetable" option from the menu
#    Then the timetable is opened in a new browser tab
    Given I am on the home page
    And I search <searchType> for '<searchVal>'
    And the search table is shown
    When I invoke the context menu from a <serviceStatus> service in the <searchType> list
    And I wait for the '<searchType>' search context menu to display
    And the '<searchType>' context menu is displayed
    And the '<searchType>' search context menu contains 'Open timetable' on line 1
    And the '<searchType>' search context menu contains 'Select maps' on line 2
    And I click on timetable link
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | searchType | searchVal | serviceStatus |
      | Train      | 1A        | ACTIVATED     |
      | Timetable  | 1A        | ACTIVATED     |
      | Timetable  | 1A        | UNMATCHED     |

  @tdd @tdd:60684 @replaySetup
  Scenario Outline: 33753-3b Open Timetable (from Search Result - unmatched service (Train) has no timetable)
    Given I am on the home page
    And I search <searchType> for '<searchVal>'
    And the search table is shown
    When I invoke the context menu from a <serviceStatus> service in the <searchType> list
    Then the '<searchType>' context menu is not displayed
    Examples:
      | searchType | searchVal | serviceStatus |
      | Train      | 1A        | UNMATCHED     |

  @tdd
  Scenario Outline: 33753-3c Open Timetable (from Manual Match Search Result - matched/unmatched services have timetable)
    Given I am viewing the map HDGW01paddington.v
    And the following berth interpose message is sent from LINX (to indicate train is present)
      | timestamp | toBerth | trainDescriber | trainDescription |
      | 09:59:00  | <berth> | D4             | <trainNum>       |
    When I invoke the context menu on the map for train <trainNum>
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching'
    And I invoke the context menu from a <serviceStatus> service in the <searchType> list
    And I wait for the '<searchType>' search context menu to display
    And the '<searchType>' context menu is displayed
    And the '<searchType>' search context menu contains 'Open timetable' on line 1
    And the '<searchType>' search context menu contains 'Select maps' on line 2
    And I click on timetable link
    And I switch to the new tab
    And the tab title is 'TMV Timetable'

    Examples:
      | trainNum | berth | searchType | serviceStatus |
      | 1A04     | 0249  | Timetable  | ACTIVATED     |
      | 1A05     | 0253  | Timetable  | UNMATCHED     |


  @tdd @replaySetup @bug @bug_55114
  Scenario Outline: 33753-4a - View Timetable (Schedule Matched - live updates are applied)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is schedule matched
    #When the user is viewing the timetable
    #Then the train's schedule is displayed with any predicted and live running information and header information
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | SLOUGH      | WTT_arr       | <trainNum>          | <planningUid>  |
    And I am on the trains list page
    And The trains list table is visible
    And Train description '<trainNum>' is visible on the trains list
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0519    | D6             | <trainNum>       |
    Given I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu from train '<trainNum>' on the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu contains 'Unmatch' on line 3
    And I open timetable from the context menu
    And I switch to the new tab
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | T519       |            | <planningUid> |         |         | <trainNum> |
    And the navbar punctuality indicator is displayed as 'green'
    And the punctuality is displayed as 'On Time'
    And The timetable entries contains the following data, with timings having live offset from 'earlier' at 'the beginning of the test'
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
    And The timetable entries contains the following data, with timings having live offset from 'earlier' at 'the beginning of the test'
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
    And The live timetable entries are populated as follows:
      | location | column          | value     |
      | SLOUGH   | arrivalDateTime | actual    |
      | SLOUGH   | deptDateTime    | predicted |
    When the following live berth step message is sent from LINX (moving train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0519      | 0533    | D6             | <trainNum>       |
    And the maximum amount of time is allowed for end to end transmission
    Then The live timetable entries are populated as follows:
      | location | column          | value  |
      | SLOUGH   | arrivalDateTime | actual |
      | SLOUGH   | deptDateTime    | actual |

    Examples:
      | trainNum | planningUid |
      | 1A06     | L10006      |

  @tdd @replaySetup
  Scenario Outline: 33753-4b - View Timetable (Schedule Matched - becoming unmatched)
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | EALINGB     | WTT_arr       | <trainNum>          | <planningUid>  |
    And I am on the trains list page
    And The trains list table is visible
    And Train description '<trainNum>' is visible on the trains list
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0206    | D3             | <trainNum>       |
    Given I am viewing the map hdgw01paddington.v
    And I invoke the context menu on the map for train <trainNum>
    And the map context menu contains 'Unmatch' on line 3
    And I open timetable from the map context menu
    And I switch to the new tab
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | SN206      |            | <planningUid> |         |         | <trainNum> |
    And The live timetable entries are populated as follows:
      | location | column          | value     |
      | EALINGB  | arrivalDateTime | actual    |
      | EALINGB  | deptDateTime    | predicted |
    And the following live berth step message is sent from LINX (moving train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0206      | 0202    | D3             | <trainNum>       |
    And the maximum amount of time is allowed for end to end transmission
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | SN202      |            | <planningUid> |         |         | <trainNum> |
    And The live timetable entries are populated as follows:
      | location | column          | value  |
      | EALINGB  | arrivalDateTime | actual |
      | EALINGB  | deptDateTime    | actual |
    When I switch to the second-newest tab
    And I invoke the context menu on the map for train <trainNum>
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And I un-match the currently matched schedule
    And I switch to the second-newest tab
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       |            |            | <planningUid> |         |         | <trainNum> |
    And The live timetable entries are populated as follows:
      | location | column          | value  |
      | EALINGB  | arrivalDateTime | absent |
      | EALINGB  | deptDateTime    | absent |

    Examples:
      | trainNum | planningUid |
      | 1A07     | L10007      |


  @tdd @replayTest
  Scenario Outline: 33753-5 - View Timetable (Schedule Not Matched - becoming matched)
#    Given the user is authenticated to use TMV
#    And the user has opened a timetable
#    And the schedule is not matched to live stepping
#    When the user is viewing the timetable
#    Then the schedule is displayed with no predicted or live actual running information or header information.
    Given the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 0831    | D1             | <trainNum>       |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | CHOLSEY     | WTT_arr       | <trainNum>          | <planningUid>  |
    And I am on the trains list page
    And The trains list table is visible
    And Train description '<trainNum>' is visible on the trains list
    And I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu from train '<trainNum>' on the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu contains 'Match' on line 3
    And I open timetable from the context menu
    And I switch to the new tab
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       |            |            | <planningUid> |         |         | <trainNum> |
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
    Then The live timetable entries are populated as follows:
      | location | column          | value  |
      | CHOLSEY  | arrivalDateTime | absent |
      | CHOLSEY  | deptDateTime    | absent |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0831      | 0839    | D1             | <trainNum>       |
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | T839       |            | <planningUid> |         |         | <trainNum> |
    And The live timetable entries are populated as follows:
      | location | column          | value     |
      | CHOLSEY  | arrivalDateTime | actual    |
      | CHOLSEY  | deptDateTime    | predicted |

    Examples:
      | trainNum | planningUid |
      | 1A08     | L10008      |

  @tdd @replayTest
  Scenario Outline: 33753-6 - View Timetable Detail (Schedule Matched - becoming unmatched)
#    Given the user is authenticated to use TMV
#    And the user has opened a timetable
#    And the schedule is matched to live stepping
#    When the user selects the details tab of the timetable
#    Then the train's CIF information and header information with any TJM, Association and Change-en-route is displayed
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid>  |
    And I am on the trains list page
    And The trains list table is visible
    And Train description '<trainNum>' is visible on the trains list
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | A001    | D3             | <trainNum>       |
    And the following live berth step message is sent from LINX (moving train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | A001      | 0037    | D3             | <trainNum>       |
    Given I am viewing the map hdgw01paddington.v
    And I invoke the context menu on the map for train <trainNum>
    And the map context menu contains 'Unmatch' on line 3
    And I open timetable from the map context menu
    And I switch to the new tab
    When I switch to the timetable details tab
    Then The timetable details tab is visible
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | SN37       |            | <planningUid> |         |         | <trainNum> |
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
    When the following change of ID TJM is received
      | status | newTrainNumber           | oldTrainNumber | locationPrimaryCode | locationSubsidiaryCode | time   |
      | create | <changeTrainDescription> | <trainNum>     | 99999               | PADTON                 | <time> |
    Then the headcode in the header row is '<changeTrainDescription> (<trainNum>)'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM                                  | headCode                 |
      | LTP       | SN37       |            | <planningUid> |         | Change of Identity, Paddington, 12:00:00 | <changeTrainDescription> |
    And there is a record in the modifications table
      | description   | location   | time   | type   |
      | <description> | <location> | <time> | <type> |
    When I switch to the second-newest tab
    And I invoke the context menu on the map for train <changeTrainDescription>
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And I un-match the currently matched schedule
    And I switch to the second-newest tab
    And The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed           | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 04/01/2021 to 25/03/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             |         | GW       | 25507005         | P               | XX            |           | ,            | 1     | B ,          | A ,          | 802 , 811  | EMU , DMU | 120mph , 144mph | ,         | m , m       | D , D,B,A                    |                 |
    And The entry of the change en route table contains the following data
      | columnName |
      | ACTONW     |
      | DMU        |
      | 811        |
      | 144mph     |
      | D          |
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       |            |            | <planningUid> |         |         | <trainNum> |
    And there are no records in the modifications table


    Examples:
      | trainNum | planningUid | changeTrainDescription | type | description        | location   | time     |
      | 1A09     | L10009      | 1X09                   | 07   | Change of Identity | Paddington | 12:00:00 |

  @tdd @replayTest
  Scenario Outline: 33753-7 - View Timetable Detail (Not Schedule Matched - becoming matched)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is not schedule matched
    #When the user selects the details tab of the timetable
    #Then the train's basic header information is displayed
    Given the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 1630    | D1             | <trainNum>       |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | TWYFORD     | WTT_pass      | <trainNum>          | <planningUid>  |
    And I am on the trains list page
    And The trains list table is visible
    And Train description '<trainNum>' is visible on the trains list
    And I am on the trains list page
    And The trains list table is visible
    When I invoke the context menu from train '<trainNum>' on the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu contains 'Match' on line 3
    And I open timetable from the context menu
    And I switch to the new tab
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       |            |            | <planningUid> |         |         | <trainNum> |
    And the punctuality is displayed as 'Unmatched'
    When I switch to the timetable details tab
    And The timetable details tab is visible
    Then The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed  | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 15/12/2019 to 10/05/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             |         | GW       | 25507005         | P               | OO            |           |              | 1     | S            |              |            | EMU       | 110mph |           | m           | D                            |                 |
    When the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1630      | 1628    | D1             | <trainNum>       |
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | T1628      |            | <planningUid> |         |         | <trainNum> |
    And the punctuality is displayed as 'On Time'
    And The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed  | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 15/12/2019 to 10/05/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             | 1628    | GW       | 25507005         | P               | OO            |           |              | 1     | S            |              |            | EMU       | 110mph |           | m           | D                            |                 |

    Examples:
      | trainNum | planningUid |
      | 1A10     | L10010      |
