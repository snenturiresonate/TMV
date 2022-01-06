Feature: 79730 - Unmatch a service - Map

  Background:
    * I have not already authenticated
    * I am on the home page
    * The admin setting defaults are as originally shipped
    * I have cleared out all headcodes

  Scenario: 80312 - Unmatch via Trains List dialogue
#    Given the user is authenticated to use TMV
#    And the user is viewing a map
#    And the has the schedule matching privilege
#    And has select a matched service to unmatch
#    When the user selects the unmatch option
#    Then the unmatch confirmation dialogue is displayed
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | PADTON      | WTT_dep       | 1F45                | L00025         |
    And I wait until today's train 'L00025' has loaded
    And I am viewing the map HDGW01paddington.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | 1F45             |
    Then berth 'A007' in train describer 'D3' contains '1F45' and is visible
    When I invoke the context menu on the map for train 1F45
    Then the Matched version of the map context menu is displayed
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching 1F45'
    When I un-match the currently matched schedule
    Then the Unmatch confirmation dialogue is displayed
