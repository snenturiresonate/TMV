@fixed-time
Feature: 37659 - Schedule Matching - Consistent Stepping has a time limit

  As a TMV user
  I want C-class data on running services to be matched to the planned train schedule from the CIF
  So that the system can build and update a train models to allow schematic maps to display trains and their timetables

  Background:
    * I am viewing the map HDGW01paddington.v
    * I have cleared out all headcodes
    * The admin setting defaults are as originally shipped
    * I remove today's train 'H39407' from the trainlist
    * the access plan located in CIF file 'access-plan/37659-schedules/9F01.cif' is received from LINX
    * I wait until today's train 'H39407' has loaded
    * the following berth interpose messages is sent from LINX (to indicate train is present)
      | timestamp | toBerth | trainDescriber | trainDescription |
      | 10:00:00  | R001    | D3             | 9F01             |
    * I am viewing the map HDGW01paddington.v


  Scenario: 37659 -6  Consistent stepping not applied if outside allowed time and unable to match current location
    Given the following berth step messages is sent from LINX (to move train)
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:00:00  | R001      | 0212    | D3             | 9F01             |
    When the following berth step messages is sent from LINX (to move train)
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:20:00  | 0212      | 0222    | D3             | 9F01             |
    Then berth '0222' in train describer 'D3' contains '9F01' and is visible
    And the train headcode color for berth 'D30222' is lightgrey

  Scenario: 37659 -7  Context menu when too old for consistent stepping
    #    Given a TD update with the type <stepType> has been received
    #    And a prior TD update has been matched to the service more than 20 minutes ago
    #    And unable to rematch at berth, location or sub division level
    #    And the user is viewing the map that contains that berth
    #    When the user opens the context menu for the train description
    #    Then the unmatched version of the context menu is displayed
    #
    #    Examples:
    #      | stepType |
    #      | Step     |
    Given the following berth step messages is sent from LINX (to move train)
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:00:00  | R001      | 0212    | D3             | 9F01             |
    When the following berth step messages is sent from LINX (to move train)
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:20:00  | 0212      | 0222    | D3             | 9F01             |
    Then berth '0222' in train describer 'D3' contains '9F01' and is visible
    And I invoke the context menu on the map for train 9F01
    And the Unmatched version of the Schedule-matching map context menu is displayed

  @manual @manual:93510
  Scenario Outline: 37659 -8  Consistent stepping not applied if outside allowed time but schedule rematched
    When the following berth step messages is sent from LINX (to move train)
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:20:00  | R001      | <berth> | D3             | 9F01             |
    Then berth '<berth>' in train describer 'D3' contains '9F01' and is visible
    And the rectangle colour for berth D3<berth> is not <colour> meaning no timetable

    Examples:
      | trainDescriber | berth | location | subdivision | matchLevel   | colour    |
      | D3             | A001  | PADTON   | 401         | berth        | lightgrey |
      | D3             | A011  | PADTON   | 401         | location     | lightgrey |
      | D3             | 0106  | PRTOBJP  | 401         | sub-division | lightgrey |

  @manual @manual:93511
  Scenario Outline: 37659 -9  Context menu when too old for consistent stepping
    When the following berth step messages is sent from LINX (to move train)
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:20:00  | R001      | <berth> | D3             | 9F01             |
    Then berth '<berth>' in train describer 'D3' contains '9F01' and is visible
    And I invoke the context menu on the map for train 9F01
    And the Matched version of the Schedule-matching map context menu is displayed

    Examples:
      | trainDescriber | berth | location | subdivision | matchLevel   |
      | D3             | A001  | PADTON   | 401         | berth        |
      | D3             | A011  | PADTON   | 401         | location     |
      | D3             | 0106  | PRTOBJP  | 401         | sub-division |

