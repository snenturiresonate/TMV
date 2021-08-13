Feature: 40656 - Schedule Manipulation - Pre and Post Rules

  As a TMV user
  I want schedules which have been imported to be manipulated
  So that the schedule has a the correct path, line and asset codes for each location

  Scenario Outline: 40656- 12 Pre Change path code
    #19	PRE 	HTHRGRN	LEEE   	   	   	   	   	   	   	[]	[]	DDL
    #J2311	HTHRGRN
#    Given A service has a schedule in the current time period
#    And that schedule includes a location that matches an entry in the pre propagation rules to change the path code
#    And the same location matches an entry in the path code to line code propagation rules
#    And the path code is not null for the matching to location
#    And the line code is null for the matching location
#    When a user selects to see that schedule in the timetable view
#    Then the path code displayed for location is the path code specified in the pre-propagation rule
#    And the line code displayed for to location is the same as the path code specified in the pre-propagation rule
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given there is a Schedule for '<trainNum>'
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
    And the schedule has schedule identifier characteristics
      | trainUid      | stpIndicator | dateRunsFrom |
      | <planningUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<planningUid>' has loaded
    When I am on the timetable view for service '<planningUid>'
    Then the path code for Location is correct
      | location     | pathCode |
      | Hither Green | DDL      |
    And the line code for Location is correct
      | location     | lineCode |
      | Hither Green | DDL      |

    Examples:
      | trainNum | planningUid |
      | 1G12     | G30012      |

  @bug @bug:61103
  Scenario Outline: 40656- 13 Post Change path code
    #241	POST	CAMHTH 	BTHNLGR	   	   	   	FL 	   	S  	[]	[]	   	   	   	S
    #J7010	BTHNLGR
#    Given A service has a schedule in the current time period
#    And that schedule includes a location that matches an entry in the post propagation rules to change the path code
#    And the same location matches an entry in the path code to line code propagation rules
#    And the path code is not null for the matching to location
#    And the line code is null for the matching location
#    When a user selects to see that schedule in the timetable view
#    Then the path code displayed for location is the path code specified in the post-propagation rule
#    And the line code displayed for to location is the same as the path code specified in original schedule
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given the access plan located in CIF file 'access-plan/40656_13.cif' is received from LINX
    And I wait until today's train '<planningUid>' has loaded
    When I am on the timetable view for service '<planningUid>'
    Then the path code for Location is correct
      | location      | pathCode |
      | Bethnal Green | S        |
    And the line code for Location is correct
      | location      | lineCode |
      | Bethnal Green | FL       |

    Examples:
      | trainNum | planningUid |
      | 2D23     | C91764      |
