@bug @bug:58317
Feature: 42006 - Path Extrapolation - Timings on the timetable

  As a TMV user
  I want the actual train movements to be incorporated into the schedule
  So that they can be displayed in the UI and used to predict future timings and punctuality

  Background:
    Given I remove all trains from the trains list

  Scenario Outline: 42006-1 Display calculated arrival time
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And Train description '<trainDescription>' is visible on the trains list
    When I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And the following berth interpose messages is sent from LINX
      | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
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
    And Train description '<trainDescription>' is visible on the trains list
    When I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And the following berth step messages is sent from LINX
      | timestamp   | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
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
    And Train description '<trainDescription>' is visible on the trains list
    When I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And the following berth interpose messages is sent from LINX
      | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth      | trainDescriber   | trainDescription   |
      | 13:55:00  | <toBerth> | <fromBerth2> | <trainDescriber> | <trainDescription> |
    And the following berth step messages is sent from LINX
      | timestamp    | fromBerth    | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp2> | <fromBerth2> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I refresh the browser
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    Then the actual/predicted Arrival time for location "<location>" instance 2 is correctly calculated based on "<timestamp2>"

    Examples:
      | cif                                     | trainUid | trainDescription | location | timestamp | trainDescriber | toBerth | timestamp2 | fromBerth2 |
      | access-plan/42006-schedules/42006-3.cif | C14258   | 1U34             | Stafford | 13:50:00  | R3             | 5582    | 15:52:00   | 3580       |

  Scenario Outline: 42006-3b Display calculated arrival time for a location that appears more than once - same location
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And Train description '<trainDescription>' is visible on the trains list
    When I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And the following berth interpose messages is sent from LINX
      | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth     | trainDescriber   | trainDescription   |
      | 13:51:00  | <toBerth> | <nextBerth> | <trainDescriber> | <trainDescription> |
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    Then the actual/predicted Departure time for location "<location>" instance 1 is empty
    Then the actual/predicted Arrival time for location "<location>" instance 2 is empty

    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp | trainDescriber | toBerth | nextBerth |
      | access-plan/42006-schedules/42006-3b.cif | C14259   | 1U35             | Stafford | 13:50:00  | R3             | 5582    | 9355      |

  @bug @bug:58193 @test
  Scenario Outline: 42006-4 Display calculated departure time for a location that appears more than once
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    When I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    And I step through the Berth Level Schedule 'access-plan/42006-schedules/42006-berth-level-schedule.json'
    And I refresh the browser
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location>" instance 2 is correctly calculated based on "<timestamp2>"

    Examples:
      | cif                                     | trainUid | trainDescription | location         | timestamp | timestamp2 |
      #Origin
      | access-plan/42006-schedules/42006-4.cif | C14260   | 1U36             | Crewe            | 13:33:00  | 15:02:00   |
      #Stopping
      | access-plan/42006-schedules/42006-4.cif | C14260   | 1U36             | Stafford         | 13:51:00  | 14:51:00   |
      #Passing
      | access-plan/42006-schedules/42006-4.cif | C14260   | 1U36             | Rugeley North Jn | 14:03:00  | 14:43:00   |

  Scenario Outline: 42006-5 Calculated arrival time for a location is not displayed when a TRI has already been received
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And Train description '<trainDescription>' is visible on the trains list
    When the following berth interpose messages is sent from LINX
      | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> | 13                   |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on "<triTimestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | trainDescriber | toBerth | triTimestamp | tiploc  | messageType            |
      #Stopping
      | access-plan/42006-schedules/42006-5.cif | C14261   | 1U37             | Stafford      | 13:50:00  | R3             | 5582    | 13:52:00     | STAFFRD | Arrival at Station     |
      #Destination
      | access-plan/42006-schedules/42006-5.cif | C14261   | 1U37             | London Euston | 15:52:00  | WY             | B012    | 15:53:00     | EUSTON  | Arrival at Termination |

  Scenario Outline: 42006-6 Calculated departure time for a location is not displayed when a TRI has already been received
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And Train description '<trainDescription>' is visible on the trains list
    When the following berth interpose messages is sent from LINX
      | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> | 13                   |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<triTimestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | trainDescriber | toBerth | triTimestamp | tiploc  | messageType            |
      #Stopping
      | access-plan/42006-schedules/42006-6.cif | C14261   | 1U38             | Stafford      | 13:50:00  | R3             | 5582    | 13:52:00     | STAFFRD | Arrival at Station     |
      # Destination
      | access-plan/42006-schedules/42006-6.cif | C14261   | 1U38             | London Euston | 15:52:00  | WY             | B012    | 15:53:00     | EUSTON  | Arrival at Termination |

  Scenario Outline: 42006-7 Display calculated actual punctuality following an arrival
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the punctuality for location "<location>" instance 1 is correctly calculated based on "<timestamp>" & "<expectedArrivalTime>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | expectedArrivalTime | trainDescriber | toBerth | fromBerth |
      #Destination
      | access-plan/42006-schedules/42006-7.cif | C14261   | 1U39             | London Euston | 15:50:00  | 15:52:00            | WY             | B012    | 0284      |

  Scenario Outline: 42006-8a Display calculated actual punctuality following an departure
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp    | toBerth         | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp>  | <toBerth>       | <trainDescriber> | <trainDescription> |
      | <toBerth>   | <timestamp2> | <secondToBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the punctuality for location "<location>" instance 1 is correctly calculated based on "<timestamp2>" & "<plannedTime>"

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
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the punctuality for location "<location>" instance 1 is correctly calculated based on "<timestamp>" & "<plannedTime>"

    Examples:
      | cif                                     | trainUid | trainDescription | location | timestamp | plannedTime | trainDescriber | toBerth | fromBerth |
      #Origin
      | access-plan/42006-schedules/42006-8.cif | C14261   | 1U31             | Crewe    | 13:33:00  | 13:33:00    | CE             | H056    | A120      |

  Scenario Outline: 42006-5 Calculated arrival time for a location is not displayed when a TRI has already been received
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And Train description '<trainDescription>' is visible on the trains list
    When the following berth interpose messages is sent from LINX
      | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> | 13                   |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on "<triTimestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | trainDescriber | toBerth | triTimestamp | tiploc  | messageType            |
      #Stopping
      | access-plan/42006-schedules/42006-5.cif | C14261   | 1U37             | Stafford      | 13:50:00  | R3             | 5582    | 13:52:00     | STAFFRD | Arrival at Station     |
      #Destination
      | access-plan/42006-schedules/42006-5.cif | C14261   | 1U37             | London Euston | 15:52:00  | WY             | B012    | 15:53:00     | EUSTON  | Arrival at Termination |

  Scenario Outline: 42006-6 Calculated departure time for a location is not displayed when a TRI has already been received
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And Train description '<trainDescription>' is visible on the trains list
    When the following berth interpose messages is sent from LINX
      | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType   | timestamp      | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 15220               | <tiploc>               | <messageType> | <triTimestamp> | 13                   |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<triTimestamp>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | trainDescriber | toBerth | triTimestamp | tiploc  | messageType            |
      #Stopping
      | access-plan/42006-schedules/42006-6.cif | C14261   | 1U38             | Stafford      | 13:50:00  | R3             | 5582    | 13:52:00     | STAFFRD | Arrival at Station     |
      # Destination
      | access-plan/42006-schedules/42006-6.cif | C14261   | 1U38             | London Euston | 15:52:00  | WY             | B012    | 15:53:00     | EUSTON  | Arrival at Termination |

  Scenario Outline: 42006-7 Display calculated actual punctuality following an arrival
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the punctuality for location "<location>" instance 1 is correctly calculated based on "<timestamp>" & "<expectedArrivalTime>"

    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | expectedArrivalTime | trainDescriber | toBerth | fromBerth |
      #Destination
      | access-plan/42006-schedules/42006-7.cif | C14261   | 1U39             | London Euston | 15:50:00  | 15:52:00            | WY             | B012    | 0284      |

  Scenario Outline: 42006-8a Display calculated actual punctuality following an departure
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp    | toBerth         | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp>  | <toBerth>       | <trainDescriber> | <trainDescription> |
      | <toBerth>   | <timestamp2> | <secondToBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the punctuality for location "<location>" instance 1 is correctly calculated based on "<timestamp2>" & "<plannedTime>"

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
    When the following berth step messages is sent from LINX
      | fromBerth   | timestamp   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <timestamp> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    And I toggle the inserted locations on
    Then the punctuality for location "<location>" instance 1 is correctly calculated based on "<timestamp>" & "<plannedTime>"

    Examples:
      | cif                                     | trainUid | trainDescription | location | timestamp | plannedTime | trainDescriber | toBerth | fromBerth |
      #Origin
      | access-plan/42006-schedules/42006-8.cif | C14261   | 1U31             | Crewe    | 13:33:00  | 13:33:00    | CE             | H056    | A120      |
