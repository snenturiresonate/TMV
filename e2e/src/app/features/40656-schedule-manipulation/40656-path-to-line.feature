Feature: 40656 - Schedule Manipulation - Path To Line

  As a TMV user
  I want schedules which have been imported to be manipulated
  So that the schedule has a the correct path, line and asset codes for each location

  Scenario Outline: 40656-3 Schedule with propagated line code
    #J0053	OXFDNNJ
#    Given A service has a schedule in the current time period
#    And that schedule includes locations that match entries in the path code to line code propagation rules
#    And the path code for the matching location is populated
#    And the line code for the matching location is null
#    When a user selects to see that schedule in the timetable view
#    Then the line code displayed for those locations is the same as the path code
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given there is a Schedule for '<trainNum>'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
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
    Then the locations line code matches the path code
      | location        | pathCode |
      | Oxford North Jn | PAT      |

    Examples:
      | trainNum | planningUid |
      | 1G03     | G30003      |

  Scenario Outline: 40656-4 Schedule with location with existing line code
    #J0053	OXFDNNJ
#    Given A service has a schedule in the current time period
#    And that schedule includes locations that match entries in the path code to line code propagation rules
#    And the line code is already populated with a different value to the path code
#    When a user selects to see that schedule in the timetable view
#    Then the original line code from the schedule is displayed for that location
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given there is a Schedule for '<trainNum>'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | OXFDNNJ |                  | 10:05              | PAT  | LIN  |
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
      | location        | lineCode |
      | Oxford North Jn | LIN      |

    Examples:
      | trainNum | planningUid |
      | 1G04     | G30004      |

  Scenario Outline: 40656-5 Schedule with location without matching path to line code rules
#    Given A service has a schedule in the current time period
#    And that schedule includes locations that don't match entries in the path code to line code propagation rules
#    And the line code is not populated
#    When a user selects to see that schedule in the timetable view
#    Then no line code is displayed for that location
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given there is a Schedule for '<trainNum>'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc | scheduledArrival | scheduledDeparture | path | line |
      | OXFD   |                  | 10:01              | PAT  |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | PRTOBJP | 10:13            |      |
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<planningUid>' has loaded
    When I am on the timetable view for service '<planningUid>'
    Then no line code is displayed for location 'Oxford'

    Examples:
      | trainNum | planningUid |
      | 1G05     | G30005      |
