Feature: 40656 - Schedule Manipulation - Path To Line

  As a TMV user
  I want schedules which have been imported to be manipulated
  So that the schedule has a the correct path, line and asset codes for each location

  @tdd
  Scenario: 40656-3 Schedule with propagated line code
    #J0053	OXFDNNJ
    Given there is a Schedule for '1F03'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | OXFDNNJ |                  | 10:05              | PAT  | LIN  |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | PRTOBJP | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F03'
    Then the locations line code matches the path code
      | location        | pathCode |
      | Oxford North Jn | PAT      |

  @tdd
  Scenario: 40656-4 Schedule with location with existing line code
    #J0053	OXFDNNJ
    Given there is a Schedule for '1F04'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | OXFDNNJ |                  | 10:05              | PAT  | LIN  |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | PRTOBJP | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F04'
    Then the locations line code matches the original line code
      | location        | lineCode |
      | Oxford North Jn | LIN      |

  @tdd
  Scenario: 40656-5 Schedule with location without matching path to line code rules
    Given there is a Schedule for '1F05'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc | scheduledArrival | scheduledDeparture | path | line |
      | OXFD   |                  | 10:01              | PAT  |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | PRTOBJP | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F05'
    Then no line code is displayed for location 'Oxford'
