Feature: 40656 - Schedule Manipulation - Apply Rules In Order

  As a TMV user
  I want schedules which have been imported to be manipulated
  So that the schedule has a the correct path, line and asset codes for each location

  Scenario Outline: 40656-9 Schedule with inserted location updated by line to path rules
  #IXXA0	ACTONW 	WEALING	EALINGB	323
  #K1106	ACTONW 	EALINGB
#    Given A service has a schedule in the current time period
#    And that schedule includes pairs of locations that match entries in the location insertion rules
#    And the from location and the inserted location matches an entry in the line code to path code propagation rules
#    And the line  code is populated for the from location
#    When a user selects to see that schedule in the timetable view
#    Then the path code displayed for inserted location is the same as the line code for the from location
    Given there is a Schedule for '<trainNum>'
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
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    When I am on the timetable view for service '<planningUid>'
    And the Inserted toggle is 'on'
    Then the path code for Location is correct
      | location          | pathCode |
      | [Ealing Broadway] | LIN      |

    Examples:
      | trainNum | planningUid |
      | 1G09     | G30009      |

  Scenario Outline: 40656-10 Schedule with locations updated by path to line rules to match line to path
  #J0044	DIDCOTP
  #K005A	DIDCOTP	DIDCWCJ
#    Given A service has a schedule in the current time period
#    And that schedule includes pairs of locations that match entries in the path to line and line code to path code propagation rules
#    And the path code is populated for the from location matching the path to line code propagation rules
#    And the line code is null for the from location matching the path to line code propagation rules
#    And the path code is null for the matching to location
#    When a user selects to see that schedule in the timetable view
#    Then the line code displayed for from location is the same as the path code for the from location
#    And the path code displayed for to location is the same as the line code for the from location
    Given there is a Schedule for '<trainNum>'
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
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    When I am on the timetable view for service '<planningUid>'
    Then the line code for Location is correct
      | location       | lineCode |
      | Didcot Parkway | PAT      |
    And the path code for Location is correct
      | location             | pathCode |
      | Didcot West Curve Jn | PAT      |

    Examples:
      | trainNum | planningUid |
      | 1G10     | G30010      |

Scenario Outline: 40656-11 Schedule with locations updated by line to path to match path to line rules
  #K005A	DIDCOTP	DIDCWCJ
  #J0046	DIDCWCJ
#    Given A service has a schedule in the current time period
#    And that schedule includes pairs of locations that match entries in the path to line and line code to path code propagation rules
#    And the path code is null for the to location matching the line to path code propagation rules
#    And the line code is null for the location matching the path to line code propagation rules
#    And the Line code is populated for the matching from location
#    When a user selects to see that schedule in the timetable view
#    Then the line code displayed for from location is the same as the path code for the from location
#    And the path code displayed for to location is the same as the line code for the from location
    Given there is a Schedule for '<trainNum>'
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
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I am on the trains list page
    And The trains list table is visible
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    When I am on the timetable view for service '<planningUid>'
    Then the line code for Location is correct
      | location             | lineCode |
      | Didcot West Curve Jn | LIN      |
    And the path code for Location is correct
      | location             | pathCode |
      | Didcot West Curve Jn | LIN      |

    Examples:
      | trainNum | planningUid |
      | 1G11     | G30011      |
