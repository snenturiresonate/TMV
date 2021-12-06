Feature: 34002 - Unscheduled Trains Matching

  As a TMV User
  I want to view unscheduled trains
  So that I can determine if the unscheduled requires schedule matching

  Background:
    * I reset redis
    * I am authenticated to use TMV with 'matching' role

  Scenario Outline: 34002:5a Matching Services (several possible matches including cancelled and already matched)
    # Given the user selected a service to match/rematch
    # And the user has the schedule matching role
    # When the user selects match/rematch option from the menu of a service
    # Then the user is presented with a manual matching tab
    # And the view is populated with a list of possible services to match to
    * I have cleared out all headcodes
    * I generate a new train description
    * I generate a new trainUID
    And the following live berth interpose message is sent from LINX (to set up unmatched train on map)
      | toBerth | trainDescriber | trainDescription |
      | 0481    | D6             | <trainNum>       |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | STHALL      | WTT_pass      | <trainNum>          | <planningUid1> |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | SLOUGH      | WTT_dep       | <trainNum>          | <planningUid2> |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | TWYFORD     | WTT_pass      | <trainNum>          | <planningUid3> |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | STHALL      | WTT_pass      | <trainNum>          | <planningUid4> |
    And I wait until today's train '<planningUid1>' has loaded
    And I wait until today's train '<planningUid2>' has loaded
    And I wait until today's train '<planningUid3>' has loaded
    And I wait until today's train '<planningUid4>' has loaded
    And the following train activation message is sent from LINX
      | trainUID       | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid1> | <trainNum>  | now                    | 99999               | PADTON                 | today         | now                 |
    And the following TJM is received
        #tjmType-Cancel at Origin
      | trainUid       | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | <planningUid3> | <trainNum>  | now           | create | 91        | 91              | 73000       | PADTON         | now  | 91                 | PG                |
    And I give the TJM and Activation 2 seconds to load
    And the following live berth interpose message is sent from LINX (to create a match)
      | toBerth | trainDescriber | trainDescription |
      | 0519    | D6             | <trainNum>       |
    When I am viewing the map gw2aslough.v
    And I right click on berth with id 'D60481'
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching <trainNum>'
    And no matched service is visible
    And the unmatched search results show the following 8 results
      | trainNumber | planUID        | status    | sched | date     | origin  | originTime | dest    |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | tomorrow | PADTON  | now - 7    | OXFD    |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | tomorrow | PADTON  | now - 12   | DIDCOTP |
      | <trainNum>  | <planningUid3> | UNCALLED  | LTP   | tomorrow | PADTON  | now - 30   | SWANSEA |
      | <trainNum>  | <planningUid4> | UNCALLED  | LTP   | tomorrow | RDNGSTN | now - 35   | PADTON  |
      | <trainNum>  | <planningUid1> | ACTIVATED | LTP   | today    | PADTON  | now - 7    | OXFD    |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | today    | PADTON  | now - 12   | DIDCOTP |
      | <trainNum>  | <planningUid3> | CANCELLED | LTP   | today    | PADTON  | now - 30   | SWANSEA |
      | <trainNum>  | <planningUid4> | UNCALLED  | LTP   | today    | RDNGSTN | now - 35   | PADTON  |

    Examples:
      | trainNum  | planningUid1 | planningUid2 | planningUid3 | planningUid4 |
      | generated | generated    | L12002       | L12003       | L12004       |

  Scenario Outline: 65053:bug: Manual Matched consistent step following unmatched, unscheduled id not persisted
    ##
    * I generate a new train description
    * I generate a new trainUID
    Given I am viewing the map HDGW01paddington.v
    And the following live berth step message is sent from LINX (to create an unmatched service)
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And berth '<toBerth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1L24_PADTON_RDNGSTN.cif | STHALL      | WTT_arr       | <trainDescription>  | <trainUid1>    |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1L24_PADTON_RDNGSTN.cif | STHALL      | WTT_arr       | <trainDescription>  | <trainUid2>    |
    And I wait until today's train '<trainUid1>' has loaded
    And I wait until today's train '<trainUid2>' has loaded
    And I give the trains 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I right click on berth with id '<trainDescriber><toBerth>'
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    And I select to match the result for todays service with planning Id '<trainUid2>'
    And the matched service uid is shown as '<trainUid2>'
    And I am viewing the map HDGW01paddington.v
    When the following live berth step message is sent from LINX (to create a consistent step)
      | fromBerth   | toBerth    | trainDescriber   | trainDescription   |
      | <toBerth>   | <toBerth2> | <trainDescriber> | <trainDescription> |
    And I invoke the context menu on the map for train <trainDescription>
    And I open timetable from the map context menu
    And I switch to the new tab
    And I wait for the last Signal to populate
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode           |
      | VAR       | SN253      |            | <trainUid2>   |         |         | <trainDescription> |

    Examples:
      | fromBerth | toBerth | toBerth2 | trainDescriber | trainDescription | trainUid1 | trainUid2 |
      | 0239      | 0243    | 0253     | D4             | generated        | W00001    | generated |

  Scenario Outline: 34002:5b Matching Services (no possible matches)
    And the following live berth interpose message is sent from LINX (to set up unmatched train on map)
      | toBerth | trainDescriber | trainDescription |
      | 0864    | D2             | <trainNum>       |
    When I am viewing the map gw12newbury.v
    And I invoke the context menu on the map for train <trainNum>
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching <trainNum>'
    And no matched service is visible
    And the unmatched search results shows no results

    Examples:
      | trainNum |
      | 1C11     |

  Scenario Outline: 34002:6a Make Match - matching unmatched step to an unmatched service
    ##
    # Given the user is viewing the manual matching view
    # And the user has the schedule matching role
    # And the user is presented with at least one new schedule to match with (other than the currently matched schedule)
    # When the user selects an entry to match
    # Then the system will create a match
    * I remove today's train '<planningUid1>' from the Redis trainlist
    * I remove today's train '<planningUid2>' from the Redis trainlist
    * I generate a new train description
    And the following live berth interpose message is sent from LINX (to set up unmatched service on map)
      | toBerth | trainDescriber | trainDescription |
      | 1629    | D1             | <trainNum>       |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | ACTONW      | WTT_pass      | <trainNum>          | <planningUid1> |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | RDNGSTN     | WTT_dep       | <trainNum>          | <planningUid2> |
    And I wait until today's train '<planningUid1>' has loaded
    And I wait until today's train '<planningUid2>' has loaded
    And I am viewing the map gw2aslough.v
    And berth '1629' in train describer 'D1' contains '<trainNum>' and is visible
    And I invoke the context menu on the map for train <trainNum>
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And no matched service is visible
    And the unmatched search results show the following 4 results
      | trainNumber | planUID        | status   | sched | date     | origin | originTime | dest    |
      | <trainNum>  | <planningUid1> | UNCALLED | LTP   | today    | PADTON | now - 5    | OXFD    |
      | <trainNum>  | <planningUid2> | UNCALLED | LTP   | today    | PADTON | now - 30   | DIDCOTP |
      | <trainNum>  | <planningUid1> | UNCALLED | LTP   | tomorrow | PADTON | now - 5    | OXFD    |
      | <trainNum>  | <planningUid2> | UNCALLED | LTP   | tomorrow | PADTON | now - 30   | DIDCOTP |
    When I select to match the result for todays service with planning Id '<planningUid2>'
    Then the matched service uid is shown as '<planningUid2>'
    And the unmatched search results show the following 4 results
      | trainNumber | planUID        | status    | sched | date     | origin | originTime | dest    |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | today    | PADTON | now - 5    | OXFD    |
      | <trainNum>  | <planningUid2> | ACTIVATED | LTP   | today    | PADTON | now - 30   | DIDCOTP |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | tomorrow | PADTON | now - 5    | OXFD    |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | tomorrow | PADTON | now - 30   | DIDCOTP |

    Examples:
      | trainNum  | planningUid1 | planningUid2 |
      | generated | L12005       | L12006       |

  @bug @bug:79090
  # Used to be flaky - see 68327
  Scenario Outline: 34002:6b Make Match - matching unmatched step to a matched service - and checking matching change shows on map
    * I remove today's train '<planningUid1>' from the Redis trainlist
    * I remove today's train '<planningUid2>' from the Redis trainlist
    And the following live berth interpose message is sent from LINX (to set up unmatched train on map at Uffington)
      | toBerth | trainDescriber | trainDescription |
      | 1115    | D7             | <trainNum>       |
    And the train in CIF file below is updated accordingly so time at the reference point is now + 1 minute, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | SDON        | WTT_arr       | <trainNum>          | <planningUid1> |
    And the train in CIF file below is updated accordingly so time at the reference point is now + 1 minute, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN     | WTT_dep       | <trainNum>          | <planningUid2> |
    And I wait until today's train '<planningUid1>' has loaded
    And I wait until today's train '<planningUid2>' has loaded
    And the following live berth interpose message is sent from LINX (to create a match at Swindon)
      | toBerth | trainDescriber | trainDescription |
      | 1201    | D7             | <trainNum>       |
    And I am viewing the map gw05swindon.v
    And berth '1115' in train describer 'D7' contains '<trainNum>' and is visible
    And berth '1201' in train describer 'D7' contains '<trainNum>' and is visible
    And the train headcode color for berth 'D71115' is lightgrey
    And the train headcode color for berth 'D71201' is green
    And I right click on berth with id 'D71115'
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And no matched service is visible
    And the unmatched search results show the following 4 results
      | trainNumber | planUID        | status   | sched | date     | origin  | originTime | dest    |
      | <trainNum>  | <planningUid1> | UNCALLED | LTP   | today    | PADTON  | now - 71   | SWANSEA |
      | <trainNum>  | <planningUid2> | UNCALLED | LTP   | today    | RDNGSTN | now - 0    | PADTON  |
      | <trainNum>  | <planningUid1> | UNCALLED | LTP   | tomorrow | PADTON  | now - 71   | SWANSEA |
      | <trainNum>  | <planningUid2> | UNCALLED | LTP   | tomorrow | RDNGSTN | now - 0    | PADTON  |
    When I select to match the result for todays service with planning Id '<planningUid1>'
    Then the matched service uid is shown as '<planningUid1>'
    And the unmatched search results show the following 4 results
      | trainNumber | planUID        | status    | sched | date     | origin  | originTime | dest    |
      | <trainNum>  | <planningUid1> | ACTIVATED | LTP   | today    | PADTON  | now - 71   | SWANSEA |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | today    | RDNGSTN | now - 0    | PADTON  |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | tomorrow | PADTON  | now - 71   | SWANSEA |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | tomorrow | RDNGSTN | now - 0    | PADTON  |
    And I switch to the second-newest tab
    And the train headcode color for berth 'D71115' is green
    And the train headcode color for berth 'D71201' is grey

    Examples:
      | trainNum | planningUid1 | planningUid2 |
      | 1C13     | L12007       | L12008       |

  @tdd @ref_50351
  Scenario Outline: 34002:7a Make Rematch - matching matched step to an unmatched service
