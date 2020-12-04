Feature: 40656 - Schedule Manipulation - Apply Rules In Order

  As a TMV user
  I want schedules which have been imported to be manipulated
  So that the schedule has a the correct path, line and asset codes for each location

  @tdd
  Scenario: 40656-9 Schedule with inserted location updated by line to path rules
  #IXXA0	ACTONW 	WEALING	EALINGB	323
  #K1106	ACTONW 	EALINGB
    Given there is a Schedule for '1F09'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ACTONW  |                  | 10:01              | PAT  | LIN  |
      | WEALING |                  | 10:05              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F09'
    And the Inserted toggle is 'on'
    Then the path code for Location is correct
      | location        | pathCode |
      | Ealing Broadway | LIN      |

  @tdd
  Scenario: 40656-10 Schedule with locations updated by path to line rules to match line to path
  #J0044	DIDCOTP
  #K005A	DIDCOTP	DIDCWCJ
    Given there is a Schedule for '1F10'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | DIDCOTP |                  | 10:01              | PAT  |      |
      | DIDCWCJ |                  | 10:05              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F10'
    Then the line code for Location is correct
      | location       | lineCode |
      | Didcot Parkway | PAT      |
    And the path code for Location is correct
      | location             | pathCode |
      | Didcot West Curve Jn | PAT      |

  @tdd
  Scenario: 40656-11 Schedule with locations updated by line to path to match path to line rules
  #K005A	DIDCOTP	DIDCWCJ
  #J0046	DIDCWCJ
    Given there is a Schedule for '1F11'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | DIDCOTP |                  | 10:01              |      | LIN  |
      | DIDCWCJ |                  | 10:05              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F11'
    Then the line code for Location is correct
      | location             | lineCode |
      | Didcot West Curve Jn | LIN      |
    And the path code for Location is correct
      | location             | pathCode |
      | Didcot West Curve Jn | LIN      |
