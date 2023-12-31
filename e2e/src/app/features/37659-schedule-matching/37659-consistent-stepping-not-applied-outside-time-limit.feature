Feature: 37659 - Schedule Matching - Consistent Stepping has a time limit

  As a TMV user
  I want C-class data on running services to be matched to the planned train schedule from the CIF
  So that the system can build and update a train models to allow schematic maps to display trains and their timetables

  Background:
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And the access plan located in CIF file 'access-plan/37659-schedules/9F01.cif' is received from LINX
    And the following berth interpose messages is sent from LINX
      | timestamp | toBerth | trainDescriber | trainDescription |
      | 10:00:00  | R001    | D3             | 9F01             |

  @tdd
  Scenario: 37659 -6  Consistent stepping not applied if outside allowed time and unable to match current location
    Given the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:00:00  | R001      | 0212    | D3             | 9F01             |
    When the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:20:00  | 0212      | 0222    | D3             | 9F01             |
    Then berth '0222' in train describer 'D3' contains '9F01' and is visible
    And the train headcode color for berth 'D30222' is blue

  Scenario: 37659 -7  Context menu when too old for consistent stepping
    Given the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:00:00  | R001      | 0212    | D3             | 9F01             |
    When the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:20:00  | 0212      | 0222    | D3             | 9F01             |
    Then berth '0222' in train describer 'D3' contains '9F01' and is visible
    And I invoke the context menu on the map for train 9F01
    And the Unmatched version of the context menu is displayed

  @tdd
  Scenario Outline: 37659 -8  Consistent stepping not applied if outside allowed time but schedule rematched
    When the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:20:00  | R001      | <berth> | D3             | 9F01             |
    Then berth '<berth>' in train describer 'D3' contains '9F01' and is visible
    And the train headcode color for berth 'D3<berth>' is <colour>

    Examples:
      | trainDescriber | berth | location | subdivision | matchLevel   | colour |
      | D3             | A001  | PADTON   | 401         | berth        | green  |
      | D3             | A011  | PADTON   | 401         | location     | green  |
      | D3             | 0106  | PRTOBJP  | 401         | sub-division | green  |

  Scenario Outline: 37659 -9  Context menu when too old for consistent stepping
    When the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription |
      | 10:20:00  | R001      | <berth> | D3             | 9F01             |
    Then berth '<berth>' in train describer 'D3' contains '9F01' and is visible
    And I invoke the context menu on the map for train 9F01
    And the Matched version of the context menu is displayed

    Examples:
      | trainDescriber | berth | location | subdivision | matchLevel   |
      | D3             | A001  | PADTON   | 401         | berth        |
      | D3             | A011  | PADTON   | 401         | location     |
      | D3             | 0106  | PRTOBJP  | 401         | sub-division |

