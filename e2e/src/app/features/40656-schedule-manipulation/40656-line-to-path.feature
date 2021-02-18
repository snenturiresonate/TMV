Feature: 40656 - Schedule Manipulation - Line To Path

  As a TMV user
  I want schedules which have been imported to be manipulated
  So that the schedule has a the correct path, line and asset codes for each location

  @tdd
  Scenario: 40656-6 Schedule with locations matching line code to path code rules
    #K0056	OXFD   	OXFDNNJ
    Given there is a Schedule for '1F06'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | OXFD    |                  | 10:01              |      | LIN  |
      | OXFDNNJ |                  | 10:05              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | PRTOBJP | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F06'
    Then the path code for the To Location matches the line code for the From Location
      | fromLocation | lineCode | toLocation      |
      | Oxford       | LIN      | Oxford North Jn |

  @tdd
  Scenario: 40656-7 Schedule with locations with existing path code
    #K0056	OXFD   	OXFDNNJ
    Given there is a Schedule for '1F07'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | OXFD    |                  | 10:01              |      | LIN  |
      | OXFDNNJ |                  | 10:05              | PAT  |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | PRTOBJP | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F07'
    Then the locations path code matches the original path code
      | location        | pathCode |
      | Oxford North Jn | PAT      |

  @tdd
  Scenario: 40656-7b From Locations line is not back filled from To Locations Path with matching rule
    #K0056	OXFD   	OXFDNNJ
    Given there is a Schedule for '1F07'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | OXFD    |                  | 10:01              |      | LIN  |
      | OXFDNNJ |                  | 10:05              | PAT  |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | PRTOBJP | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F07'
    Then the locations line code matches the original line code
      | location | lineCode |
      | Oxford   | LIN      |

  @tdd
  Scenario: 40656-8 Schedule with locations without matching line code to path code rules
    Given there is a Schedule for '1F08'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | OXFDSY  |                  | 10:01              |      | LIN  |
      | OXFDNNJ |                  | 10:05              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | PRTOBJP | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F08'
    Then no path code is displayed for location 'Oxford North Jn'