#    Given the user is viewing the manual matching view
#    And the user has the schedule matching role
#    And the user is presented with at least one new schedule to match with (other than the currently matched schedule)
#    When the user selects an entry to match
#    Then the system will create a match
#    And unmatching the previously match service
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid1> |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid2> |
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainNum>' with schedule id '<planningUid2>' for today is visible on the trains list
    And the following live berth interpose message is sent from LINX (to create a match at Paddington)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | <trainNum>       |
    And I am viewing the map hdgw01paddington.v
    And the train headcode color for berth 'D3A007' is green
    And I right click on berth with id 'D3A007'
    And the map context menu contains 'Unmatch / Rematch' on line 3
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the matched service uid is shown as '<planningUid1>'
    And the unmatched search results show the following 2 results
      | trainNumber | planUID        | status    | sched | date     | origin | originTime | dest    |
      | <trainNum>  | <planningUid1> | ACTIVATED | LTP   | today    | PADTON | now - 0    | OXFD    |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | today    | PADTON | now - 0    | DIDCOTP |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | tomorrow | PADTON | now - 0    | OXFD    |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | tomorrow | PADTON | now - 0    | DIDCOTP |
    When I select to match the result for todays service with planning Id '<planningUid2>'
    Then the matched service uid is shown as '<planningUid2>'
    And the unmatched search results show the following 2 results
      | trainNumber | planUID        | status    | sched | date     | origin | originTime | dest    |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | today    | PADTON | now - 0    | OXFD    |
      | <trainNum>  | <planningUid2> | ACTIVATED | LTP   | today    | PADTON | now - 0    | DIDCOTP |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | tomorrow | PADTON | now - 0    | OXFD    |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | tomorrow | PADTON | now - 0    | DIDCOTP |
    And I switch to the second-newest tab
    And the train headcode color for berth 'D3A007' is green

    Examples:
      | trainNum | planningUid1 | planningUid2 |
      | 1C14     | L12009       | L12010       |

  @tdd @ref_50351
  Scenario Outline: 34002:7b Make ReMatch - matching matched step to a different matched service
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | TWYFORD     | WTT_pass      | <trainNum>          | <planningUid1> |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | SLOUGH      | WTT_pass      | <trainNum>          | <planningUid2> |
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainNum>' with schedule id '<planningUid2>' for today is visible on the trains list
    And the following live berth interpose message is sent from LINX (to create a match at Twyford)
      | toBerth | trainDescriber | trainDescription |
      | 1630    | D1             | <trainNum>       |
    And the following live berth interpose message is sent from LINX (to create a match at Slough)
      | toBerth | trainDescriber | trainDescription |
      | 0514    | D6             | <trainNum>       |
    And I am viewing the map gw2aslough.v
    And the headcode displayed for 'D11630' is <trainNum>
    And the headcode displayed for 'D60514' is <trainNum>
    And the train headcode color for berth 'D11630' is green
    And the train headcode color for berth 'D60514' is green
    And I right click on berth with id 'D11630'
    And the map context menu contains 'Unmatch / Rematch' on line 3
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the matched service uid is shown as '<planningUid1>'
    And the unmatched search results show the following 2 results
      | trainNumber | planUID        | status    | sched | date     | origin  | originTime | dest   |
      | <trainNum>  | <planningUid1> | ACTIVATED | LTP   | today    | RDNGSTN | now - 6    | PADTON |
      | <trainNum>  | <planningUid2> | ACTIVATED | LTP   | today    | RDNGSTN | now - 21   | PADTON |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | tomorrow | RDNGSTN | now - 6    | PADTON |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | tomorrow | RDNGSTN | now - 21   | PADTON |
    When I select to match the result for todays service with planning Id '<planningUid2>'
    Then the matched service uid is shown as '<planningUid2>'
    And the unmatched search results show the following 2 results
      | trainNumber | planUID        | status    | sched | date     | origin  | originTime | dest   |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | today    | RDNGSTN | now - 6    | PADTON |
      | <trainNum>  | <planningUid2> | ACTIVATED | LTP   | today    | RDNGSTN | now - 21   | PADTON |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | tomorrow | RDNGSTN | now - 6    | PADTON |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | tomorrow | RDNGSTN | now - 21   | PADTON |
    And I switch to the second-newest tab
    And the train headcode color for berth 'D11630' is red
    And the train headcode color for berth 'D60514' is lightgrey

    Examples:
      | trainNum | planningUid1 | planningUid2 |
      | 1C15     | L12011       | L12012       |

  @tdd @ref_50351
  Scenario Outline: 34002:8 Unmatch
