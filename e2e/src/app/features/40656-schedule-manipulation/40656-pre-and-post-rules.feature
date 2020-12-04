Feature: 40656 - Schedule Manipulation - Pre and Post Rules

  As a TMV user
  I want schedules which have been imported to be manipulated
  So that the schedule has a the correct path, line and asset codes for each location

  @tdd
  Scenario: 40656- 12 Pre Change path code
    #19	PRE 	HTHRGRN	LEEE   	   	   	   	   	   	   	[]	[]	DDL
    #J2311	HTHRGRN
    Given there is a Schedule for '1F12'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | HTHRGRN |                  | 10:01              | PAT  |      |
      | LEEE    |                  | 10:05              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | PRTOBJP | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F12'
    And the path code for Location is correct
      | location     | pathCode |
      | Hither Green | DDL      |
    Then the line code for Location is correct
      | location     | lineCode |
      | Hither Green | DDL      |

  @tdd
  Scenario: 40656- 13 Post Change path code
    #241	POST	CAMHTH 	BTHNLGR	   	   	   	FL 	   	S  	[]	[]	   	   	   	S
    #J7010	BTHNLGR
    Given there is a Schedule for '1F13'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | CAMHTH  |                  | 10:01              |      |      |
      | BTHNLGR |                  | 10:05              | FL   |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | PRTOBJP | 10:13            |      |
    And the schedule is received from LINX
    When I am on the timetable view for service '1F13'
    And the path code for Location is correct
      | location      | pathCode |
      | Bethnal Green | S        |
    Then the line code for Location is correct
      | location      | lineCode |
      | Bethnal Green | FL       |
