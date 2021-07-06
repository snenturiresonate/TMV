Feature: 37657 - Basic Timetable Modelling

  As a TMV user
  I want the schedules received in a CIF format to be transformed and loaded into TMV as agreed and current timetables
  So that the data is available for the system to use schedule match and display purposes

  Background:
    Given I remove all trains from the trains list

  Scenario Outline: 37657-1 Old Schedules are not displayed
    # Given a schedule has been received with <STP indicator> which has a 'Date Runs To' before the current time period
    # When a user searches for that timetable
    # Then no results are returned with that planning UID and schedule date
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule has a Date Run to of '<dateRunsTo>'
    And the schedule is received from LINX
    When I search Train for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | dateRunsTo | stpIndicator | displayType |
      | 4F01             | A137657  | 2020-01-01   | yesterday  | P            | LTP         |
      | 4F02             | A237657  | 2020-01-01   | yesterday  | N            | STP         |

  Scenario Outline: 37657-2 Future Schedules are not displayed
    # Given a schedule has been received with <STP indicator>which has a 'Date Runs From' after the current time period
    # When a user searches for that timetable
    # Then no results are returned with that planning UID and schedule date
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule is received from LINX
    When I search Train for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | stpIndicator | displayType |
      | 4F03             | A337657  | tomorrow     | P            | LTP         |
      | 4F04             | A437657  | tomorrow     | N            | STP         |

  Scenario Outline: 37657-3 Days run outside current time period are not displayed
    # Given a schedule has been received with <STP indicator> where the 'Days Runs' is not in the current time period
    # When a user searches for that timetable
    # Then no results are returned with that planning UID and schedule date
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule does not run on a day that is today
    And the schedule is received from LINX
    When I search Train for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | dateRunsTo | stpIndicator | displayType |
      | 4F05             | A537657  | 2020-01-01   | 2050-12-01 | P            | LTP         |
      | 4F06             | A637657  | 2020-01-01   | 2050-12-01 | N            | STP         |

  @bug @task:62113 @flaky
  Scenario Outline: 37657-4 Base Schedule is displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # And no other STPs have been received for that service
    # When a user searches for that timetable
    # Then one timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    When I search Timetable for '<trainUid>' and wait for result
      | PlanningUid | Scheduletype  |
      | <trainUid>  | <displayType> |
    Then one result is returned for today with that planning UID <trainUid> and it has status <statusType> and sched <displayType> and service <trainDescription>

    Examples:
      | fileName                            | trainDescription | trainUid | statusType | displayType |
      | access-plan/schedules_BS_type_P.cif | 1W21             | W12145   | UNCALLED   | LTP         |
      | access-plan/schedules_BS_type_N.cif | 1W22             | W12245   | UNCALLED   | STP         |

  @bug @bug_61549
  Scenario Outline: 37657-5 Schedule Cancellation is displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then one timetable with the planning UID and schedule date is returned and the type is <DisplayType>
