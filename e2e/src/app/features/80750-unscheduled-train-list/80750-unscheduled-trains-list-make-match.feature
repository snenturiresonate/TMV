@TMVPhase2 @P2.S4
Feature: 80750 - Unscheduled Trains List - Make match

  As a TMV User
  I want view a dynamic list of unscheduled trains
  So that I can make a manual match

#  Given the user is viewing the manual matching view
#  And the manual match has been triggered from the unscheduled trains list
#  And the user has the schedule matching role
#  And the user is presented with at least one new schedule to match
#  When the user selects an entry to match
#  Then the system will create a match
#
#  Comments:
#  The user will be asked to confirm the match
#  The service remains matched for the duration of its journey unless manually unmatched/rematched
#       * The above scenario is covered by this test
#       * https://resonatevsts.visualstudio.com/Luminate-TMV/_git/TMVEndToEndTestFramework?path=/e2e/src/app/features/34002-unscheduled-trains/34002-manual-matching-unscheduled-trains-list.feature
#  Test a lower weighted manually matched to a higher weighted match
#  If the schedule the user chooses is already matched to another stepping service it will remove that match
#       * pick a schedule that is already matched and a schedule that is unmatched

  Background:
    * I have cleared out all headcodes
    * I generate a new train description
    * I generate a new trainUID

  @newSession
  Scenario Outline: 81296-1 - unscheduled trains list - make match
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
    And I select to match the result for todays service with planning Id '<planningUid>'
    And the matched service uid is shown as '<planningUid>'

    Examples:
      | berth | trainDescriber | trainDescription | planningUid |
      | 0239  | D4             | generated        | generated   |

  #  The weight here is referring to the schedule matching ranking process.
  #  activated (higher) and one which isn't activated (lower)
  @newSession
  Scenario Outline: 81296-2 - unscheduled trains list - make a match to lower weighted service
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
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | STHALL      | WTT_pass      | <trainDescription>          | <planningUid1> |
    And I wait until today's train '<planningUid>' has loaded
    And I wait until today's train '<planningUid1>' has loaded
    And the following train activation message is sent from LINX
      | trainUID       | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid1> | <trainDescription>  | now                    | 99999               | PADTON                 | today         | now                 |
    And I give the Activation 2 seconds to load
    And I give the train 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                  | <trainDescriber>      |
    When I click match on the unscheduled trains list context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    Then the unmatched search results show the following 4 results
      | trainNumber        | planUID        | status    | sched | date     | origin | originTime | dest    |
      | <trainDescription> | <planningUid>  | UNCALLED  | VAR   | tomorrow | PADTON | now        | RDNGSTN |
      | <trainDescription> | <planningUid>  | UNCALLED  | VAR   | today    | PADTON | now        | RDNGSTN |
      | <trainDescription> | <planningUid1> | UNCALLED  | LTP   | tomorrow | PADTON | now - 7    | OXFD    |
      | <trainDescription> | <planningUid1> | ACTIVATED | LTP   | today    | PADTON | now - 7    | OXFD    |
    And I select to match the result for todays service with planning Id '<planningUid>'
    And the matched service uid is shown as '<planningUid>'
    And the train remains matched throughout the following berth steps
      | map                | fromBerth | toBerth | fromTrainDescriber | toTrainDescriber | trainDescription   |
      | HDGW01paddington.v | 0243      | 0469    | D4                 | D4               | <trainDescription> |
      | HDGW01paddington.v | 0469      | 0477    | D4                 | D4               | <trainDescription> |
      | HDGW01paddington.v | 0477      | 0483    | D4                 | D6               | <trainDescription> |

    Examples:
      | berth | trainDescriber | trainDescription | planningUid | planningUid1 |
      | 0239  | D4             | generated        | generated   | L12002       |

  @newSession
  Scenario Outline: 81296-3 - unscheduled trains list - make a match to matched service
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
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | STHALL      | WTT_pass      | <trainDescription>          | <planningUid1> |
    And I wait until today's train '<planningUid>' has loaded
    And I wait until today's train '<planningUid1>' has loaded
    And the following train activation message is sent from LINX
      | trainUID       | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid1> | <trainDescription>  | now                    | 99999               | PADTON                 | today         | now                 |
    And I give the Activation 2 seconds to load
    And I give the train 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And the following live berth interpose message is sent from LINX (to create a match)
      | toBerth | trainDescriber | trainDescription   |
      | 0519    | D6             | <trainDescription> |
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth              | entrySignal | entryLocation | currentBerth            | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><berth> | SN239       |               | <trainDescriber><berth> | SN239         |                  | <trainDescriber>      |
    When I click match on the unscheduled trains list context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    Then the unmatched search results show the following 4 results
      | trainNumber        | planUID        | status    | sched | date     | origin | originTime | dest    |
      | <trainDescription> | <planningUid>  | UNCALLED  | VAR   | tomorrow | PADTON | now        | RDNGSTN |
      | <trainDescription> | <planningUid>  | UNCALLED  | VAR   | today    | PADTON | now        | RDNGSTN |
      | <trainDescription> | <planningUid1> | UNCALLED  | LTP   | tomorrow | PADTON | now - 7    | OXFD    |
      | <trainDescription> | <planningUid1> | ACTIVATED | LTP   | today    | PADTON | now - 7    | OXFD    |
    And I select to match the result for todays service with planning Id '<planningUid1>'
    And the matched service uid is shown as '<planningUid1>'
    And the train remains matched throughout the following berth steps
      | map                | fromBerth | toBerth | fromTrainDescriber | toTrainDescriber | trainDescription   |
      | HDGW01paddington.v | 0243      | 0469    | D4                 | D4               | <trainDescription> |
      | HDGW01paddington.v | 0469      | 0477    | D4                 | D4               | <trainDescription> |
      | HDGW01paddington.v | 0477      | 0483    | D4                 | D6               | <trainDescription> |

    Examples:
      | berth | trainDescriber | trainDescription | planningUid | planningUid1 |
      | 0239  | D4             | generated        | generated   | L12002       |
