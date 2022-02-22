Feature: 40656 - Schedule Manipulation - Line To Path

  As a TMV user
  I want schedules which have been imported to be manipulated
  So that the schedule has a the correct path, line and asset codes for each location

  Background:
    * I remove all trains from the trains list
    * I am on the home page
    * I restore to default train list config '1'

  Scenario Outline: 40656-6 Schedule with locations matching line code to path code rules
    #K0056	OXFD   	OXFDNNJ
#    Given A service has a schedule in the current time period
#    And that schedule includes pairs of locations that match entries in the line code to path code propagation rules
#    And the line code is populated for the matching from location
#    And the path code is not populated for the matching to location
#    When a user selects to see that schedule in the timetable view
#    Then the path code displayed for the To Location is the same as the line code for the From Location
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given there is a Schedule for '<trainNum>'
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
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<planningUid>' has loaded
    When I am on the timetable view for service '<planningUid>'
    Then the path code for the To Location matches the line code for the From Location
      | fromLocation | lineCode | toLocation      |
      | Oxford       | LIN      | Oxford North Jn |

    Examples:
      | trainNum | planningUid |
      | 1G06     | G30006      |

  Scenario Outline: 40656-7 Schedule with locations with existing path code
    #K0056	OXFD   	OXFDNNJ
#    Given A service has a schedule in the current time period
#    And that schedule includes pairs of locations that match entries in the line code to path code propagation rules
#    And the line code is populated for the matching from location
#    And the path code is populated for the matching to location
#    When a user selects to see that schedule in the timetable view
#    Then then the original path code is displayed for the From Location
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given there is a Schedule for '<trainNum>'
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
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<planningUid>' has loaded
    When I am on the timetable view for service '<planningUid>'
    Then the locations path code matches the original path code
      | location        | pathCode |
      | Oxford North Jn | PAT      |

    Examples:
      | trainNum | planningUid |
      | 1G07     | G30007      |

  Scenario Outline: 40656-7b From Locations line is not back filled from To Locations Path with matching rule
    #K0056	OXFD   	OXFDNNJ
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given there is a Schedule for '<trainNum>'
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
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<planningUid>' has loaded
    When I am on the timetable view for service '<planningUid>'
    Then the locations line code matches the original line code
      | location | lineCode |
      | Oxford   | LIN      |

    Examples:
      | trainNum | planningUid |
      | 1E07     | H40007      |

  Scenario Outline: 40656-8 Schedule with locations without matching line code to path code rules
#    Given A service has a schedule in the current time period
#    And that schedule includes a pair of locations that does not match entries in the line code to path code propagation rules
#    And the line code is populated for the from location that doesn't match
#    And the path code is null for to location that doesn't match
#    When a user selects to see that schedule in the timetable view
#    Then then the path code is not displayed for the to location
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given there is a Schedule for '<trainNum>'
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
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<planningUid>' has loaded
    When I am on the timetable view for service '<planningUid>'
    Then no path code is displayed for location 'Oxford North Jn'

    Examples:
      | trainNum | planningUid |
      | 1G08     | G30008      |


