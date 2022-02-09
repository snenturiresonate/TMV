@TMVPhase2 @P2.S2
Feature: 79143 - TMV Movement Log Viewer - View Additional Data (Punctuality Status)

  As a TMV User
  I want to view, filter and search the Movement Logs
  So that I can work with the data that is of interest to me within the Movement Logs

  Background:
    Given I clear the logged-berth-states Elastic Search index
    And I clear the logged-signal-states Elastic Search index
    And I clear the logged-latch-states Elastic Search index
    And I clear the logged-s-class Elastic Search index
    And I clear the logged-agreed-schedules Elastic Search index

  Scenario Outline: 80283-1 - Movement Log - View Additional Data (Punctuality Status late)
    # Given the user is authenticated to use TMV
    # And the user is viewing the Movement Logs
    # When the search results are loaded:
    # Then a late punctuality status is available
    * I am on the log viewer page
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now - '2' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid1> |
    And I wait until today's train '<planningUid1>' has loaded
    And the following train activation message is sent from LINX
      | trainUID       | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid1> | <trainNum>  | now                    | 99999               | PADTON                 | today         | now                 |
    When the following live berth interpose message is sent from LINX (to create a match at Paddington)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | <trainNum>       |
    And the following live berth step message is sent from LINX
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | A007      | 0039    | D3             | <trainNum>       |
    And I navigate to the Movement log tab
    When I search for Berth logs for toBerthId '0039'
    Then the log results for row '1' displays '<trainNum>' and punctuality '+'
    Examples:
      | trainNum  | planningUid1 |
      | generated | generated    |

  Scenario Outline: 80283-2 - Movement Log - View Additional Data (Punctuality Status early)
    # Given the user is authenticated to use TMV
    # And the user is viewing the Movement Logs
    # When the search results are loaded
    # Then an early  punctuality status is available
    * I am on the log viewer page
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid1> |
    And I wait until today's train '<planningUid1>' has loaded
    And the following train activation message is sent from LINX
      | trainUID       | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid1> | <trainNum>  | now                    | 99999               | PADTON                 | today         | now                 |
    When the following live berth interpose message is sent from LINX (to create a match at Paddington)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | <trainNum>       |
    And the following live berth step message is sent from LINX
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | A007      | 0039    | D3             | <trainNum>       |
    And I navigate to the Movement log tab
    When I search for Berth logs for toBerthId '0039'
    Then the log results for row '1' displays '<trainNum>' and punctuality '-'
    Examples:
      | trainNum  | planningUid1 |
      | generated | generated    |

  Scenario Outline: 80283-3 - Movement Log - View Additional Data (Punctuality Status on time)
    # Given the user is authenticated to use TMV
    # And the user is viewing the Movement Logs
    # When the search results are loaded
    # Then on time punctuality status is available
    * I generate a new train description
    * I generate a new trainUID
    And the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                                    | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/2P04_RDNGSTN_PADTON_STOPPER.cif | WEALING     | WTT_pass      | <trainNum>          | <planningUid1> |
    And I wait until today's train '<planningUid1>' has loaded
    And the following live berth interpose message is sent from LINX (to create a match at West Ealing)
      | toBerth | trainDescriber | trainDescription |
      | 0214    | D3             | <trainNum>       |
    And I am viewing the map HDGW01paddington.v
    And berth '0214' in train describer 'D3' contains '<trainNum>' and is visible
    And the train headcode color for berth 'D30214' is green
    And the following live berth step message is sent from LINX
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0214      | 0215    | D3             | <trainNum>       |
    And I am on the log viewer page
    And I navigate to the Movement log tab
    When I search for Berth logs for toBerthId '0215'
    Then the log results for row '1' displays '<trainNum>' and punctuality '0'
    Examples:
      | trainNum  | planningUid1 |
      | generated | generated    |


  Scenario Outline: 80283-4 - Movement Log - View Additional Data (Punctuality Status unavailable)
    # Given the user is authenticated to use TMV
    # And the user is viewing the Movement Logs
    # When the search results are loaded
    # Then the punctuality status is unavailable
    * I am on the log viewer page
    * I generate a new train description
    * I generate a new trainUID
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainNum>          | <planningUid1> |
    And I wait until today's train '<planningUid1>' has loaded
    And the following train activation message is sent from LINX
      | trainUID       | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid1> | <trainNum>  | now                    | 99999               | PADTON                 | today         | now                 |
    When the following live berth interpose message is sent from LINX (to create a match at Paddington)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | <trainNum>       |
    And I navigate to the Movement log tab
    When I search for Berth logs for toBerthId 'A007'
    Then the log results for row '1' displays '<trainNum>' and punctuality 'null'
    Examples:
      | trainNum  | planningUid1 |
      | generated | generated    |
