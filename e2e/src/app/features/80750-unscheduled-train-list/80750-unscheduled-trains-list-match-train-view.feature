@TMVPhase2 @P2.S4
Feature: 80750 - Unscheduled Trains List - Match Train View

  As a TMV User
  I want view a dynamic list of unscheduled trains
  So that I have a central place to determine if manual matching is required

  #  Given the user is authenticated to use TMV
  #  And the user has the schedule matching role
  #  And the user has opened an unscheduled trains list
  #  And the user has selected a train to match
  #  When the user selects a trains to match to schedule
  #  Then the user is presented with a manual matching tab
  #  And the view is populated with a list of possible services to match to
  #
  #  Comments:
  #  * The list may be blank
  #  * The list will contain entries with the same train description (schedule date)
  #    * includes cancelled services

  Background:
    * I generate a new train description
    * I generate a new trainUID

    @newSession
  Scenario Outline: 81295-1 - unscheduled trains list - populated list of possible services to match to
    Given I am on the unscheduled trains list
    And the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth | trainDescriber   | trainDescription   |
      | <berth> | <trainDescriber> | <trainDescription> |
    And the following unscheduled trains list entry can be seen
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                  | <trainDescriber>      |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1L24_PADTON_RDNGSTN.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And I give the train 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                  | <trainDescriber>      |
    When I click match on the unscheduled trains list context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    Then the unmatched search results show the following 2 results
      | trainNumber        | planUID       | status   | sched | date     | origin | originTime | dest    |
      | <trainDescription> | <planningUid> | UNCALLED | VAR   | tomorrow | PADTON | now        | RDNGSTN |
      | <trainDescription> | <planningUid> | UNCALLED | VAR   | today    | PADTON | now        | RDNGSTN |

    Examples:
      | berth | trainDescriber | trainDescription | planningUid |
      | 0239  | D4             | generated        | generated   |

  @newSession
  Scenario Outline: 81295-2 - unscheduled trains list - blank list of possible services to match to
    Given I am on the unscheduled trains list
    And the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth | trainDescriber   | trainDescription   |
      | <berth> | <trainDescriber> | <trainDescription> |
    And the following unscheduled trains list entry can be seen
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                  | <trainDescriber>      |
    And I give the train 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                  | <trainDescriber>      |
    When I click match on the unscheduled trains list context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    Then the unmatched search results shows no results

    Examples:
      | berth | trainDescriber | trainDescription |
      | 0239  | D4             | generated        |

  @newSession
  Scenario Outline: 81295-3 - unscheduled trains list - does not contain service with different train description
    Given I am on the unscheduled trains list
    And the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth | trainDescriber   | trainDescription   |
      | <berth> | <trainDescriber> | <trainDescription> |
    And the following unscheduled trains list entry can be seen
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                  | <trainDescriber>      |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription         | newPlanningUid |
      | access-plan/1L24_PADTON_RDNGSTN.cif | PADTON      | WTT_dep       | <differentTrainDescription> | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And I give the train 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                  | <trainDescriber>      |
    When I click match on the unscheduled trains list context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    Then the unmatched search results shows no results

    Examples:
      | berth | trainDescriber | trainDescription | planningUid | differentTrainDescription |
      | 0239  | D4             | generated        | generated   | 1X13                      |

  @newSession
  Scenario Outline: 81295-4 - unscheduled trains list - can match to a cancelled service
    Given I am on the unscheduled trains list
    And the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth | trainDescriber   | trainDescription   |
      | <berth> | <trainDescriber> | <trainDescription> |
    And the following unscheduled trains list entry can be seen
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                  | <trainDescriber>      |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1L24_PADTON_RDNGSTN.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 73000               | PADTON                 | today         | now                 |
    #tjmType-Cancel at Origin
    And the following TJM is received
      | trainUid      | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason   | nationalDelayCode   |
      | <planningUid> | <trainDescription> | now           | create | <type>    | <type>          | 73000       | PADTON         | now  | <modificationReason> | <nationalDelayCode> |
    And I give the train 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                  | <trainDescriber>      |
    When I click match on the unscheduled trains list context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    Then the unmatched search results show the following 2 results
      | trainNumber        | planUID       | status    | sched | date     | origin | originTime | dest    |
      | <trainDescription> | <planningUid> | UNCALLED  | VAR   | tomorrow | PADTON | now        | RDNGSTN |
      | <trainDescription> | <planningUid> | CANCELLED | VAR   | today    | PADTON | now        | RDNGSTN |

    Examples:
      | berth | trainDescriber | trainDescription | planningUid | type | modificationReason | nationalDelayCode |
      | 0239  | D4             | generated        | generated   | 91   | 91                 | PG                |
