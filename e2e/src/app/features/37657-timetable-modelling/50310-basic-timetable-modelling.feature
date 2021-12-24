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
      | 4F05             | A53765   | 2020-01-01   | 2050-12-01 | P            | LTP         |
      | 4F06             | A63765   | 2020-01-01   | 2050-12-01 | N            | STP         |

  Scenario Outline: 37657-4 Base Schedule is displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # And no other STPs have been received for that service
    # When a user searches for that timetable
    # Then one timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And I generate a new trainUID
    * I remove today's train 'generatedTrainUId' from the Redis trainlist
    And the access plan located in CIF file '<fileName>' is received from LINX with the new uid
    And I wait until today's train 'generatedTrainUId' has loaded
    When I search Timetable for 'generatedTrainUId' and wait for result
      | PlanningUid       | Scheduletype  |
      | generatedTrainUId | <displayType> |
    Then one result is returned for today with that planning UID generatedTrainUId and it has status <statusType> and sched <displayType> and service <trainDescription>

    Examples:
      | fileName                            | trainDescription | statusType | displayType |
      | access-plan/schedules_BS_type_P.cif | 1W21             | UNCALLED   | LTP         |
      | access-plan/schedules_BS_type_N.cif | 1W22             | UNCALLED   | STP         |

  Scenario Outline: 37657-5 Schedule Cancellation is displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then one timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And I generate a new trainUID
    And the access plan located in CIF file '<fileName>' is received from LINX with the new uid
    And I give the cancellation 5 seconds to load
    When I search Timetable for 'generatedTrainUId' and wait for result
      | PlanningUid       | Scheduletype  |
      | generatedTrainUId | <displayType> |
    Then one result is returned for today with that planning UID generatedTrainUId and it has status <statusType> and sched <displayType> and service <trainDescription>
    Examples:
      | fileName                                | trainDescription | statusType | displayType |
      | access-plan/schedules_BS_type_C.cif     | 1W23             | CANCELLED  | CAN         |
      | access-plan/schedules_BS_type_P_C.cif   | 1W24             | CANCELLED  | CAN         |
      | access-plan/schedules_BS_type_P_O_C.cif | 1W25             | CANCELLED  | CAN         |
      | access-plan/schedules_BS_type_N_C.cif   | 1W26             | CANCELLED  | CAN         |
      | access-plan/schedules_BS_type_N_O_C.cif | 1W27             | CANCELLED  | CAN         |

  Scenario Outline: 37657-6 Schedule Overlay is displayed
    # Given multiple schedules has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then one timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And I generate a new trainUID
    * I remove today's train 'generatedTrainUId' from the Redis trainlist
    And the access plan located in CIF file '<fileName>' is received from LINX with the new uid
    * I wait until today's train 'generatedTrainUId' has loaded
    When I search Timetable for 'generatedTrainUId' and wait for result
      | PlanningUid       | Scheduletype  |
      | generatedTrainUId | <displayType> |
    Then one result is returned for today with that planning UID generatedTrainUId and it has status <statusType> and sched <displayType> and service <trainDescription>
    Examples:
      | fileName                              | trainDescription | statusType | displayType |
      | access-plan/schedules_BS_type_O.cif   | 1W28             | UNCALLED   | VAR         |
      | access-plan/schedules_BS_type_P_O.cif | 1W29             | UNCALLED   | VAR         |
      | access-plan/schedules_BS_type_N_O.cif | 1W30             | UNCALLED   | VAR         |

  Scenario Outline: 37657-7a Multiple schedules with the same precedence (not cancelled)
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then newest version of the timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And I generate a new trainUID
    * I remove today's train 'generatedTrainUId' from the Redis trainlist
    And the access plan located in CIF file '<fileName>' is received from LINX with the new uid
    * I wait until today's train 'generatedTrainUId' has loaded
    When I search Timetable for 'generatedTrainUId' and wait for result
      | PlanningUid       | Scheduletype  |
      | generatedTrainUId | <displayType> |
    Then one result is returned for today with that planning UID generatedTrainUId and it has status <statusType> and sched <displayType> and service <trainDescription>
    Examples:
      | fileName                              | trainDescription | statusType | displayType |
      | access-plan/schedules_BS_type_P_P.cif | 1W41             | UNCALLED   | LTP         |
      | access-plan/schedules_BS_type_O_O.cif | 1W42             | UNCALLED   | VAR         |
      | access-plan/schedules_BS_type_N_N.cif | 1W43             | UNCALLED   | STP         |

  Scenario Outline: 37657-7b Multiple schedules with the same precedence (cancelled)
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user searches for that timetable
    # Then newest version of the timetable with the planning UID and schedule date is returned and the type is <DisplayType>
    Given I am on the home page
    And I generate a new trainUID
    And the access plan located in CIF file '<fileName>' is received from LINX with the new uid
    And I give the cancellation 5 seconds to load
    When I search Timetable for 'generatedTrainUId' and wait for result
      | PlanningUid       | Scheduletype  |
      | generatedTrainUId | <displayType> |
    Then one result is returned for today with that planning UID generatedTrainUId and it has status <statusType> and sched <displayType> and service <trainDescription>
    Examples:
      | fileName                              | trainDescription | statusType | displayType |
      | access-plan/schedules_BS_type_C_C.cif | 1W44             | CANCELLED  | CAN         |

  Scenario Outline: 37657-8 Schedule details content are displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user views  that timetable
    # Then the timetable is displayed with the type is <DisplayType>
    # And the Train UID from the schedule
    # And the headcode from the schedule
    # And Details displayed match those provided in the CIF
    * I remove today's train '<trainUid>' from the Redis trainlist
    Given the access plan located in CIF file '<fileName>' is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
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

  Scenario Outline: 37657-9 Schedule locations are displayed
    # Given schedule(s) has been received with <STP indicator> that applies to the current time period (Date Runs To, Date Runs From and Days Run don't exclude it)
    # When a user views that timetable with inserted locations turned off
    # Then the locations displayed match those provided in the CIF
    * I remove today's train '<trainUid>' from the Redis trainlist
    Given the access plan located in CIF file '<fileName>' is received from LINX
    * I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
    Then The timetable entries contains the following data
      | rowNum | location               | locInstance | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1      | London Paddington      | 1           |                    | 09:33           |                   | 09:33          | 12                |                  | 4                |            | TB         |                 |              |           |          |          |             |
      | 2      | Royal Oak Junction     | 1           |                    | 09:34           |                   |                |                   | 4                | 4                |            |            |                 |              |           |          |          |             |
      | 3      | Portobello Jn (London) | 1           |                    | 09:35           |                   |                |                   | 4                | 4                |            |            |                 |              |           |          |          |             |
      | 4      | Ladbroke Grove         | 1           |                    | 09:36           |                   |                |                   | 4                | RL               |            |            |                 |              |           |          |          |             |
      | 5      | Acton West             | 1           |                    | 09:39:30        |                   |                |                   | RL               | RL               |            |            |                 |              |           |          |          |             |
      | 6      | Ealing Broadway        | 1           | 09:40:30           | 09:41:30        | 09:41             | 09:41          | 3                 | RL               | RL               | (2.5)      | T          |                 |              |           |          |          |             |
      | 7      | Southall               | 1           | 09:48:30           | 09:49:30        | 09:49             | 09:49          | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 8      | Hayes & Harlington     | 1           | 09:52:30           | 09:53:30        | 09:53             | 09:53          | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 9      | Heathrow Airport Jn    | 1           |                    | 09:54           |                   |                |                   | RL               | RL               |            |            |                 |              |           |          |          |             |
      | 10     | West Drayton           | 1           | 09:56:30           | 09:57           | 09:57             | 09:57          | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 11     | Iver                   | 1           | 09:59:30           | 10:00           | 10:00             | 10:00          | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 12     | Langley                | 1           | 10:02              | 10:02:30        | 10:02             | 10:02          | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 13     | Slough                 | 1           | 10:05:30           | 10:06:30        | 10:06             | 10:06          | 4                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 14     | Burnham                | 1           | 10:09:30           | 10:10           | 10:10             | 10:10          | 1                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 15     | Taplow                 | 1           | 10:12:30           | 10:13           | 10:13             | 10:13          | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 16     | Maidenhead             | 1           | 10:15:30           | 10:16:30        | 10:16             | 10:16          | 3                 | RL               | RL               |            | T          |                 |              |           |          |          |             |
      | 17     | Twyford                | 1           | 10:23:30           | 10:23:30        | 10:23             | 10:23          | 3                 | RL               | RL               | [1]        | T          |                 |              |           |          |          |             |
      | 18     | Kennet Bridge Jn       | 1           |                    | 10:28:30        |                   |                |                   | RL               | DRL              |            |            |                 |              |           |          |          |             |
      | 19     | Reading                | 1           | 10:31              |                 | 10:31             |                | 14                | DRL              |                  |            | TF         |                 |              |           |          |          |             |
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
    * I remove today's train 'L77777' from the Redis trainlist
    Given the access plan located in CIF file 'access-plan/1D46_PADTON_OXFD.cif' is received from LINX
    And I wait until today's train 'L77777' has loaded
    And I am on the timetable view for service 'L77777'
    When I switch to the timetable details tab
    Then The timetable details tab is visible
    And The entry of the change en route table contains the following data
      | columnName |
      | Acton West |
      | DMU        |
      | 811        |
      | 144mph     |
      | D,B,A      |
