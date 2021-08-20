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
    Then the Unmatched version of the map context menu is displayed
    Examples:
      | trainNum |
      | 2B01     |

  # unmatched services from stepping is part of CCN1
  @tdd
  Scenario Outline:34002-3b Select Service for Matching (Trains List - unmatched stepping)
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | 1777    | D1             | <trainNum>       |
    And I navigate to TrainsList page
    When I invoke the context menu for todays train '<trainNum>' schedule uid 'UNPLANNED' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu is displayed
    And the Unmatched version of the trains list context menu is displayed
    Examples:
      | trainNum |
      | 2B02     |

  Scenario Outline:34002-3c Select Service for Matching (Trains List - unmatched TRI)
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainNum>  | today              | 73822               | SLOUGH                 | Departure from Origin |
    And I navigate to TrainsList page
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainNum>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu is displayed
    And the Unmatched version of the trains list context menu is displayed
    Examples:
      | trainNum | planningUid |
      | 2B03     | L20003      |

  @tdd @tdd:50351
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
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | 1711    | D1             | <trainNum>       |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 1711      | 1733    | D1             | <trainNum>       |
    When I invoke the context menu on the map for train <trainNum>
    Then the Matched version of the map context menu is displayed
    Examples:
      | trainNum | planningUid |
      | 2B04     | L20004      |

  @tdd @tdd:50351
  Scenario Outline:34002-4b Select Service for Rematching (Trains List)
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | STHALL      | WTT_pass      | <trainNum>          | <planningUid>  |
    And I navigate to TrainsList page
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber | trainDescription |
      | 0255    | D4             | <trainNum>       |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0255      | 0271    | D4             | <trainNum>       |
    And train '<trainNum>' with schedule id '<planningUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainNum>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu is displayed
    And the Matched version of the trains list context menu is displayed
    Examples:
      | trainNum | planningUid |
      | 2B05     | L20005      |
