Feature: 93464 - Unscheduled Trains List - Manually Matched Service

  Background:
    * I have cleared out all headcodes
    * I generate a new train description
    * I generate a new trainUID

  @newSession
  Scenario Outline: 97411 - remove manually matched service
    Given I am on the unscheduled trains list
    And the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth | trainDescriber   | trainDescription   |
      | <berth> | <trainDescriber> | <trainDescription> |
    And the following unscheduled trains list entry can be seen
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                 | <trainDescriber>      |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1L24_PADTON_RDNGSTN.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And I give the train 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                 | <trainDescriber>      |
    When I click match on the unscheduled trains list context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    Then the unmatched search results show the following 2 results
      | trainNumber        | planUID       | status   | sched | date     | origin | originTime | dest    |
      | <trainDescription> | <planningUid> | UNCALLED | VAR   | tomorrow | PADTON | now        | RDNGSTN |
      | <trainDescription> | <planningUid> | UNCALLED | VAR   | today    | PADTON | now        | RDNGSTN |
    And I select to match the result for todays service with planning Id '<planningUid>'
    And the matched service uid is shown as '<planningUid>'
    And the following unscheduled trains list entry cannot be seen
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                 | <trainDescriber>      |


    Examples:
      | berth | trainDescriber | trainDescription | planningUid |
      | 0239  | D4             | generated        | generated   |
