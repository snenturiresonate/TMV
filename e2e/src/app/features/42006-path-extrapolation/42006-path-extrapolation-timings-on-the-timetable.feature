Feature: 42006 - Path Extrapolation - Timings on the timetable

  As a TMV user
  I want the actual train movements to be incorporated into the schedule
  So that they can be displayed in the UI and used to predict future timings and punctuality


  Background:
    * I reset redis
    * I am on the home page

  Scenario Outline: 42006-1 Display calculated arrival time - <stepType>
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType           | newTrainDescription | newPlanningUid |
      | <cif>     | <tiploc>    | <cifLocationTimingType> | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And I give the inserted locations 2 second to fully load
    When I log the berth & locations from the berth level schedule for '<trainUid>'
    And the following live berth interpose messages is sent from LINX
      | toBerth   | trainDescriber   | trainDescription   |
      | <toBerth> | <trainDescriber> | <trainDescription> |
    And I give the timetable display 1 second to update
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location      | timestamp | trainDescriber | toBerth | tiploc  | cifLocationTimingType | stepType            |
      | access-plan/42006-schedules/42006-1.cif  | C11101   | 1U01             | Stafford      | now       | R3             | 5582    | STAFFRD | WTT_dep               | Stops at Stafford   |
      | access-plan/42006-schedules/42006-1b.cif | C11102   | 1U02             | London Euston | now       | WY             | B012    | EUSTON  | WTT_arr               | Destined for Euston |

  Scenario Outline: 42006-2 Display calculated departure time - <stepType>
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | <tiploc>    | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And I give the inserted locations 2 second to fully load
    When I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following live berth step message is sent from LINX
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I give the timetable display 1 second to update
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location            | timestamp | trainDescriber | fromBerth | toBerth | tiploc  | stepType            |
      | access-plan/42006-schedules/42006-2.cif  | C11103   | 1U03             | Crewe               | now       | CE             | A120      | 0104    | CREWE   | Originates at Crewe |
      | access-plan/42006-schedules/42006-2b.cif | C11104   | 1U04             | Stafford            | now       | R3             | 5582      | 3580    | STAFFRD | Stops at Stafford   |
      | access-plan/42006-schedules/42006-2c.cif | C11105   | 1U05             | Harrow & Wealdstone | now       | WJ             | 0142      | 0138    | HROW    | Passes Heathrow     |

  @manual @fixed-time
  Scenario Outline: 42006-3 Display calculated arrival time for a location that appears more than once
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I wait until today's train '<trainUid>' has loaded
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

  @manual @fixed-time
  Scenario Outline: 42006-3b Display calculated arrival time for a location that appears more than once - same location
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I wait until today's train '<trainUid>' has loaded
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

  @manual @fixed-time
  Scenario Outline: 42006-4 Display calculated departure time for a location that appears more than once
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When I step through the Berth Level Schedule for '<trainUid>'
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    And the actual/predicted Departure time for location "<location>" instance 2 is correctly calculated based on Internal timing "<timestamp2>"

    Examples:
      | cif                                      | trainUid | location      | timestamp | timestamp2 |
      #Origin
      | access-plan/42006-schedules/42006-4.cif  | C11108   | Crewe         | 13:34:00  | 15:03:00   |
      #Stopping
      | access-plan/42006-schedules/42006-4b.cif | C11109   | Stafford      | 13:55:30  | 14:55:30   |
      #Passing
      | access-plan/42006-schedules/42006-4c.cif | C11110   | Norton Bridge | 13:46:51  | 14:55:30   |

  Scenario Outline: 42006-5 Calculated arrival time for a location is not displayed when a TRI has already been received - <messageType>
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType           | newTrainDescription | newPlanningUid |
      | <cif>     | <tiploc>    | <cifLocationTimingType> | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And I give the inserted locations 2 second to fully load
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> |
    And I give the TRI 2 seconds to be processed
    When the following live berth interpose messages is sent from LINX
      | toBerth   | trainDescriber   | trainDescription   |
      | <toBerth> | <trainDescriber> | <trainDescription> |
    And I give the timetable display 1 second to update
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on External timing "<triTimestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location      | trainDescriber | toBerth | triTimestamp | tiploc  | messageType            | cifLocationTimingType |
      | access-plan/42006-schedules/42006-5.cif  | C11111   | 1U11             | Stafford      | R3             | 5582    | now - 2      | STAFFRD | Arrival at Station     | WTT_dep               |
      | access-plan/42006-schedules/42006-5b.cif | C11112   | 1U12             | London Euston | WY             | B012    | now - 2      | EUSTON  | Arrival at Termination | WTT_arr               |

  Scenario Outline: 42006-6 Calculated departure time for a location is not displayed when a TRI has already been received - <messageType>
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | <tiploc>    | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And I give the inserted locations 2 second to fully load
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> |
    And I give the TRI 2 seconds to be processed
    When the following live berth step messages is sent from LINX
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I give the timetable display 1 second to update
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on External timing "<triTimestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location | trainDescriber | fromBerth | toBerth | triTimestamp | tiploc  | messageType            |
      | access-plan/42006-schedules/42006-6.cif  | C11113   | 1U13             | Crewe    | CE             | A120      | 0104    | now - 2      | CREWE   | Departure from Origin  |
      | access-plan/42006-schedules/42006-6b.cif | C11114   | 1U14             | Stafford | R3             | 5582      | 3580    | now - 2      | STAFFRD | Departure from Station |
      | access-plan/42006-schedules/42006-6c.cif | C11115   | 1U15             | Colwich  | SK             | 0008      | 0005    | now - 2      | COLWICH | Passing Location       |

  Scenario Outline: 42006-7 Display calculated actual punctuality following an arrival - <stepType>
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | <tiploc>    | WTT_arr       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And I give the inserted locations 2 second to fully load
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following live berth step messages is sent from LINX
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I give the timetable display 1 second to update
    Then the Arrival punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<expectedArrivalTime>" & actual time "<timestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | expectedArrivalTime | trainDescriber | toBerth | fromBerth | tiploc | stepType               |
      | access-plan/42006-schedules/42006-7.cif | C11116   | 1U16             | London Euston | now       | now + 2             | WY             | B012    | 0284      | EUSTON | Arrival at destination |

  Scenario Outline: 42006-8a Display calculated actual punctuality following a departure - <stepType>
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | <tiploc>    | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And I give the inserted locations 2 second to fully load
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following live berth step messages are sent from LINX
      | fromBerth   | toBerth         | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth>       | <trainDescriber> | <trainDescription> |
      | <toBerth>   | <secondToBerth> | <trainDescriber> | <trainDescription> |
    And I give the timetable display 1 second to update
    Then the Departure punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<plannedTime>" & actual time "<timestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location              | timestamp | plannedTime | trainDescriber | toBerth | fromBerth | secondToBerth | tiploc  | stepType |
      | access-plan/42006-schedules/42006-8.cif  | C11117   | 1U17             | Crewe Basford Hall Jn | now       | now + 2     | CE             | H056    | A120      | H114          | CREWE   | passing  |
      | access-plan/42006-schedules/42006-8b.cif | C11118   | 1U18             | Stafford              | now       | now + 2     | R3             | 9355    | 3598      | 3580          | STAFFRD | stopping |

  # possible flaky test - see PR against 81826
  Scenario Outline: 42006-8b Display calculated actual punctuality following a departure - <stepType>
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And I give the inserted locations 2 seconds to fully load
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following live berth step message is sent from LINX
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I give the timetable display 1 second to update
    Then the Departure punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<plannedTime>" & actual time "<timestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp | plannedTime | trainDescriber | toBerth | fromBerth | stepType              |
      | access-plan/42006-schedules/42006-8c.cif | C11119   | 1U19             | Crewe    | now       | now + 2     | CE             | H056    | A120      | departure from origin |

  @manual @fixed-time
  Scenario: 42006-9 Display calculated punctuality following an arrival for a location that appears more than once (Stopping)
    Given the access plan located in CIF file 'access-plan/42006-schedules/42006-9.cif' is received from LINX
    And I wait until today's train 'C11120' has loaded
    And I log the berth & locations from the berth level schedule for 'C11120'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3594      | 13:51:00  | 5582    | R3             | 1U20             |
      | 5582      | 13:51:30  | 4310    | R3             | 1U20             |
      | 3585      | 14:50:00  | 5582    | R3             | 1U20             |
    And I am on the timetable view for service 'C11120'
    And I toggle the inserted locations on
    Then the Arrival punctuality for location "Stafford" instance 2 is correctly calculated based on expected time "14:51:00" & actual time "14:50:00"

  @manual @fixed-time
  Scenario: 42006-9b Display calculated punctuality following an arrival for a location that appears more than once (Destination)
    Given the access plan located in CIF file 'access-plan/42006-schedules/42006-9b.cif' is received from LINX
    And I wait until today's train 'C11121' has loaded
    And I log the berth & locations from the berth level schedule for 'C11121'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3594      | 13:51:00  | 5582    | R3             | 1U21             |
      | 5582      | 13:51:30  | 4310    | R3             | 1U21             |
      | 1296      | 14:50:00  | 5582    | R3             | 1U21             |
    And I am on the timetable view for service 'C11121'
    And I toggle the inserted locations on
    Then the Arrival punctuality for location "Stafford" instance 2 is correctly calculated based on expected time "14:55:00" & actual time "14:50:00"

  @manual @fixed-time
  Scenario: 42006-10 Display calculated punctuality following a departure for a location that appears more than once (origin)
    Given the access plan located in CIF file 'access-plan/42006-schedules/42006-10.cif' is received from LINX
    And I wait until today's train 'C11122' has loaded
    And I log the berth & locations from the berth level schedule for 'C11122'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | A120      | 13:34:00  | 0104    | CE             | 1U22             |
      | 0107      | 15:02:30  | A136    | CE             | 1U22             |
      | A136      | 15:03:00  | 0159    | CE             | 1U22             |
    And I am on the timetable view for service 'C11122'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "Crewe" instance 2 is correctly calculated based on expected time "15:03:30" & actual time "15:03:00"

  @manual @fixed-time
  Scenario: 42006-10b Display calculated punctuality following a departure for a location that appears more than once (passing)
    Given the access plan located in CIF file 'access-plan/42006-schedules/42006-10b.cif' is received from LINX
    And I wait until today's train 'C11123' has loaded
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

  @manual @fixed-time
  Scenario: 42006-10c Display calculated punctuality following a departure for a location that appears more than once (stopping)
    Given the access plan located in CIF file 'access-plan/42006-schedules/42006-10c.cif' is received from LINX
    And I wait until today's train 'C11124' has loaded
    And I log the berth & locations from the berth level schedule for 'C11124'
    When the following berth step messages is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription |
      | 3594      | 13:51:00  | 5582    | R3             | 1U24             |
      | 5582      | 13:51:30  | 4310    | R3             | 1U24             |
      | 3585      | 14:50:00  | 5582    | R3             | 1U24             |
    And I am on the timetable view for service 'C11124'
    And I toggle the inserted locations on
    Then the Departure punctuality for location "Stafford" instance 2 is correctly calculated based on expected time "14:51:00" & actual time "14:50:00"

  Scenario Outline: 42006-11 Calculated punctuality for an arrival location is not displayed when a TRI has already been received - <messageType>
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | <tiploc>    | WTT_arr       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And I give the inserted locations 2 second to fully load
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And the following train running info message with time and delay is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      | bookedTime   |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> | <bookedTime> |
    And I give the TRI 2 seconds to be processed
    When the following live berth step messages is sent from LINX
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I give the timetable display 1 second to update
    Then the Arrival punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<bookedTime>" & actual time "<triTimestamp>"

    Examples:
      | cif                                      | trainUid | trainDescription | location      | bookedTime | trainDescriber | fromBerth | toBerth | triTimestamp | tiploc | messageType            |
      | access-plan/42006-schedules/42006-11.cif | C11125   | 1U25             | London Euston | now        | WY             | 0284      | B012    | now - 2      | EUSTON | Arrival at Termination |

  Scenario Outline: 42006-12 Calculated punctuality for departure and passing locations is not displayed when a TRI has already been received - <messageType>
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | <tiploc>    | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And I give the inserted locations 2 second to fully load
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And the following train running info message with time and delay is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      | bookedTime   |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> | <bookedTime> |
    And I give the TRI 2 seconds to be processed
    When the following live berth step messages is sent from LINX
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I give the timetable display 1 second to update
    Then the Departure punctuality for location "<location>" instance 1 is correctly calculated based on expected time "<bookedTime>" & actual time "<triTimestamp>"

    Examples:
      | cif                                       | trainUid | trainDescription | location | bookedTime | trainDescriber | fromBerth | toBerth | triTimestamp | tiploc  | messageType            |
      | access-plan/42006-schedules/42006-12.cif  | C11126   | 1U26             | Crewe    | now        | CE             | A120      | 0104    | now - 2      | CREWE   | Departure from Origin  |
      | access-plan/42006-schedules/42006-12b.cif | C11127   | 1U27             | Stafford | now        | R3             | 5582      | 3580    | now - 2      | STAFFRD | Departure from Station |
      | access-plan/42006-schedules/42006-12c.cif | C11128   | 1U28             | Colwich  | now        | SK             | 0008      | 0005    | now - 2      | COLWICH | Passing Location       |
