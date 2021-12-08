Feature: 33753 - TMV Timetable

  As a TMV dev team member
  I want end to end tests to be created for the Timetable functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  Background:
    * I reset redis
    * I have cleared out all headcodes
    * I am on the home page
    * I restore to default train list config

  Scenario Outline: 33753-1 -Open Timetable (Trains List)
     #Open Timetable (Trains List)
     #Given the user is authenticated to use TMV
     #And the user is viewing the trains list
     #When the user selects a train from the trains list using the secondary mouse click
     #And selects the "open timetable" option from the menu
     #Then the train's timetable is opened in a new browser tab
    * I remove all trains from the trains list
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | RDNGSTN     | WTT_arr       | <trainNum>          | <planningUid>  |
    And I am on the trains list page
    And The trains list table is visible
    And I wait until today's train '<planningUid>' has loaded
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainNum>  | now                    | 99999               | PADTON                 | today         | now                 |
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainNum>' schedule uid '<planningUid>' from the trains list
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
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
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

  @replaySetup
  Scenario Outline: 33753-2b -Open Timetable (from Map - Unmatched)
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | 0099    | D3             | <trainNum>       |
    When I invoke the context menu on the map for train <trainNum>
    Then the map context menu contains 'No Timetable' on line 2
    Examples:
      | trainNum |
      | 1A03     |

  @replaySetup @bug @test-data-not-created
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
    And the '<searchType>' search context menu contains 'Open Timetable' on line 1
    And the '<searchType>' search context menu contains 'Select maps' on line 2
    And I click on timetable link
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Examples:
      | searchType | searchVal | serviceStatus |
      | Train      | 1A        | ACTIVATED     |
      | Timetable  | 1A        | ACTIVATED     |
      | Timetable  | 1A        | UNMATCHED     |

  Scenario Outline: 33753-3b Open Timetable (from Search Result - unmatched service (Train) has no timetable)
    Given the following train running information message is sent from LINX
        | trainUID      | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
        | <planningUid> | <trainNum>  | today              | 73822               | SLOUGH                 | Departure from Origin |
    And I am on the trains list page
    And The trains list table is visible
    And Train description '<trainNum>' is visible on the trains list
    Given I am on the home page
    And I give the TRI 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I search <searchType> for '<searchVal>' and wait for result
      | TrainDesc  |
      | <trainNum> |
    And the search table is shown
    When I invoke the context menu from a <serviceStatus> service in the <searchType> list
    Then the '<searchType>' context menu is not displayed
    Examples:
      | searchType | searchVal | serviceStatus | trainNum | planningUid |
      | Train      | 3B89      | UNMATCHED     | 3B89     | H87234      |

  # Used to be flaky - see 68331
  Scenario Outline: 33753-3c Open Timetable (from Manual Match Search Result - matched/unmatched services have timetable)
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1W06_EUSTON_BHAMNWS.cif | EUSTON      | WTT_dep       | <trainNum>          | B46452         |
    And I wait until today's train 'B46452' has loaded
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | <berth> | D4             | <trainNum>       |
    And I give the interpose 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I am viewing the map HDGW01paddington.v
    When I invoke the context menu on the map for train <trainNum>
    And I open schedule matching screen from the map context menu
    And the number of tabs open is 2
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching'
    And I invoke the context menu from a <serviceStatus> service in the train list
    And I wait for the '<searchType>' search context menu to display
    And the '<searchType>' context menu is displayed
    And the '<searchType>' search context menu contains 'Open Timetable' on line 1
    And I click on the unscheduled timetable link
    And the number of tabs open is 3
    And I switch to the new tab
    And the tab title is 'TMV Timetable'

    Examples:
      | trainNum | berth | searchType  | serviceStatus |
      | 1B04     | 0249  | Unscheduled | UNCALLED      |


  @replaySetup
  Scenario Outline: 33753-4a - View Timetable (Schedule Matched - live updates are applied)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is schedule matched
    #When the user is viewing the timetable
    #Then the train's schedule is displayed with any predicted and live running information and header information
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | SLOUGH      | WTT_arr       | <trainNum>          | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainNum>  | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0519    | D6             | <trainNum>       |
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainNum>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And the Matched version of the trains list context menu is displayed
    And I open timetable from the context menu
    And I switch to the new tab
    And I wait for the last Signal to populate
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId   | lastTJM | headCode   |
      | LTP       | T519       |            | <planningUid> | <trustId> |         | <trainNum> |
    And the navbar punctuality indicator is displayed as 'green' or 'yellow'
    And the punctuality is displayed as one of On time,+0m 30s,-0m 30s,+1m,-1m,+1m 30s,-1m 30s
    And I give the timetable a settling time of 2 seconds to update
    And The timetable entries contains the following data, with timings having live offset from 'earlier' at 'the beginning of the test'
      | location                    | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities |
      | London Paddington           |                    | 23:33:00        |                   | 23:33:00       | 4                 |                  | 1                |            | TB         |
      | Royal Oak Junction          |                    | 23:34:00        |                   |                |                   | 1                | 1                |            |            |
      | Portobello Jn (London)      |                    | 23:35:00        |                   |                |                   | 1                | 1                |            |            |
      | Ladbroke Grove              |                    | 23:35:30        |                   |                |                   | 1                | ML               |            |            |
      | Acton West\nChange-en-Route |                    | 23:38:00        |                   |                |                   | ML               | ML               |            |            |
      | Southall                    |                    | 23:40:00        |                   |                | 1                 | ML               | ML               |            |            |
      | Heathrow Airport Jn         |                    | 23:41:00        |                   |                |                   | ML               | ML               | <2>        |            |
      | Slough                      | 23:47:00           | 23:48:30        | 23:47:00          | 23:48:00       | 2                 | ML               | ML               | (0.5)      | T          |
      | Maidenhead                  | 23:53:30           | 23:55:30        | 23:54:00          | 23:55:00       | 1                 | ML               | ML               | [0.5]      | T          |
      | Twyford                     |                    | 00:01:00        |                   |                | 1                 | ML               | ML               | [1] (1)    |            |
      | Kennet Bridge Jn            |                    | 00:05:00        |                   |                |                   | ML               | DML              | [0.5]      |            |
      | Reading                     | 00:06:30           | 00:10:00        | 00:07:00          | 00:10:00       | 9                 | DML              | ML               |            | T          |
      | Reading High Level Jn       |                    | 00:11:00        |                   |                |                   | ML               | ML               |            |            |
      | Goring & Streatley          |                    | 00:16:30        |                   |                |                   | ML               | ML               | [1] (1)    |            |
      | Didcot East Jn              |                    | 00:23:00        |                   |                |                   | ML               | RL               |            |            |
      | Didcot Parkway              | 00:24:00           | 00:26:00        | 00:24:00          | 00:26:00       | 3                 | RL               | DOX              |            | T          |
      | Didcot North Jn             |                    | 00:28:00        |                   |                |                   | DOX              |                  |            |            |
      | Radley                      | 00:32:30           | 00:34:00        | 00:33:00          | 00:34:00       | 1                 |                  |                  |            | T          |
      | Kennington Jn               |                    | 00:37:30        |                   |                |                   |                  |                  |            |            |
      | Oxford Up & Dn Passenger    |                    | 00:40:00        |                   |                |                   |                  |                  | [1]        |            |
      | Oxford                      | 00:43:00           |                 | 00:43:00          |                | 3                 |                  |                  |            | TF         |
    And I toggle the inserted locations on
    And The timetable entries contains the following data, with timings having live offset from 'earlier' at 'the beginning of the test'
      | location                    | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities |
      | London Paddington           |                    | 23:33:00        |                   | 23:33:00       | 4                 |                  | 1                |            | TB         |
      | Royal Oak Junction          |                    | 23:34:00        |                   |                |                   | 1                | 1                |            |            |
      | Portobello Jn (London)      |                    | 23:35:00        |                   |                |                   | 1                | 1                |            |            |
      | Ladbroke Grove              |                    | 23:35:30        |                   |                |                   | 1                | ML               |            |            |
      | [Acton Main Line]           |                    | 23:37:22        |                   |                |                   | ML               | ML               |            |            |
      | Acton West\nChange-en-Route |                    | 23:38:00        |                   |                |                   | ML               | ML               |            |            |
      | [Ealing Broadway]           |                    | 23:38:13        |                   |                |                   | ML               | ML               |            |            |
      | [West Ealing]               |                    | 23:38:43        |                   |                |                   | ML               | ML               |            |            |
      | [Hanwell]                   |                    | 23:39:07        |                   |                |                   | ML               | ML               |            |            |
      | [Southall East Jn]          |                    | 23:39:49        |                   |                |                   | ML               | ML               |            |            |
      | Southall                    |                    | 23:40:00        |                   |                | 1                 | ML               | ML               |            |            |
      | [Southall West Jn]          |                    | 23:40:19        |                   |                |                   | ML               | ML               |            |            |
      | [Hayes & Harlington]        |                    | 23:40:55        |                   |                |                   | ML               | ML               |            |            |
      | Heathrow Airport Jn         |                    | 23:41:00        |                   |                |                   | ML               | ML               | <2>        |            |
      | Slough                      | 23:47:00           | 23:48:30        | 23:47:00          | 23:48:00       | 2                 | ML               | ML               | (0.5)      | T          |
      | Maidenhead                  | 23:53:30           | 23:55:30        | 23:54:00          | 23:55:00       | 1                 | ML               | ML               | [0.5]      | T          |
      | Twyford                     |                    | 00:01:00        |                   |                | 1                 | ML               | ML               | [1] (1)    |            |
      | Kennet Bridge Jn            |                    | 00:05:00        |                   |                |                   | ML               | DML              | [0.5]      |            |
      | Reading                     | 00:06:30           | 00:10:00        | 00:07:00          | 00:10:00       | 9                 | DML              | ML               |            | T          |
      | Reading High Level Jn       |                    | 00:11:00        |                   |                |                   | ML               | ML               |            |            |
      | Goring & Streatley          |                    | 00:16:30        |                   |                |                   | ML               | ML               | [1] (1)    |            |
      | Didcot East Jn              |                    | 00:23:00        |                   |                |                   | ML               | RL               |            |            |
      | Didcot Parkway              | 00:24:00           | 00:26:00        | 00:24:00          | 00:26:00       | 3                 | RL               | DOX              |            | T          |
      | Didcot North Jn             |                    | 00:28:00        |                   |                |                   | DOX              |                  |            |            |
      | Radley                      | 00:32:30           | 00:34:00        | 00:33:00          | 00:34:00       | 1                 |                  |                  |            | T          |
      | Kennington Jn               |                    | 00:37:30        |                   |                |                   |                  |                  |            |            |
      | Oxford Up & Dn Passenger    |                    | 00:40:00        |                   |                |                   |                  |                  | [1]        |            |
      | Oxford                      | 00:43:00           |                 | 00:43:00          |                | 3                 |                  |                  |            | TF         |
    And The live timetable actual time entries are populated as follows:
      | location | instance | column    | valType   |
      | Slough   | 1        | actualArr | actual    |
      | Slough   | 1        | actualDep | predicted |
    When the following live berth step message is sent from LINX (moving train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0519      | 0533    | D6             | <trainNum>       |
    And I give the timetable a settling time of 2 seconds to update
    Then The live timetable actual time entries are populated as follows:
      | location | instance | column    | valType |
      | Slough   | 1        | actualArr | actual  |
      | Slough   | 1        | actualDep | actual  |

    Examples:
      | trainNum | planningUid | trustId    |
      | 1A06     | L10006      | 1A06L10006 |

  @replaySetup @tdd @tdd:60541
  Scenario Outline: 33753-4b - View Timetable (Schedule Matched - becoming unmatched)
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | EALINGB     | WTT_arr       | <trainNum>          | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0206    | D3             | <trainNum>       |
    Given I am viewing the map hdgw01paddington.v
    And I invoke the context menu on the map for train <trainNum>
    And the Matched version of the map context menu is displayed
    And I open timetable from the map context menu
    And I switch to the new tab
    And I wait for the last Signal to populate
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | SN206      |            | <planningUid> |         |         | <trainNum> |
    And I give the timetable a settling time of 2 seconds to update
    And The live timetable actual time entries are populated as follows:
      | location        | instance | column    | valType   |
      | Ealing Broadway | 1        | actualArr | actual    |
      | Ealing Broadway | 1        | actualDep | predicted |
    And the following live berth step message is sent from LINX (moving train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0206      | 0202    | D3             | <trainNum>       |
    And the maximum amount of time is allowed for end to end transmission
    And I wait for the last Signal to be 'SN202'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | SN202      |            | <planningUid> |         |         | <trainNum> |
    And I give the timetable a settling time of 2 seconds to update
    And The live timetable actual time entries are populated as follows:
      | location        | instance | column    | valType |
      | Ealing Broadway | 1        | actualArr | actual  |
      | Ealing Broadway | 1        | actualDep | actual  |
    When I switch to the second-newest tab
    And I invoke the context menu on the map for train <trainNum>
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And I un-match the currently matched schedule
    And I switch to the second-newest tab
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       |            |            | <planningUid> |         |         | <trainNum> |
    And The live timetable actual time entries are populated as follows:
      | location        | instance | column    | valType |
      | Ealing Broadway | 1        | actualArr | absent  |
      | Ealing Broadway | 1        | actualDep | absent  |

    Examples:
      | trainNum | planningUid |
      | 1A07     | L10007      |


  @replaySetup
  Scenario Outline: 33753-5 - View Timetable (Schedule Not Matched - becoming matched)
    #    Given the user is authenticated to use TMV
    #    And the user has opened a timetable
    #    And the schedule is not matched to live stepping
    #    When the user is viewing the timetable
    #    Then the schedule is displayed with no predicted or live actual running information or header information.
    * I generate a new trainUID
    * I generate a new train description
    Given the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 0831    | D1             | <trainNum>       |
    And the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | CHOLSEY     | WTT_arr       | <trainNum>          | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And I am on the timetable view for service '<planningUid>'
    And I give the timetable a settling time of 2 seconds to update
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       |            |            | <planningUid> |         |         | <trainNum> |
    And the punctuality is displayed as ''
    And The timetable entries contains the following data, with timings having live offset from 'earlier' at 'the beginning of the test'
      | location               | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities |
      | London Paddington      |                    | 21:20:00        |                   | 21:19:00       | 14                |                  | 4                |            | TB         |
      | Royal Oak Junction     |                    | 21:21:00        |                   |                |                   | 4                | 4                |            |            |
      | Portobello Jn (London) |                    | 21:22:30        |                   |                |                   | 4                | 4                |            |            |
      | Ladbroke Grove         |                    | 21:23:00        |                   |                |                   | 4                | RL               |            |            |
      | Acton West             |                    | 21:25:30        |                   |                |                   | RL               | RL               |            |            |
      | Ealing Broadway        | 21:26:00           | 21:26:30        | 21:26:00          | 21:26:00       | 3                 | RL               | RL               |            | T          |
      | Southall               |                    | 21:27:30        |                   |                | 3                 | RL               | RL               |            |            |
      | Heathrow Airport Jn    |                    | 21:28:30        |                   |                |                   | RL               | RL               |            |            |
      | Slough                 | 21:32:00           | 21:34:00        | 21:32:00          | 21:34:00       | 4                 | RL               | RL               |            | T          |
      | Maidenhead             |                    | 21:40:00        |                   |                |                   | RL               | RL               |            |            |
      | Twyford                |                    | 21:44:30        |                   |                |                   | RL               | RL               | (1)        |            |
      | Kennet Bridge Jn       |                    | 21:47:30        |                   |                |                   | RL               | DRL              | [1] (1.5)  |            |
      | Reading                | 21:48:30           | 21:50:30        | 21:48:00          | 21:50:00       | 12                | DRL              | RL               |            | T          |
      | Reading West Jn        |                    | 21:52:30        |                   |                |                   | RL               | RL               |            |            |
      | Goring & Streatley     |                    | 21:57:00        |                   |                |                   | RL               | RL               |            |            |
      | Cholsey                | 21:59:00           | 22:00:30        | 21:59:00          | 22:00:00       |                   | RL               | RL               | [1]        | T          |
      | Didcot East Jn         |                    | 22:04:00        |                   |                |                   | RL               | URL              |            |            |
      | Didcot Parkway         | 22:05:00           |                 | 22:05:00          |                | 4                 | URL              |                  |            | TF         |
    Then The live timetable actual time entries are populated as follows:
      | location | instance | column    | valType |
      | Cholsey  | 1        | actualArr | absent  |
      | Cholsey  | 1        | actualDep | absent  |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0831      | 0839    | D1             | <trainNum>       |
    And I give the timetable a settling time of 2 seconds to update
    Then The live timetable actual time entries are populated as follows:
      | location | instance | column    | valType   |
      | Cholsey  | 1        | actualArr | actual    |
      | Cholsey  | 1        | actualDep | predicted |
    And I wait for the last Signal to populate
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | T839       |            | <planningUid> |         |         | <trainNum> |

    Examples:
      | trainNum  | planningUid |
      | generated | generated   |

  @replaySetup @tdd @tdd:60541
  Scenario Outline: 33753-6 - View Timetable Detail (Schedule Matched - becoming unmatched)
#    Given the user is authenticated to use TMV
#    And the user has opened a timetable
#    And the schedule is matched to live stepping
#    When the user selects the details tab of the timetable
#    Then the train's CIF information and header information with any TJM, Association and Change-en-route is displayed
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | A001    | D3             | <trainNum>       |
    And the following live berth step message is sent from LINX (moving train along)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | A001      | 0037    | D3             | <trainNum>       |
    And I am viewing the map hdgw01paddington.v
    And I invoke the context menu on the map for train <trainNum>
    And the Matched version of the map context menu is displayed
    And I open timetable from the map context menu
    And I switch to the new tab
    When I switch to the timetable details tab
    Then The timetable details tab is visible
    And I wait for the last Signal to populate
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | SN37       |            | <planningUid> |         |         | <trainNum> |
    And I give the timetable a settling time of 2 seconds to update
    And The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed           | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 04/01/2021 to 25/03/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             | D30037  | EF       | 25507005         | P               | XX            |           | ,            | 1     | B ,          | A ,          | 802 , 811  | EMU , DMU | 120mph , 144mph | ,         | m , m       | D , D,B,A                    |                 |
    And The entry of the change en route table contains the following data
      | columnName |
      | Acton West |
      | DMU        |
      | 811        |
      | 144mph     |
      | D,B,A      |
    And there are no records in the modifications table
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainNum>  | now                    | 73000               | PADTON                 | today         | now                 |
    And the following change of ID TJM is received
      | trainUid      | newTrainNumber           | oldTrainNumber | departureHour | status | indicator | statusIndicator | primaryCode | modificationTime |
      | <planningUid> | <changeTrainDescription> | <trainNum>     | 12            | create | 07        | 07              | 99999       | <time>           |
    Then the current headcode in the header row is '<changeTrainDescription>'
    And the old headcode in the header row is '(<trainNum>)'
    And I wait for the last Signal to populate
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId                 | lastTJM                     | headCode                 |
      | LTP       | SN37       |            | <planningUid> | <trainNum><planningUid> | <description>, today <time> | <changeTrainDescription> |
    And there is a record in the modifications table
      | description   | location | time         | type |
      | <description> |          | today <time> |      |
    When I switch to the second-newest tab
    And I invoke the context menu on the map for train <changeTrainDescription>
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And I un-match the currently matched schedule
    And I switch to the second-newest tab
    And I give the timetable a settling time of 2 seconds to update
    And The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed           | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 04/01/2021 to 25/03/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             |         | EF       | 25507005         | P               | XX            |           | ,            | 1     | B ,          | A ,          | 802 , 811  | EMU , DMU | 120mph , 144mph | ,         | m , m       | D , D,B,A                    |                 |
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
      | trainNum | planningUid | changeTrainDescription | description        | time  |
      | 1A09     | L10019      | 1X09                   | Change Of Identity | 12:00 |

  @bug @bug:72179
  @replaySetup
  Scenario Outline: 33753-7 - View Timetable Detail (Not Schedule Matched - becoming matched)
    #Given the user is authenticated to use TMV
    #And the user has opened a timetable
    #And the train is not schedule matched
    #When the user selects the details tab of the timetable
    #Then the train's basic header information is displayed
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given the following live berth interpose message is sent from LINX (which won't match anything)
      | toBerth | trainDescriber | trainDescription |
      | 1693    | D1             | <trainNum>       |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | RDNGSTN     | WTT_arr       | <trainNum>          | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And I am on the timetable view for service '<planningUid>'
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       |            |            | <planningUid> |         |         | <trainNum> |
    And the punctuality is displayed as ''
    When I switch to the timetable details tab
    And The timetable details tab is visible
    And I give the timetable a settling time of 2 seconds to update
    Then The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed  | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 15/12/2019 to 10/05/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             |         | EF       | 25507005         | P               | OO            |           |              | 1     | S            |              |            | EMU       | 110mph |           | m           | D                            |                 |
    When the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1693      | 1717    | D1             | <trainNum>       |
    And I wait for the last Signal to populate
    Then The values for the header properties are as follows
      | schedType | lastSignal    | lastReport | trainUid      | trustId | lastTJM | headCode   |
      | LTP       | T1717X, T1717 |            | <planningUid> |         |         | <trainNum> |
    And I give the timetable a settling time of 2 seconds to update
    And The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed  | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 15/12/2019 to 10/05/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             | D11717  | EF       | 25507005         | P               | OO            |           |              | 1     | S            |              |            | EMU       | 110mph |           | m           | D                            |                 |
    And the punctuality is displayed as one of On time,+0m 30s,-0m 30s,+1m,-1m

    Examples:
      | trainNum | planningUid |
      | 1A10     | L10010      |
