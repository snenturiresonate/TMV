Feature: 51586 - Path Extrapolation - Off plan and unscheduled

  As a TMV user
  I want predicted timings and punctuality to be calculated
  So that I can see how the train is expected to progress compared to its timetable

  Background:
    Given I reset redis

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
      | Birmingham New Street    | 1        |            | (22:30)    | 2B       |      |      |
      | Soho South Jn            | 1        |            | (22:34)    |          |      |      |
      | Galton Jn                | 1        |            | (22:35:30) |          |      |      |
      | Dudley Port              | 1        |            | (22:38:30) |          |      |      |
      | Wolverhampton            | 1        | (22:47)    | (22:48:30) | 2        |      |      |
      | Wolverhampton North Jn   | 1        |            | (22:50)    |          |      |      |
      | Bushbury Jn              | 1        |            | (22:51)    |          |      |      |
      | Penkridge                | 1        |            | (22:56)    |          |      |      |
      | Stafford Trent Valley Jn | 1        |            | (23:00)    |          |      | SL   |
      | Stafford                 | 1        | (23:01)    | (23:05:30) | 5        | SL   | SL   |
      | Searchlight Lane Jn      | 1        |            | (23:08)    |          | SL   | DNB  |
      | Yarnfield Jn             | 1        |            | (23:09)    |          |      |      |
      | Stone                    | 1        |            | (23:11:30) |          |      |      |
      | Stoke Jn                 | 1        |            | (23:17:30) |          |      |      |
      | Stoke-On-Trent           | 1        | (23:20)    | (23:22:30) | 2        |      |      |
      | Kidsgrove                | 1        |            | (23:31:30) |          |      |      |
      | Alsager                  | 1        |            | (23:35:30) |          |      |      |
      | Barthomley Jn            | 1        |            | (23:38:30) |          |      |      |
      | Crewe Sth Jn Nth Staff J | 1        |            | (23:41:30) | UDP      |      |      |
      | Crewe                    | 1        |            | (23:44:30) | 1        |      |      |
      | Crewe Sydney Bridge      | 1        |            | (23:47)    |          |      | FL   |
      | Sandbach                 | 1        |            | (23:50)    | 2        | FL   |      |
      | Alderley Edge            | 1        |            | (23:57:30) |          |      |      |
      | Wilmslow                 | 1        |            | (23:59)    | 1        |      |      |
      | Heald Green South Jn     | 1        |            | (00:01:30) |          |      |      |
      | Heald Green              | 1        |            | (00:04)    | 1        |      |      |
      | Slade Lane Jn            | 1        |            | (00:10)    |          |      | SL   |
      | Ardwick Jn               | 1        |            | (00:11:30) |          | SL   | SL   |
      | Manchester Piccadilly    | 1        | (00:15)    |            | 10       | SL   |      |

    Examples:
      | cif                                      | trainDescription | trainUid |
      | access-plan/51586-schedules/51586-22.cif | 5A22             | A50022   |
