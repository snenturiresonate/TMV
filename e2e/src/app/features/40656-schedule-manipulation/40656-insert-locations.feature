Feature: 40656 - Schedule Manipulation - Add locations

  As a TMV user
  I want schedules which have been imported to be manipulated such that passing locations are inserted
  So that the schedule has a full set of locations that the service will stop or pass

  Scenario Outline: 40656-1 Schedule with no inserted locations
#    Given A service has a schedule in the current time period
#    And that schedule does not include any location pairs that match any entries in the location insertion rules
#    When a user selects to see the inserted locations for that schedule in the timetable view
#    Then no additional locations are displayed

    * I remove today's train '<planningUid>' from the trainlist
    Given there is a Schedule for '<trainNum>'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 10:00            | 10:01              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<planningUid>' has loaded
    When I am on the timetable view for service '<planningUid>'
    And the Inserted toggle is 'on'
    Then no inserted locations are displayed

    Examples:
      | trainNum | planningUid |
      | 1G01     | G30001      |

  Scenario Outline: 40656-2 Schedule with inserted locations
    #I1102	LDBRKJ 	ACTONW 	ACTONML	747
#    Given A service has a schedule in the current time period
#    And that schedule includes pairs of locations that match entries in the location insertion rules
#    When a user selects to see the inserted locations for that schedule in the timetable view
#    Then the additional locations are displayed in [] brackets
#    And in the correct place in the schedule
#    And the time passing time displayed is suitable for its position in the timetable
    * I remove today's train '<planningUid>' from the trainlist
    Given there is a Schedule for '<trainNum>'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 10:58              |      |
    And it has Intermediate Details
      | tiploc | scheduledArrival | scheduledDeparture | path | line |
      | LDBRKJ |                  | 11:01              |      |      |
      | ACTONW |                  | 11:05              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 11:13            |      |
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<planningUid>' has loaded
    When I am on the timetable view for service '<planningUid>'
    And the Inserted toggle is 'on'
    Then the inserted location 'Acton Main Line' is displayed in square brackets
    And the inserted location Acton Main Line is after Ladbroke Grove
    And the inserted location Acton Main Line is before Acton West
    And the expected departure time for inserted location Acton Main Line is proportionally 747 thousandths between 11:01:00 and 11:05:00

    Examples:
      | trainNum | planningUid |
      | 1G02     | G30002      |
