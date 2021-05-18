@test
Feature: 42006 - Path Extrapolation - Timings on the timetable

  As a TMV user
  I want the actual train movements to be incorporated into the schedule
  So that they can be displayed in the UI and used to predict future timings and punctuality

  Background:
    Given I remove all trains from the trains list

  Scenario Outline: 42006-1 Display calculated arrival time
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth interpose messages is sent from LINX
      | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I do nothing
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | trainDescriber | toBerth |
      #stopping #STAFFRD
      | access-plan/42006-schedules/42006-1.cif | C14256   | 1U32             | Stafford      | 13:50:00  | R3             | 5582    |
      #destination #EUSTON
      | access-plan/42006-schedules/42006-1.cif | C14256   | 1U32             | London Euston | 15:50:00  | WY             | B012    |

  Scenario Outline: 42006-2 Display calculated departure time
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | timestamp   | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I do nothing
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location            | timestamp | trainDescriber | fromBerth | toBerth |
      #Origin #Crewe
      | access-plan/42006-schedules/42006-2.cif | C14257   | 1U33             | Crewe               | 13:33:00  | CE             | A120      | 0104    |
      #Stopping #STAFFRD
      | access-plan/42006-schedules/42006-2.cif | C14257   | 1U33             | Stafford            | 13:56:00  | R3             | 5582      | 3580    |
      #Passing #HROW
      | access-plan/42006-schedules/42006-2.cif | C14257   | 1U33             | Harrow & Wealdstone | 15:38:00  | WJ             | 0142      | 0138    |

  Scenario Outline: 42006-3 Display calculated arrival time for a location that appears more than once
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | 3594      | 13:51:00  | 5582    | R3             | <trainDescription> |
      | 5582      | 13:51:30  | 4310    | R3             | <trainDescription> |
      | 1296      | 14:50:00  | 5582    | R3             | <trainDescription> |
    And I do nothing
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Arrival time for location "Stafford" instance 1 is correctly calculated based on "13:51:00"
    Then the actual/predicted Arrival time for location "Stafford" instance 2 is correctly calculated based on "14:50:00"

    Examples:
      | cif                                     | trainUid | trainDescription |
      | access-plan/42006-schedules/42006-3.cif | C14258   | 1U34             |

  Scenario Outline: 42006-3b Display calculated arrival time for a location that appears more than once - same location
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | 3594      | 13:51:00  | 5582    | R3             | <trainDescription> |
    And I do nothing
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Arrival time for location "Stafford" instance 1 is correctly calculated based on "13:51:00"
    And the actual/predicted Departure time for location "Stafford" instance 1 is predicted
    And the actual/predicted Arrival time for location "Stafford" instance 2 is predicted

    Examples:
      | cif                                      | trainUid | trainDescription |
      | access-plan/42006-schedules/42006-3b.cif | C14259   | 1U35             |

  @bug @bug:58193
  Scenario Outline: 42006-4 Display calculated departure time for a location that appears more than once
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When I step through the Berth Level Schedule for '<trainUid>'
    And I do nothing
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location>" instance 2 is correctly calculated based on "<timestamp2>"

    Examples:
      | cif                                     | trainUid | trainDescription | location         | timestamp | timestamp2 |
      #Origin
      | access-plan/42006-schedules/42006-4.cif | C14260   | 1U36             | Crewe            | 13:34:00  | 15:03:00   |
      #Stopping
      | access-plan/42006-schedules/42006-4.cif | C14260   | 1U36             | Stafford         | 13:55:30  | 14:55:30   |
      #Passing
      | access-plan/42006-schedules/42006-4.cif | C14260   | 1U36             | Rugeley North Jn | 14:05:00  | 14:43:00   |

  @bug @bug:61948
  Scenario Outline: 42006-5 Calculated arrival time for a location is not displayed when a TRI has already been received
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth interpose messages is sent from LINX
      | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> | 13                   |
    And I do nothing
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on "<triTimestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | trainDescriber | toBerth | triTimestamp | tiploc  | messageType            |
      #Stopping
      | access-plan/42006-schedules/42006-5.cif | C14261   | 1U37             | Stafford      | 13:50:00  | R3             | 5582    | 13:52:00     | STAFFRD | Arrival at Station     |
      #Destination
      | access-plan/42006-schedules/42006-5.cif | C14261   | 1U37             | London Euston | 15:52:00  | WY             | B012    | 15:53:00     | EUSTON  | Arrival at Termination |

  @bug @bug:61948
  Scenario Outline: 42006-6 Calculated departure time for a location is not displayed when a TRI has already been received
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | timestamp   | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> | 13                   |
    And I do nothing
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<triTimestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location | timestamp | trainDescriber | fromBerth | toBerth | triTimestamp | tiploc  | messageType            |
      | access-plan/42006-schedules/42006-6.cif | C14261   | 1U38             | Crewe    | 13:33:00  | CE             | A120      | 0104    | 13:34:00     | CREWE   | Departure from Origin  |
      | access-plan/42006-schedules/42006-6.cif | C14261   | 1U38             | Stafford | 13:50:00  | R3             | 5582      | 3580    | 13:52:00     | STAFFRD | Departure from Station |
      | access-plan/42006-schedules/42006-6.cif | C14261   | 1U38             | Colwich  | 15:52:00  | SK             | 0008      | 0005    | 15:53:00     | COLWICH | Passing Location       |

  Scenario Outline: 42006-7 Display calculated actual punctuality following an arrival
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I do nothing
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the Arrival punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<expectedArrivalTime>" & actual time "<timestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | expectedArrivalTime | trainDescriber | toBerth | fromBerth |
      #Destination
      | access-plan/42006-schedules/42006-7.cif | C14261   | 1U39             | London Euston | 15:50:00  | 15:52:00            | WY             | B012    | 0284      |

  Scenario Outline: 42006-8a Display calculated actual punctuality following an departure
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp    | toBerth         | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp>  | <toBerth>       | <trainDescriber> | <trainDescription> |
      | <toBerth>   | <timestamp2> | <secondToBerth> | <trainDescriber> | <trainDescription> |
    And I do nothing
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<plannedTime>" & actual time "<timestamp2>"

    Examples:
      | cif                                     | trainUid | trainDescription | location              | timestamp | plannedTime | timestamp2 | trainDescriber | toBerth | fromBerth | secondToBerth |
      #Passing
      | access-plan/42006-schedules/42006-8.cif | C14261   | 1U31             | Crewe Basford Hall Jn | 13:32:00  | 13:35:30    | 13:32:30   | CE             | H056    | A120      | H114          |
      #Stopping
      | access-plan/42006-schedules/42006-8.cif | C14261   | 1U31             | Stafford              | 13:51:00  | 13:55:30    | 13:56:30   | R3             | 9355    | 3598      | 3580          |

  Scenario Outline: 42006-8b Display calculated actual punctuality following a departure
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I do nothing
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<plannedTime>" & actual time "<timestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location | timestamp | plannedTime | trainDescriber | toBerth | fromBerth |
      #Origin
      | access-plan/42006-schedules/42006-8.cif | C14261   | 1U31             | Crewe    | 13:33:00  | 13:33:00    | CE             | H056    | A120      |

  Scenario: 42006-9 Display calculated punctuality following an arrival for a location that appears more than once (Stopping)
    Given I am on the trains list page
    And the access plan located in CIF file 'access-plan/42006-schedules/42006-9.cif' is received from LINX
    And train description '1U50' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for 'C14250'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3594      | 13:51:00  | 5582    | R3             | 1U50             |
      | 5582      | 13:51:30  | 4310    | R3             | 1U50             |
      | 3585      | 14:50:00  | 5582    | R3             | 1U50             |
    And I do nothing
    And I am on the timetable view for service 'C14250'
    And I toggle the inserted locations on
    Then the Arrival punctuality for location "Stafford" instance 2 is correctly calculated based on expected time "14:51:00" & actual time "14:50:00"

  Scenario: 42006-9b Display calculated punctuality following an arrival for a location that appears more than once (Destination)
    Given I am on the trains list page
    And the access plan located in CIF file 'access-plan/42006-schedules/42006-9b.cif' is received from LINX
    And train description '1U51' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for 'C14251'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3594      | 13:51:00  | 5582    | R3             | 1U51             |
      | 5582      | 13:51:30  | 4310    | R3             | 1U51             |
      | 1296      | 14:50:00  | 5582    | R3             | 1U51             |
    And I do nothing
    And I am on the timetable view for service 'C14251'
    And I toggle the inserted locations on
    Then the Arrival punctuality for location "Stafford" instance 2 is correctly calculated based on expected time "14:55:00" & actual time "14:50:00"

  Scenario: 42006-10 Display calculated punctuality following a departure for a location that appears more than once (origin)
    Given I am on the trains list page
    And the access plan located in CIF file 'access-plan/42006-schedules/42006-10.cif' is received from LINX
    And train description '1U52' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for 'C14252'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | A120      | 13:34:00  | 0104    | CE             | 1U52             |
      | 0107      | 15:02:30  | A136    | CE             | 1U52             |
      | A136      | 15:03:00  | 0159    | CE             | 1U52             |
    And I do nothing
    And I am on the timetable view for service 'C14252'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "Crewe" instance 2 is correctly calculated based on expected time "15:03:30" & actual time "15:03:00"

  Scenario: 42006-10b Display calculated punctuality following a departure for a location that appears more than once (passing)
    Given I am on the trains list page
    And the access plan located in CIF file 'access-plan/42006-schedules/42006-10b.cif' is received from LINX
    And train description '1U53' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for 'C14253'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3644      | 13:39:30  | 3642    | R3             | 1U53             |
      | 3642      | 13:40:00  | 3638    | R3             | 1U53             |
      | 3637      | 14:59:00  | 3639    | R3             | 1U53             |
      | 3639      | 14:59:01  | 3643    | R3             | 1U53             |
    And I do nothing
    And I am on the timetable view for service 'C14253'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "Madeley (Staffs)" instance 2 is correctly calculated based on expected time "14:59:30" & actual time "14:59:01"

  Scenario: 42006-10c Display calculated punctuality following a departure for a location that appears more than once (stopping)
    Given I am on the trains list page
    And the access plan located in CIF file 'access-plan/42006-schedules/42006-10c.cif' is received from LINX
    And train description '1U54' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for 'C14254'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3594      | 13:51:00  | 5582    | R3             | 1U54             |
      | 5582      | 13:51:30  | 4310    | R3             | 1U54             |
      | 3585      | 14:50:00  | 5582    | R3             | 1U54             |
    And I do nothing
    And I am on the timetable view for service 'C14254'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "Stafford" instance 2 is correctly calculated based on expected time "14:51:00" & actual time "14:50:00"
#
#  42006-11 Calculated punctuality for a location is not displayed when a TRI has already been received
#    Given a valid schedule exists
#    And a berth timing has been received to step into a location in that schedule with the <location type>
#    And a TRI timing has been received for the same location with the <TRI type>
#    When a user views the timetable
#    Then the external actual punctuality is displayed for the departure time for that location
#
#      | Location type |
#      | Stopping|
#      | Destination |
#
#      | TRI type |
#      | 01 -Arrival at Termination |
#      | 03 -Arrival at Station|
#
#
#  Notes for a stopping location actual arrival punctuality will only be displayed until a departure time is received
#
#  42006-12 Calculated punctuality for a location is not displayed when a TRI has already been received
#    Given a valid schedule exists
#    And a berth timing has been received to step out of a location in that schedule with the <location type>
#    And a TRI timing has been received for the same location with the <TRI type>
#    When a user views the timetable
#    Then the external actual punctuality is displayed for the departure time for that location
#
#      | Location type |
#      | Origin|
#      | Passing |
#      | Stopping |
#
#      | TRI type |
#      | 02 -Departure from Origin |
#      | 04 -Departure from Station|
#      | 05- Passing Location|
