@TMVPhase2 @P2.S3
Feature: 79730 - Unmatch a service - Map

  Background:
    * I have not already authenticated
    * I am on the home page
    * The admin setting defaults are as originally shipped
    * I have cleared out all headcodes

  Scenario: 80309 - Unmatch via Map
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

  Scenario Outline: 80311 - Unmatch via Map Dialogue (Cancel)
#    Given the user is authenticated to use TMV
#    And the user is viewing a map
#    And the has the schedule matching privilege
#    And has select a matched service to unmatch
#    And is viewing unmatch confirmation dialogue
#    When the user selects to the cancel the action
#    Then the service remains matched
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am viewing the map HDGW01paddington.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    Then berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible
    When I wait for the Open timetable option for train description <trainDescription> in berth A007, describer D3 to be available
    And I invoke the context menu on the map for train <trainDescription>
    Then the Matched version of the map context menu is displayed
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    And I un-match the currently matched schedule
    And I click the unmatch cancel option
    Then a matched service is visible
    When the following live berth step message is sent from LINX (to move train)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And I switch to the second-newest tab
    And I wait for the option to Match train description <trainDescription> in berth 0039, describer D3 to be available
    And I invoke the context menu on the map for train <trainDescription>
    Then the Matched version of the map context menu is displayed

    Examples:
      | trainDescription | trainUid  |
      | generated        | generated |

  Scenario Outline: 80310 - Unmatch via Map Dialogue (Confirm)
#    Given the user is authenticated to use TMV
#    And the user is viewing a map
#    And the has the schedule matching privilege
#    And has selected a matched service to unmatch
#    And is viewing unmatch confirmation dialogue
#    When the user selects affirmative action
#    Then the service is unmatched
#    And remains unmatched for the remainder of its journey unless rematched by a user
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1B69_PADTON_SWANSEA.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I am viewing the map HDGW01paddington.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    Then berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible
    When I wait for the Open timetable option for train description <trainDescription> in berth A007, describer D3 to be available
    And I invoke the context menu on the map for train <trainDescription>
    Then the Matched version of the map context menu is displayed
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    And I un-match the currently matched schedule
    And I click the unmatch save option
    Then no matched service is visible
    When the following live berth step message is sent from LINX (to move train)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And I switch to the second-newest tab
    And I wait for the option to Match train description <trainDescription> in berth 0039, describer D3 to be available
    And I invoke the context menu on the map for train <trainDescription>
    Then the Unmatched version of the map context menu is displayed

    Examples:
      | trainDescription | trainUid  |
      | generated        | generated |
