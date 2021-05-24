@bug @bug:62243
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
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location      | timestamp | trainDescriber | toBerth |
      #stopping #STAFFRD
      | access-plan/42006-schedules/42006-1.cif  | C11101   | 1U01             | Stafford      | 13:50:00  | R3             | 5582    |
      #destination #EUSTON
      | access-plan/42006-schedules/42006-1b.cif | C11102   | 1U02             | London Euston | 15:50:00  | WY             | B012    |

  Scenario Outline: 42006-2 Display calculated departure time
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | timestamp   | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location            | timestamp | trainDescriber | fromBerth | toBerth |
      #Origin #Crewe
      | access-plan/42006-schedules/42006-2.cif  | C11103   | 1U03             | Crewe               | 13:33:00  | CE             | A120      | 0104    |
      #Stopping #STAFFRD
      | access-plan/42006-schedules/42006-2b.cif | C11104   | 1U04             | Stafford            | 13:56:00  | R3             | 5582      | 3580    |
      #Passing #HROW
      | access-plan/42006-schedules/42006-2c.cif | C11105   | 1U05             | Harrow & Wealdstone | 15:38:00  | WJ             | 0142      | 0138    |

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
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Arrival time for location "Stafford" instance 1 is correctly calculated based on Internal timing "13:51:00"
    Then the actual/predicted Arrival time for location "Stafford" instance 2 is correctly calculated based on Internal timing "14:50:00"

    Examples:
      | cif                                     | trainUid | trainDescription |
      | access-plan/42006-schedules/42006-3.cif | C11106   | 1U06             |

  Scenario Outline: 42006-3b Display calculated arrival time for a location that appears more than once - same location
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | 3594      | 13:51:00  | 5582    | R3             | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Arrival time for location "Stafford" instance 1 is correctly calculated based on Internal timing "13:51:00"
    And the actual/predicted Departure time for location "Stafford" instance 1 is predicted
    And the actual/predicted Arrival time for location "Stafford" instance 2 is predicted

    Examples:
      | cif                                      | trainUid | trainDescription |
      | access-plan/42006-schedules/42006-3b.cif | C11107   | 1U07             |


  Scenario Outline: 42006-4 Display calculated departure time for a location that appears more than once
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When I step through the Berth Level Schedule for '<trainUid>'
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    And the actual/predicted Departure time for location "<location>" instance 2 is correctly calculated based on Internal timing "<timestamp2>"

    Examples:
      | cif                                      | trainUid | trainDescription | location      | timestamp | timestamp2 |
      #Origin
      | access-plan/42006-schedules/42006-4.cif  | C11108   | 1U08             | Crewe         | 13:34:00  | 15:03:00   |
      #Stopping
      | access-plan/42006-schedules/42006-4b.cif | C11109   | 1U09             | Stafford      | 13:55:30  | 14:55:30   |
      #Passing
      | access-plan/42006-schedules/42006-4c.cif | C11110   | 1U10             | Norton Bridge | 13:46:51  | 14:55:30   |

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
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on External timing "<triTimestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location      | timestamp | trainDescriber | toBerth | triTimestamp | tiploc  | messageType            |
      #Stopping
      | access-plan/42006-schedules/42006-5.cif  | C11111   | 1U11             | Stafford      | 13:50:00  | R3             | 5582    | 13:52:00     | STAFFRD | Arrival at Station     |
      #Destination
      | access-plan/42006-schedules/42006-5b.cif | C11112   | 1U12             | London Euston | 15:52:00  | WY             | B012    | 15:53:00     | EUSTON  | Arrival at Termination |

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
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on External timing "<triTimestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp | trainDescriber | fromBerth | toBerth | triTimestamp | tiploc  | messageType            |
      | access-plan/42006-schedules/42006-6.cif  | C11113   | 1U13             | Crewe    | 13:33:00  | CE             | A120      | 0104    | 13:34:00     | CREWE   | Departure from Origin  |
      | access-plan/42006-schedules/42006-6b.cif | C11114   | 1U14             | Stafford | 13:50:00  | R3             | 5582      | 3580    | 13:52:00     | STAFFRD | Departure from Station |
      | access-plan/42006-schedules/42006-6c.cif | C11115   | 1U15             | Colwich  | 14:03:00  | SK             | 0008      | 0005    | 14:04:00     | COLWICH | Passing Location       |

  Scenario Outline: 42006-7 Display calculated actual punctuality following an arrival
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the Arrival punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<expectedArrivalTime>" & actual time "<timestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | expectedArrivalTime | trainDescriber | toBerth | fromBerth |
      #Destination
      | access-plan/42006-schedules/42006-7.cif | C11116   | 1U16             | London Euston | 15:50:00  | 15:52:00            | WY             | B012    | 0284      |

  Scenario Outline: 42006-8a Display calculated actual punctuality following an departure
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp    | toBerth         | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp>  | <toBerth>       | <trainDescriber> | <trainDescription> |
      | <toBerth>   | <timestamp2> | <secondToBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<plannedTime>" & actual time "<timestamp2>"

    Examples:
      | cif                                      | trainUid | trainDescription | location              | timestamp | plannedTime | timestamp2 | trainDescriber | toBerth | fromBerth | secondToBerth |
      #Passing
      | access-plan/42006-schedules/42006-8.cif  | C11117   | 1U17             | Crewe Basford Hall Jn | 13:32:00  | 13:35:30    | 13:32:30   | CE             | H056    | A120      | H114          |
      #Stopping
      | access-plan/42006-schedules/42006-8b.cif | C11118   | 1U18             | Stafford              | 13:51:00  | 13:55:30    | 13:56:30   | R3             | 9355    | 3598      | 3580          |

  Scenario Outline: 42006-8b Display calculated actual punctuality following a departure
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<plannedTime>" & actual time "<timestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp | plannedTime | trainDescriber | toBerth | fromBerth |
      #Origin
      | access-plan/42006-schedules/42006-8c.cif | C11119   | 1U19             | Crewe    | 13:33:00  | 13:33:00    | CE             | H056    | A120      |

  Scenario: 42006-9 Display calculated punctuality following an arrival for a location that appears more than once (Stopping)
    Given I am on the trains list page
    And the access plan located in CIF file 'access-plan/42006-schedules/42006-9.cif' is received from LINX
    And train description '1U20' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for 'C11120'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3594      | 13:51:00  | 5582    | R3             | 1U20             |
      | 5582      | 13:51:30  | 4310    | R3             | 1U20             |
      | 3585      | 14:50:00  | 5582    | R3             | 1U20             |
    And I am on the timetable view for service 'C11120'
    And I toggle the inserted locations on
    Then the Arrival punctuality for location "Stafford" instance 2 is correctly calculated based on expected time "14:51:00" & actual time "14:50:00"

  Scenario: 42006-9b Display calculated punctuality following an arrival for a location that appears more than once (Destination)
    Given I am on the trains list page
    And the access plan located in CIF file 'access-plan/42006-schedules/42006-9b.cif' is received from LINX
    And train description '1U21' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for 'C11121'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3594      | 13:51:00  | 5582    | R3             | 1U21             |
      | 5582      | 13:51:30  | 4310    | R3             | 1U21             |
      | 1296      | 14:50:00  | 5582    | R3             | 1U21             |
    And I am on the timetable view for service 'C11121'
    And I toggle the inserted locations on
    Then the Arrival punctuality for location "Stafford" instance 2 is correctly calculated based on expected time "14:55:00" & actual time "14:50:00"

  Scenario: 42006-10 Display calculated punctuality following a departure for a location that appears more than once (origin)
    Given I am on the trains list page
    And the access plan located in CIF file 'access-plan/42006-schedules/42006-10.cif' is received from LINX
    And train description '1U22' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for 'C11122'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | A120      | 13:34:00  | 0104    | CE             | 1U22             |
      | 0107      | 15:02:30  | A136    | CE             | 1U22             |
      | A136      | 15:03:00  | 0159    | CE             | 1U22             |
    And I am on the timetable view for service 'C11122'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "Crewe" instance 2 is correctly calculated based on expected time "15:03:30" & actual time "15:03:00"

  Scenario: 42006-10b Display calculated punctuality following a departure for a location that appears more than once (passing)
    Given I am on the trains list page
    And the access plan located in CIF file 'access-plan/42006-schedules/42006-10b.cif' is received from LINX
    And train description '1U23' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for 'C11123'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3644      | 13:39:30  | 3642    | R3             | 1U23             |
      | 3642      | 13:40:00  | 3638    | R3             | 1U23             |
      | 3637      | 14:59:00  | 3639    | R3             | 1U23             |
      | 3639      | 14:59:01  | 3643    | R3             | 1U23             |
    And I am on the timetable view for service 'C11123'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "Madeley (Staffs)" instance 2 is correctly calculated based on expected time "14:59:30" & actual time "14:59:01"

  Scenario: 42006-10c Display calculated punctuality following a departure for a location that appears more than once (stopping)
    Given I am on the trains list page
    And the access plan located in CIF file 'access-plan/42006-schedules/42006-10c.cif' is received from LINX
    And train description '1U24' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for 'C11124'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3594      | 13:51:00  | 5582    | R3             | 1U24             |
      | 5582      | 13:51:30  | 4310    | R3             | 1U24             |
      | 3585      | 14:50:00  | 5582    | R3             | 1U24             |
    And I am on the timetable view for service 'C11124'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "Stafford" instance 2 is correctly calculated based on expected time "14:51:00" & actual time "14:50:00"

  Scenario Outline: 42006-11 Calculated punctuality for a location is not displayed when a TRI has already been received
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | timestamp   | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And the following train running info message with time and delay is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      | bookedTime   | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> | <bookedTime> | 13                   |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the Arrival punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<bookedTime>" & actual time "<triTimestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location      | bookedTime | timestamp | trainDescriber | toBerth | triTimestamp | tiploc | messageType            |
      | access-plan/42006-schedules/42006-11.cif | C11125   | 1U25             | London Euston | 15:52:00   | 15:52:00  | WY             | B012    | 15:53:00     | EUSTON | Arrival at Termination |

  Scenario Outline: 42006-6 Calculated departure time for a location is not displayed when a TRI has already been received
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following berth step messages is sent from LINX
      | timestamp   | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And the following train running info message with time and delay is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      | bookedTime   | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> | <bookedTime> | 13                   |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<bookedTime>" & actual time "<triTimestamp>"

    Examples:
      | cif                                       | trainUid | trainDescription | location | bookedTime | timestamp | trainDescriber | fromBerth | toBerth | triTimestamp | tiploc  | messageType            |
      | access-plan/42006-schedules/42006-12.cif  | C11126   | 1U26             | Crewe    | 13:33:00   | 13:33:00  | CE             | A120      | 0104    | 13:34:00     | CREWE   | Departure from Origin  |
      | access-plan/42006-schedules/42006-12b.cif | C11127   | 1U27             | Stafford | 13:55:30   | 13:50:00  | R3             | 5582      | 3580    | 13:52:00     | STAFFRD | Departure from Station |
      | access-plan/42006-schedules/42006-12c.cif | C11128   | 1U28             | Colwich  | 14:01:00   | 14:00:00  | SK             | 0008      | 0005    | 14:02:00     | COLWICH | Passing Location       |
