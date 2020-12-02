Feature: 40656 - Schedule Manipulation - Add locations

  As a TMV user
  I want schedules which have been imported to be manipulated such that passing locations are inserted
  So, that the schedule has a full set of locations that the service will stop or pass

  @tdd
  Scenario: 40656-9 Schedule with inserted location updated by line to path rules
  #IXXA0	ACTONW 	WEALING	EALINGB	323
  #K1106	ACTONW 	EALINGB
    Given the access plan is received from LINX
      | path                                                                        |
      | access-plan/schedule-manipulation/location-insertion-rules-line-to-path.cif |
    When I am on the timetable view for service '1F09'
    And the Inserted toggle is 'on'
    Then the path code for Location is correct
      | location        | pathCode |
      | Ealing Broadway | LIN      |

  @tdd
  Scenario: 40656-10 Schedule with locations updated by path to line rules to match line to path
  #J0044	DIDCOTP
  #K005A	DIDCOTP	DIDCWCJ
    Given the access plan is received from LINX
      | path                                                                 |
      | access-plan/schedule-manipulation/path-to-line-then-line-to-path.cif |
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
    Given the access plan is received from LINX
      | path                                                                 |
      | access-plan/schedule-manipulation/line-to-path-then-path-to-line.cif |
    When I am on the timetable view for service '1F11'
    Then the line code for Location is correct
      | location             | lineCode |
      | Didcot West Curve Jn | LIN      |
    And the path code for Location is correct
      | location             | pathCode |
      | Didcot West Curve Jn | LIN      |
