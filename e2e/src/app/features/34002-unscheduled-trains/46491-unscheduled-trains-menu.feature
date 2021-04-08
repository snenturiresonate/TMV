Feature: 34002 - Unscheduled Trains Menu

  As a TMV User
  I want to view unscheduled trains
  So that I can determine if the unscheduled requires schedule matching

  Background:
    Given I am authenticated to use TMV with 'matching' role

  Scenario Outline:34002-3a Select Service for Matching (Map)
#    Given the user is viewing a live schematic map or trains list
#    And there are unmatched services viewable
#    And the user has the matching role
#    When the user selects an unmatched service using the secondary click
#    Then the user is presented with a menu with a match option
    And I am viewing the map HDGW02reading.v
    And I have cleared out all headcodes
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | 0523    | D6             | <trainNum>       |
    When I invoke the context menu on the map for train <trainNum>
    Then the map context menu has 'Match' on line 3
    Examples:
      | trainNum |
      | 2B01     |


  Scenario Outline:34002-3b Select Service for Matching (Trains List - unmatched stepping)
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | 1777    | D1             | <trainNum>       |
    And I navigate to TrainsList page
    When I invoke the context menu from train '<trainNum>' on the trains list
    And I wait for the context menu to display
    Then the trains list context menu is displayed
    And the trains list context menu has 'Match' on line 3
    Examples:
      | trainNum |
      | 2B02     |


  Scenario Outline:34002-3c Select Service for Matching (Trains List - unmatched TRI)
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainNum>  | today              | 73822               | SLOUGH                 | Departure from Origin |
    And I navigate to TrainsList page
    When I invoke the context menu from train '<trainNum>' on the trains list
    And I wait for the context menu to display
    Then the trains list context menu is displayed
    And the trains list context menu has 'Match' on line 3
    Examples:
      | trainNum | planningUid |
      | 2B03     | L20003      |


  Scenario Outline:34002-4a Select Service for Rematching (Map)
#    Given the user is viewing a live schematic map or trains list
#    And there are matched services viewable
#    And the user has the schedule matching role
#    When the user selects a matched service using the secondary click
#    Then the user is presented with a menu with a rematch option
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | RDNGSTN     | WTT_dep       | <trainNum>          | <planningUid>  |
    And I am viewing the map HDGW02reading.v
    And I have cleared out all headcodes
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 1711    | D1             | <trainNum>       |
    When I invoke the context menu on the map for train <trainNum>
    Then the map context menu has 'Unmatch / Rematch' on line 3
    Examples:
      | trainNum | planningUid |
      | 2B04     | L20004      |


  @bug @bug_58145
  Scenario Outline:34002-4b Select Service for Rematching (Trains List)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | STHALL      | WTT_dep       | <trainNum>          | <planningUid>  |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0255    | D4             | <trainNum>       |
    And I navigate to TrainsList page
    When I invoke the context menu from train '<trainNum>' on the trains list
    And I wait for the context menu to display
    Then the trains list context menu is displayed
    And the map context menu has 'Unmatch / Rematch' on line 3
    Examples:
      | trainNum | planningUid |
      | 2B05     | L20005      |
