Feature: 51586 - Path Extrapolation - Off plan and unscheduled

  As a TMV user
  I want predicted timings and punctuality to be calculated
  So that I can see how the train is expected to progress compared to its timetable

  Background:
    Given I reset redis

  @bug @72055
  Scenario Outline: 51586 - 30 Display attention indicator for off plan train (TD)
    * I remove today's train '<trainUid>' from the trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1W06_EUSTON_BHAMNWS.cif | EUSTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth step message is sent from LINX (to move train)
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    When I am on the timetable view for service '<trainUid>'
    Then the punctuality is displayed as '<punctuality>'
    And the navbar punctuality indicator is displayed as '<indicatorColour>'

    Examples:
      | trainDescription | trainUid | fromBerth | toBerth | trainDescriber | punctuality | indicatorColour |
      | 1B30             | A51586   | C009      | 0818    | WY             | Off route   | blue            |
      | 1B30             | A51586   | A001      | 0743    | WY             | Off route   | blue            |
      | 1B30             | A51586   | 0165      | A374    | WJ             | Off route   | blue            |

  @flaky @manual
  Scenario Outline: 51586 - 31 Over midnight
    Given I am on the home page
    And the access plan located in CIF file '<cif>' is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | 22                  | 22:30                  | 99999               | BHAMNWS                | today         |
    When I am on the timetable view for service '<trainUid>'
    And I give the timetable 2 second to load
    Then the actual/predicted values are
      | location                 | instance | arrival    | departure  | platform | path | line |
      | Birmingham New Street    | 1        |            | (22:30:00) | 2B       |      |      |
      | Soho South Jn            | 1        |            | (22:34:00) |          |      |      |
      | Galton Jn                | 1        |            | (22:35:30) |          |      |      |
      | Dudley Port              | 1        |            | (22:38:00) |          |      |      |
      | Wolverhampton            | 1        | (22:47:00) | (22:48:30) | 2        |      |      |
      | Wolverhampton North Jn   | 1        |            | (22:50:00) |          |      |      |
      | Bushbury Jn              | 1        |            | (22:51:00) |          |      |      |
      | Penkridge                | 1        |            | (22:56:00) |          |      |      |
      | Stafford Trent Valley Jn | 1        |            | (23:00:00) |          |      | SL   |
      | Stafford                 | 1        | (23:01:00) | (23:05:30) | 5        | SL   | SL   |
      | Searchlight Lane Jn      | 1        |            | (23:08:00) |          | SL   | DNB  |
      | Yarnfield Jn             | 1        |            | (23:09:00) |          |      |      |
      | Stone                    | 1        |            | (23:11:30) |          |      |      |
      | Stoke Jn                 | 1        |            | (23:17:30) |          |      |      |
      | Stoke-On-Trent           | 1        | (23:20:00) | (23:22:30) | 2        |      |      |
      | Kidsgrove                | 1        |            | (23:31:30) |          |      |      |
      | Alsager                  | 1        |            | (23:35:30) |          |      |      |
      | Barthomley Jn            | 1        |            | (23:38:30) |          |      |      |
      | Crewe Sth Jn Nth Staff J | 1        |            | (23:41:30) | UDP      |      |      |
      | Crewe                    | 1        |            | (23:44:30) | 1        |      |      |
      | Crewe Sydney Bridge      | 1        |            | (23:47:00) |          |      | FL   |
      | Sandbach                 | 1        |            | (23:50:00) | 2        | FL   |      |
      | Alderley Edge            | 1        |            | (23:58:00) |          |      |      |
      | Wilmslow                 | 1        |            | (23:59:30) | 1        |      |      |
      | Heald Green South Jn     | 1        |            | (00:02:00) |          |      |      |
      | Heald Green              | 1        |            | (00:04:30) | 1        |      |      |
      | Slade Lane Jn            | 1        |            | (00:10:30) |          |      | SL   |
      | Ardwick Jn               | 1        |            | (00:12:00) |          | SL   | SL   |
      | Manchester Piccadilly    | 1        | (00:15:30) |            | 10       | SL   |      |

    Examples:
      | cif                                      | trainDescription | trainUid |
      | access-plan/51586-schedules/51586-22.cif | 5A22             | A50022   |
