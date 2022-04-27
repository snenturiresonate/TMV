@fixed-time
Feature: 51586 - Path Extrapolation - Current Punctuality

  As a TMV user
  I want predicted timings and punctuality to be calculated
  So that I can see how the train is expected to progress compared to its timetable

  Background:
    And I reset redis
    * I generate a new train description
    * I generate a new trainUID

  Scenario Outline: 51586 - 20 Current punctuality at origin (late)
    * I remove today's train '<trainUid>' from the trainlist
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | 01                  | 01:00                  | 99999               | CREWE                  | today         |
    When I am on the timetable view for service '<trainUid>'
    Then the punctuality is correct based on '01:00'

    Examples:
      | cif                                      | trainUid | trainDescription |
      | access-plan/51586-schedules/51586-20.cif | A50020   | 5A20             |

  Scenario Outline: 51586 - 20 Current punctuality at origin (on time/early)
    * I remove today's train '<trainUid>' from the trainlist
    Given the access plan located in CIF file '<cif>' is received from LINX with the new uid
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | 23                  | 23:28                  | 99999               | CREWE                  | today         |
    When I am on the timetable view for service '<trainUid>'
    Then the punctuality is displayed as 'On time'

    Examples:
      | cif                                       | trainUid  | trainDescription |
      | access-plan/51586-schedules/51586-20b.cif | generated | generated        |

  @manual @manual:93467
  Scenario Outline: 51586 - 21 Current punctuality for a train that is not moving
    Given I am on the trains list page 1
    And the access plan located in CIF file '<cif>' is received from LINX
    And I restore to default train list config '1'
    And I refresh the browser
    And I save the trains list config
    And the following service is displayed on the trains list '1'
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | 01                  | 01:00                  | 99999               | CREWE                  | today         |
    When I am on the timetable view for service '<trainUid>'
    Then the punctuality increases when the train is not moving

    Examples:
      | cif                                      | trainUid | trainDescription |
      | access-plan/51586-schedules/51586-20.cif | A50020   | 5A20             |

  @tdd @tdd:64086 # Flaky updating of punctuality in timetable
  Scenario Outline: 51586 - 22 Current punctuality at a stopping location
    Given I am on the trains list page 1
    And the access plan located in CIF file '<cif>' is received from LINX
    And I restore to default train list config '1'
    And I refresh the browser
    And I save the trains list config
    And the following service is displayed on the trains list '1'
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | 22                  | 22:30                  | 99999               | BHAMNWS                | today         |
    And the following berth step messages is sent from LINX
      | timestamp   | fromBerth | toBerth | trainDescriber | trainDescription   |
      | <timestamp> | 5583      | 9350    | R3             | <trainDescription> |
    When I am on the timetable view for service '<trainUid>'
    Then the punctuality is displayed as '<expectedPunctuality>'
    And the Departure punctuality for location "Stafford" instance 1 is "<expectedDeparturePunctuality>"
    Examples:
      | cif                                      | trainUid | trainDescription | timestamp | expectedPunctuality | expectedDeparturePunctuality |
      | access-plan/51586-schedules/51586-22.cif | A50022   | 5A22             | 23:00:00  | -1m                 | (+0m)                        |
      | access-plan/51586-schedules/51586-22.cif | A50022   | 5A22             | 23:01:00  | On time             | (+0m)                        |
      | access-plan/51586-schedules/51586-22.cif | A50022   | 5A22             | 23:02:00  | +1m                 | (+0m)                        |
      | access-plan/51586-schedules/51586-22.cif | A50022   | 5A22             | 23:04:30  | +3m 30s             | (+1m)                        |
      | access-plan/51586-schedules/51586-22.cif | A50022   | 5A22             | 23:05:30  | +4m 30s             | (+2m)                        |
      | access-plan/51586-schedules/51586-22.cif | A50022   | 5A22             | 23:06:30  | +5m 30s             | (+3m)                        |

  @tdd @tdd:64086 # Flaky updating of punctuality in timetable
  Scenario Outline: 51586 - 23 Current punctuality after a TD update
    Given I am on the trains list page 1
    And the access plan located in CIF file '<cif>' is received from LINX
    And I restore to default train list config '1'
    And I refresh the browser
    And I save the trains list config
    And the following service is displayed on the trains list '1'
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | 22                  | 22:30                  | 99999               | BHAMNWS                | today         |
    And the following berth step messages is sent from LINX
      | timestamp   | fromBerth | toBerth | trainDescriber | trainDescription   |
      | <timestamp> | 5583      | 9350    | R3             | <trainDescription> |
    When I am on the timetable view for service '<trainUid>'
    Then the punctuality is displayed as '<expectedPunctuality>'
    And the navbar punctuality indicator is displayed as "<expectedColour>"

    Examples:
      | cif                                      | trainUid | trainDescription | timestamp | expectedPunctuality | expectedColour |
      | access-plan/51586-schedules/51586-23.cif | A50023   | 5A23             | 23:00:00  | -1m                 | palegreen      |
      | access-plan/51586-schedules/51586-23.cif | A50023   | 5A23             | 23:01:00  | On time             | green          |
      | access-plan/51586-schedules/51586-23.cif | A50023   | 5A23             | 23:02:00  | +1m                 | yellow         |

  @tdd @tdd:64086 # Flaky updating of punctuality in timetable
  Scenario Outline: 51586 - 24 Current punctuality after a later TRI update
    Given I am on the trains list page 1
    And the access plan located in CIF file '<cif>' is received from LINX
    And I restore to default train list config '1'
    And I refresh the browser
    And I save the trains list config
    And the following service is displayed on the trains list '1'
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | 22                  | 22:30                  | 99999               | BHAMNWS                | today         |
    And the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription   |
      | 22:30:00  | 0179      | 0471    | BN             | <trainDescription> |
    When the following train running info message with time and delay is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode   | messageType   | timestamp   | bookedTime   | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | <locationPrimaryCode> | <locationSubsidiaryCode> | <messageType> | <timestamp> | <bookedTime> | 22                   |
    And I am on the timetable view for service '<trainUid>'
    Then the punctuality is displayed as '<expectedPunctuality>'

    Examples:
      | cif                                      | trainUid | trainDescription | timestamp | expectedPunctuality | messageType            | locationPrimaryCode | locationSubsidiaryCode | bookedTime |
      | access-plan/51586-schedules/51586-24.cif | A50024   | 5A24             | 00:16:00  | +1m                 | Arrival at Termination | 99999               | MNCRPIC                | 00:15:00   |
      | access-plan/51586-schedules/51586-24.cif | A50024   | 5A24             | 22:32:00  | +2m                 | Departure from Origin  | 99999               | BHAMNWS                | 22:30:00   |
      | access-plan/51586-schedules/51586-24.cif | A50024   | 5A24             | 22:49:30  | +1m                 | Departure from Station | 99999               | WVRMPTN                | 22:48:30   |
      | access-plan/51586-schedules/51586-24.cif | A50024   | 5A24             | 22:53:00  | +2m                 | Passing Location       | 99999               | BSBYJN                 | 22:51:00   |

  Scenario Outline: 51586 - 25 Current punctuality after an earlier TRI update - <messageType>
    * I remove today's train '<trainUid>' from the trainlist
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | 22                  | 22:30                  | 99999               | BHAMNWS                | today         |
    # -1 minute
    And the following train running info message with time and delay is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp | bookedTime | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 99999               | MNCRPIC                | Arrival at Termination | 00:14:00  | 00:15:00   | 22                   |
    When the following train running info message with time and delay is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode   | messageType   | timestamp   | bookedTime   | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | <locationPrimaryCode> | <locationSubsidiaryCode> | <messageType> | <timestamp> | <bookedTime> | 22                   |
    And I am on the timetable view for service '<trainUid>'
    Then the punctuality is displayed as '-1m'

    Examples:
      | cif                                      | trainUid | trainDescription | timestamp | messageType            | locationPrimaryCode | locationSubsidiaryCode | bookedTime |
      | access-plan/51586-schedules/51586-24.cif | A50024   | 5A24             | 22:31:00  | Departure from Origin  | 99999               | BHAMNWS                | 22:30:00   |
      | access-plan/51586-schedules/51586-24.cif | A50024   | 5A24             | 22:49:30  | Departure from Station | 99999               | WVRMPTN                | 22:48:30   |
      | access-plan/51586-schedules/51586-24.cif | A50024   | 5A24             | 22:52:00  | Passing Location       | 99999               | BSBYJN                 | 22:51:00   |


