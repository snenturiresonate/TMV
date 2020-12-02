Feature: 40656 - Schedule Manipulation - Add locations

  As a TMV user
  I want schedules which have been imported to be manipulated such that passing locations are inserted
  So, that the schedule has a full set of locations that the service will stop or pass

  @tdd
  Scenario: 40656-1 Schedule with no inserted locations
    Given the access plan is received from LINX
      | path                                                              |
      | access-plan/schedule-manipulation/no-location-insertion-rules.cif |
    When I am on the timetable view for service '1F01'
    And the Inserted toggle is 'on'
    Then no inserted locations are displayed

  @tdd
  Scenario Outline: 40656-2 Schedule with inserted locations
    #I1102	LDBRKJ 	ACTONW 	ACTONML	747
    Given the access plan is received from LINX
      | path                                                           |
      | access-plan/schedule-manipulation/location-insertion-rules.cif |
    When I am on the timetable view for service '1F02'
    And the Inserted toggle is 'on'
    Then the inserted location '<inserted>' is displayed in square brackets
    And the inserted location <inserted> is after <start>
    And the inserted location <inserted> is before <end>
    And the expected arrival time for inserted location <inserted> is <percentage> percent between <startDeparture> and <endArrival>

    Examples:
      | start          | end        | inserted        | percentage | startDeparture | endArrival |
      | Ladbroke Grove | Acton West | Acton Main Line | 747        | 10:01:00       | 10:03:00   |



