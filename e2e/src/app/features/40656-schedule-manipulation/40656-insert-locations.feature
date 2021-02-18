Feature: 40656 - Schedule Manipulation - Add locations

  As a TMV user
  I want schedules which have been imported to be manipulated such that passing locations are inserted
  So that the schedule has a full set of locations that the service will stop or pass

  @tdd
  Scenario: 40656-1 Schedule with no inserted locations
    Given there is a Schedule for '1F01'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 10:00            | 10:01              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F01'
    And the Inserted toggle is 'on'
    Then no inserted locations are displayed

  @tdd
  Scenario: 40656-2 Schedule with inserted locations
    #I1102	LDBRKJ 	ACTONW 	ACTONML	747
    Given there is a Schedule for '1F02'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc | scheduledArrival | scheduledDeparture | path | line |
      | LDBRKJ |                  | 10:01              |      |      |
      | ACTONW |                  | 10:05              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F02'
    And the Inserted toggle is 'on'
    Then the inserted location 'Acton Main Line' is displayed in square brackets
    And the inserted location Acton Main Line is after Ladbroke Grove
    And the inserted location Acton Main Line is before Acton West
    And the expected arrival time for inserted location Acton Main Line is 747 percent between 10:01:00 and 10:05:00
