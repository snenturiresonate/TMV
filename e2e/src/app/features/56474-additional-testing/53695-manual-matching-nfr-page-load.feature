@bug @86675
Feature: 53695 - Manual Matching - NFR testing (page load)

  As a TMV dev team member
  I want to have automated test to monitor the performance of manually changing the match status of a service
  So that I can have early sight of any performance issues

  Background:
    * I reset the stopwatch
    * I generate a new trainUID
    * I generate a new train description

  #  Given I have selected an unmatched service
  #  When I select the option to match
  #  Then the list of available schedules to match with is displayed in 1 second
  Scenario Outline: 34002-1 - Opening matching screen response time - when matching
    Given I am viewing the map HDGW01paddington.v
    And the following live berth step message is sent from LINX (to create an unmatched service)
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And berth '<toBerth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1L24_PADTON_RDNGSTN.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>    |
    And I wait until today's train '<planningUid>' has loaded
    And I give the data 2 seconds to be processed by elastic
    And I refresh the Elastic Search indices
    And I right click on berth with id '<trainDescriber><toBerth>'
    When I start the stopwatch
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    And the unmatched search results show the following 2 results
      | trainNumber        | planUID        | status    | sched | date     | origin  | originTime | dest    |
      | <trainDescription> | <planningUid>  | UNCALLED  | VAR   | tomorrow | PADTON  | now        | RDNGSTN |
      | <trainDescription> | <planningUid>  | UNCALLED  | VAR   | today    | PADTON  | now        | RDNGSTN |
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
      | fromBerth | toBerth | trainDescriber | trainDescription | planningUid |
      | 0239      | 0243    | D4             | generated        | generated   |


  #  Given I have selected an matched service
  #  When I select the option to unmatch
  #  Then the list of available schedules to match with is displayed in 1 second
  Scenario Outline: 34002-2 - Opening matching screen response time - when unmatching
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1L24_PADTON_RDNGSTN.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>    |
    And I wait until today's train '<planningUid>' has loaded
    And I am viewing the map HDGW01paddington.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible
    And I give the data 2 seconds to be processed by elastic
    And I refresh the Elastic Search indices
    And I invoke the context menu on the map for train <trainDescription>
    And the Matched version of the Schedule-matching map context menu is displayed
    When I start the stopwatch
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    And the unmatched search results show the following 2 results
      | trainNumber        | planUID        | status    | sched | date     | origin  | originTime | dest    |
      | <trainDescription> | <planningUid>  | UNCALLED  | VAR   | tomorrow | PADTON  | now        | RDNGSTN |
      | <trainDescription> | <planningUid>  | UNCALLED  | VAR   | today    | PADTON  | now        | RDNGSTN |
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    Examples:
    | trainDescription | planningUid |
    | generated        | generated   |

