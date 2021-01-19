Feature: TMV Process LINX Train Modification (S013 & S015)

  As a TMV User
  I want the system process LINX train stepping messages
  So that I can view the train stepping on the schematic

  @tdd
  Scenario Outline: 40490-1 Single Change of ID received
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I am on the timetable view for service '<trainDescription>'
    And I switch to the timetable details tab
    When the following change of ID TJM is received
      | status | newTrainNumber           | oldTrainNumber     | locationPrimaryCode | locationSubsidiaryCode | time   |
      | create | <changeTrainDescription> | <trainDescription> | 99999               | PADTON                 | <time> |
    Then the headcode in the header row is '<changeTrainDescription> (<trainDescription>)'
    And the last TJM is
      | description   | location   | time   |
      | <description> | <location> | <time> |
    And there is a record in the modifications table
      | description   | location   | time   | type   |
      | <description> | <location> | <time> | <type> |

    Examples:
      | trainUid | trainDescription | changeTrainDescription | type | description        | location   | time     |
      | H41X01   | 1X01             | 1X99                   | 07   | Change of Identity | Paddington | 12:00:00 |

  @tdd
  Scenario Outline: 40490-2a Single Cancellation at Origin or Cancellation at location received
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I am on the timetable view for service '<trainDescription>'
    And I switch to the timetable details tab
    When the following TJM is received
      | status | trainNumber        | type   | locationPrimaryCode | locationSubsidiaryCode | time   |
      | create | <trainDescription> | <type> | 99999               | PADTON                 | <time> |
    Then the last TJM is
      | description   | location   | time   |
      | <description> | <location> | <time> |
    And there is a record in the modifications table
      | description   | location   | time   | type   |
      | <description> | <location> | <time> | <type> |

    Examples:
      | trainUid | trainDescription | type | description  | location   | time     |
      | H41X02   | 1X02             | 91   | Cancellation | Paddington | 12:00:00 |
      | H41X03   | 1X03             | 92   | Cancellation | Paddington | 12:00:00 |

  @tdd
  Scenario Outline: 40490-2b Single Change of Origin at location received
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I am on the timetable view for service '<trainDescription>'
    And I switch to the timetable details tab
    When the following TJM is received
      | status | trainNumber        | type   | locationPrimaryCode | locationSubsidiaryCode | time   |
      | create | <trainDescription> | <type> | 99999               | OLDOXRS                | <time> |
    Then the last TJM is
      | description   | location   | time   |
      | <description> | <location> | <time> |
    And there is a record in the modifications table
      | description   | location   | time   | type   |
      | <description> | <location> | <time> | <type> |

    Examples:
      | trainUid | trainDescription | type | description      | location      | time     |
      | H41X04   | 1X04             | 94   | Change of Origin | Old Oak Depot | 12:00:00 |

  @tdd
  Scenario Outline: 40490-3 Cancellation received followed by reinstatement at the same location
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I am on the timetable view for service '<trainDescription>'
    And I switch to the timetable details tab
    When the following TJMs are received
      | status | trainNumber        | type    | locationPrimaryCode | locationSubsidiaryCode | time    |
      | create | <trainDescription> | <type1> | 99999               | PADTON                 | <time1> |
      | create | <trainDescription> | <type2> | 99999               | PADTON                 | <time2> |
    Then there is a record in the modifications table
      | description    | location    | time    | type    |
      | <description1> | <location1> | <time1> | <type1> |
      | <description2> | <location2> | <time2> | <type2> |
    And the last TJM is
      | description    | location    | time    |
      | <description2> | <location2> | <time2> |

    Examples:
      | trainUid | trainDescription | type1 | description1 | location1  | time1    | type2 | description2  | location2  | time2    |
      | H41X05   | 1X05             | 91    | Cancellation | Paddington | 12:00:00 | 96    | Reinstatement | Paddington | 12:01:00 |
      | H41X06   | 1X06             | 92    | Cancellation | Paddington | 12:00:00 | 96    | Reinstatement | Paddington | 12:01:00 |