#    Given the user is viewing the manual matching view
#    And the user has the matching role
#    And the user is presented with at least one new schedule to match with (other than the currently matched schedule)
#    When the user opts not to match to any services
#    Then the system will unmatch the service
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | WEALING     | WTT_pass      | <trainNum>          | <planningUid1> |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P77_RDNGSTN_PADTON.cif | ACTONW      | WTT_pass      | <trainNum>          | <planningUid2> |
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainNum>' with schedule id '<planningUid2>' for today is visible on the trains list
    And the following live berth interpose message is sent from LINX (to create a match at West Ealing)
      | toBerth | trainDescriber | trainDescription |
      | 0214    | D3             | <trainNum>       |
    And I am viewing the map gw2aslough.v
    And the headcode displayed for 'D30214' is <trainNum>
    And the train headcode color for berth 'D30214' is green
    And I right click on berth with id 'D30214'
    And the map context menu contains 'Unmatch / Rematch' on line 3
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the matched service uid is shown as '<planningUid1>'
    And the unmatched search results show the following 2 results
      | trainNumber | planUID        | status    | sched | date     | origin  | originTime | dest   |
      | <trainNum>  | <planningUid1> | ACTIVATED | LTP   | today    | RDNGSTN | now - 38   | PADTON |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | today    | RDNGSTN | now - 43   | PADTON |
      | <trainNum>  | <planningUid1> | UNCALLED  | LTP   | tomorrow | RDNGSTN | now - 38   | PADTON |
      | <trainNum>  | <planningUid2> | UNCALLED  | LTP   | tomorrow | RDNGSTN | now - 43   | PADTON |
    When I un-match the currently matched schedule
    Then no matched service is visible
    And the unmatched search results show the following 2 results
      | trainNumber | planUID        | status   | sched | date     | origin  | originTime | dest   |
      | <trainNum>  | <planningUid1> | UNCALLED | LTP   | today    | RDNGSTN | now - 38   | PADTON |
      | <trainNum>  | <planningUid2> | UNCALLED | LTP   | today    | RDNGSTN | now - 43   | PADTON |
      | <trainNum>  | <planningUid1> | UNCALLED | LTP   | tomorrow | RDNGSTN | now - 38   | PADTON |
      | <trainNum>  | <planningUid2> | UNCALLED | LTP   | tomorrow | RDNGSTN | now - 43   | PADTON |
    And I switch to the second-newest tab
    And the train headcode color for berth 'D30214' is lightgrey

    Examples:
      | trainNum | planningUid1 | planningUid2 |
      | 1C16     | L12013       | L12014       |