#    ***Can't check for load via Trains List here as cancelled services may not show*****
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    And I give the system 3 seconds to load
    When I search Timetable for '<trainUid>' and wait for result
      | PlanningUid | Scheduletype  |
      | <trainUid>  | <displayType> |
    Then one result is returned for today with that planning UID <trainUid> and it has status <statusType> and sched <displayType> and service <trainDescription>
    Examples:
      | fileName                                | trainDescription | trainUid | statusType | displayType |
      | access-plan/schedules_BS_type_C.cif     | 1W23             | W12345   | CANCELLED  | CAN         |
      | access-plan/schedules_BS_type_P_C.cif   | 1W24             | W12445   | CANCELLED  | CAN         |
      | access-plan/schedules_BS_type_P_O_C.cif | 1W25             | W12545   | CANCELLED  | CAN         |
      | access-plan/schedules_BS_type_N_C.cif   | 1W26             | W12645   | CANCELLED  | CAN         |
      | access-plan/schedules_BS_type_N_O_C.cif | 1W27             | W12745   | CANCELLED  | CAN         |

  @bug @bug_61549
  Scenario Outline: 37657-6 Schedule Overlay is displayed
    # Given multiple schedules has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then one timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    When I search Timetable for '<trainUid>' and wait for result
      | PlanningUid | Scheduletype  |
      | <trainUid>  | <displayType> |
    Then one result is returned for today with that planning UID <trainUid> and it has status <statusType> and sched <displayType> and service <trainDescription>
    Examples:
      | fileName                              | trainDescription | trainUid | statusType | displayType |
      | access-plan/schedules_BS_type_O.cif   | 1W28             | W12845   | UNCALLED   | VAR         |
      | access-plan/schedules_BS_type_P_O.cif | 1W29             | W12945   | UNCALLED   | VAR         |
      | access-plan/schedules_BS_type_N_O.cif | 1W30             | W13045   | UNCALLED   | VAR         |

  @bug @bug_61549
  Scenario Outline: 37657-7a Multiple schedules with the same precedence (not cancelled)
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then newest version of the timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<trainUid>' for today is visible on the trains list
    When I search Timetable for '<trainUid>' and wait for result
      | PlanningUid | Scheduletype  |
      | <trainUid>  | <displayType> |
    Then one result is returned for today with that planning UID <trainUid> and it has status <statusType> and sched <displayType> and service <trainDescription>
    Examples:
      | fileName                              | trainDescription | trainUid | statusType | displayType |
      | access-plan/schedules_BS_type_P_P.cif | 1W41             | W13145   | UNCALLED   | LTP         |
      | access-plan/schedules_BS_type_O_O.cif | 1W42             | W13245   | UNCALLED   | VAR         |
      | access-plan/schedules_BS_type_N_N.cif | 1W43             | W13345   | UNCALLED   | STP         |

  @bug @bug_61549
  Scenario Outline: 37657-7b Multiple schedules with the same precedence (cancelled)
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then newest version of the timetable with the planning UID and schedule date is returned and the type is <DisplayType>
#    ***Can't check for load via Trains List here as cancelled services may not show*****
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    And I give the system 3 seconds to load
    When I search Timetable for '<trainUid>' and wait for result
      | PlanningUid | Scheduletype  |
      | <trainUid>  | <displayType> |
    Then one result is returned for today with that planning UID <trainUid> and it has status <statusType> and sched <displayType> and service <trainDescription>
    Examples:
      | fileName                              | trainDescription | trainUid | statusType | displayType |
      | access-plan/schedules_BS_type_C_C.cif | 1W34             | W13445   | CANCELLED  | CAN         |

  Scenario Outline: 37657-8 Schedule details content are displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user views  that timetable
    # Then the timetable is displayed with the type is <DisplayType>
    # And the Train UID from the schedule
    # And the headcode from the schedule
    # And Details displayed match those provided in the CIF
    Given the access plan located in CIF file '<fileName>' is received from LINX
    Given I am on the trains list page
    And The trains list table is visible
    And train '<trainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDesc>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    When I open timetable from the context menu
    And I switch to the new tab
    Then The values for the header properties are as follows
      | headCode    | schedType      | lastSignal | lastReport | trainUid   | trustId | lastTJM |
      | <trainDesc> | <scheduleType> |            |            | <trainUid> |         |         |
    And I switch to the timetable details tab
    And The timetable details tab is visible
    And The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 01/01/2020 to 01/01/2050 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             |         | ET       | 24749000         | <status>        | XX            |           |              | 1     | S            |              | 345        | E         | 90mph |           | m           | D                            |                 |
    Examples:
      | fileName                            | trainUid | scheduleType | trainDesc | status |
      | access-plan/schedules_BS_type_P.cif | W12145   | LTP          | 1W21      | P      |
      | access-plan/schedules_BS_type_N.cif | W12245   | STP          | 1W22      | N      |
      | access-plan/schedules_BS_type_O.cif | W12845   | VAR          | 1W28      | O      |

    @bug @bug_63590
    Scenario Outline: 37657-9 Schedule locations are displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user views that timetable with inserted locations turned off
    # Then the locations displayed match those provided in the CIF
    Given the access plan located in CIF file '<fileName>' is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDesc>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    When I open timetable from the context menu
    And I switch to the new tab
    Then The timetable entries contains the following data
      | rowNum | location               | locInstance | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1      | London Paddington      | 1           |                    | 09:33:00        |                   | 09:33:00       | 12                |                  | 4                |            | TB         |                 |              |           |          |          |             |
      | 2      | Royal Oak Junction     | 1           |                    | 09:34:00        |                   |                |                   | 4                | 4                |            |            |                 |              |           |          |          |             |
      | 3      | Portobello Jn (London) | 1           |                    | 09:35:00        |                   |                |                   | 4                | 4                |            |            |                 |              |           |          |          |             |
      | 4      | Ladbroke Grove         | 1           |                    | 09:36:00        |                   |                |                   | 4                | RL               |            |            |                 |              |           |          |          |             |
      | 5      | Acton West             | 1           |                    | 09:39:30        |                   |                |                   | RL               | RL               |            |            |                 |              |           |          |          |             |
      | 6      | Ealing Broadway        | 1           | 09:40:30           | 09:41:30        | 09:41:00          | 09:41:00       | 3                 | RL               | RL               | (2.5)      | T          |                 |              |           |          |          |             |
      | 7      | Southall               | 1           | 09:48:30           | 09:49:30        | 09:49:00          | 09:49:00       | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 8      | Hayes & Harlington     | 1           | 09:52:30           | 09:53:30        | 09:53:00          | 09:53:00       | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 9      | Heathrow Airport Jn    | 1           |                    | 09:54:00        |                   |                |                   | RL               | RL               |            |            |                 |              |           |          |          |             |
      | 10     | West Drayton           | 1           | 09:56:30           | 09:57:00        | 09:57:00          | 09:57:00       | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 11     | Iver                   | 1           | 09:59:30           | 10:00:00        | 10:00:00          | 10:00:00       | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 12     | Langley                | 1           | 10:02:00           | 10:02:30        | 10:02:00          | 10:02:00       | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 13     | Slough                 | 1           | 10:05:30           | 10:06:30        | 10:06:00          | 10:06:00       | 4                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 14     | Burnham                | 1           | 10:09:30           | 10:10:00        | 10:10:00          | 10:10:00       | 1                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 15     | Taplow                 | 1           | 10:12:30           | 10:13:00        | 10:13:00          | 10:13:00       | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 16     | Maidenhead             | 1           | 10:15:30           | 10:16:30        | 10:16:00          | 10:16:00       | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 17     | Twyford                | 1           | 10:23:30           | 10:23:30        | 10:23:00          | 10:23:00       | 3                 | RL               | RL               | [1]        | T          |                 |              |           |          |          |             |
      | 18     | Kennet Bridge Jn       | 1           |                    | 10:28:30        |                   |                |                   | RL               | DRL              |            |            |                 |              |           |          |          |             |
      | 19     | Reading                | 1           | 10:31:00           |                 | 10:31:00          |                | 14                | DRL              |                  |            | TF         |                 |              |           |          |          |             |
    Examples:
      | fileName                            | trainUid | trainDesc |
      | access-plan/schedules_BS_type_P.cif | W12145   | 1W21      |
      | access-plan/schedules_BS_type_N.cif | W12245   | 1W22      |
      | access-plan/schedules_BS_type_O.cif | W12845   | 1W28      |

  @bug @bug_61861 @bug_61862
  Scenario Outline: 37657-10 Schedule associations are displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user views that timetable
    # Then the associations displayed match those provided in the CIF
    # ***** NB - CIF covers STP types P, O and N
    Given the access plan located in CIF file 'access-plan/associations_test.cif' is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDesc>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    And I open timetable from the context menu
    And I switch to the new tab
    When I switch to the timetable details tab
    And The timetable details tab is visible
    Then The timetable associations table contains the following entries
      | location   | type        | trainDescription |
      | <assocLoc> | <assocType> | <assocTrainDesc> |

    Examples:
      | trainDesc | trainUid | assocType        | assocLoc       | assocTrainDesc |
      | 2B99      | Y74849   | Next Working     | Swindon        | 2M39           |
      | 2M39      | L78729   | Previous Working | Swindon        | 2B99           |
      | 2M39      | L78729   | Next Working     | Westbury       | 2F97           |
      | 2G13      | L04499   | Join             | Purley         | 2P13           |
      | 2P13      | L06304   | Join             | Purley         | 2G13           |
      | 1H63      | G46338   | Split            | Haywards Heath | 1H65           |
      | 1H65      | W21919   | Split            | Haywards Heath | 1H63           |


  Scenario: 37657-11 Schedule change en route are displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user views that timetable
    # Then the change en route displayed match those provided in the CIF
    Given the access plan located in CIF file 'access-plan/1D46_PADTON_OXFD.cif' is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And train '1D46' with schedule id 'L77777' for today is visible on the trains list
    And I invoke the context menu for todays train '1D46' schedule uid 'L77777' from the trains list
    And I wait for the trains list context menu to display
    And I open timetable from the context menu
    And I switch to the new tab
    When I switch to the timetable details tab
    Then The timetable details tab is visible
    And The entry of the change en route table contains the following data
      | columnName |
      | Acton West |
      | DMU        |
      | 811        |
      | 144mph     |
      | D,B,A      |
