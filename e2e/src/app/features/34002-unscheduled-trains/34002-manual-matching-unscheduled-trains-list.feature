@TMVPhase2 @P2.S3
@bug @bug:87447
Feature: 34002 - TMV Unscheduled Trains - Manual Matching - Unscheduled Trains List

  As a TMV User
  I want to view unscheduled trains
  So that I can determine if the unscheduled requires schedule matching

  #  Given the user is authenticated to use TMV
  #  And the user is viewing the unscheduled trains list
  #  And the user has the schedule matching privilege
  #  And has select a unmatched service to match
  #  And is viewing match confirmation dialogue
  #  When the user selects affirmative action
  #  Then the service is matched
  #  And remains matched for the remainder of its journey unless rematched/unmatched by a user
  #
  #  Comments:
  #  * Re-use existing berth stepping

  Background:
    * I generate a new trainUID
    * I generate a new train description

  Scenario Outline: 84045-1 Manual Matching - Unscheduled Trains List - Remains Matched Throughout Journey
    Given I am on the unscheduled trains list
    And the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth     | trainDescriber   | trainDescription   |
      | <fromBerth> | <trainDescriber> | <trainDescription> |
    * I take a screenshot
    And I give the train 2 seconds to dwell
    And the following live berth step message is sent from LINX (to move the train)
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    * I take a screenshot
    And the following unscheduled trains list entry can be seen
      | trainId            | entryTime | entryBerth                  | entrySignal | entryLocation    | currentBerth              | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><fromBerth> | SN239       |                  | <trainDescriber><toBerth> | SN243         | Southall East Jn | <trainDescriber>      |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1L24_PADTON_RDNGSTN.cif | STHALL      | WTT_arr       | <trainDescription>  | <trainUid>    |
    And I wait until today's train '<trainUid>' has loaded
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And I give the train 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth                  | entrySignal | entryLocation    | currentBerth              | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><fromBerth> | SN239       |                  | <trainDescriber><toBerth> | SN243         | Southall East Jn | <trainDescriber>      |
    And I click match on the unscheduled trains list context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    And I select to match the result for todays service with planning Id '<trainUid>'
    And the matched service uid is shown as '<trainUid>'
    And I am viewing the map HDGW01paddington.v
    When the following live berth step message is sent from LINX (to create a consistent step)
      | fromBerth   | toBerth    | trainDescriber   | trainDescription   |
      | <toBerth>   | <toBerth2> | <trainDescriber> | <trainDescription> |
    Then the train headcode color for berth '<trainDescriber><toBerth2>' is <toPunctualityColour>
    And the train remains matched throughout the following berth steps
      | map                | fromBerth | toBerth | fromTrainDescriber | toTrainDescriber | trainDescription   |
      | HDGW01paddington.v | 0243      | 0469    | D4                 | D4               | <trainDescription> |
      | HDGW01paddington.v | 0469      | 0477    | D4                 | D4               | <trainDescription> |
      | HDGW01paddington.v | 0477      | 0483    | D4                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0483      | 0491    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0491      | 0529    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0529      | 0535    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0535      | 0547    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0547      | 0551    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0551      | 0559    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0559      | 0577    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0577      | 1637    | D6                 | D1               | <trainDescription> |
      | HDGW02reading.v    | 1637      | 1677    | D1                 | D1               | <trainDescription> |
      | HDGW02reading.v    | 1677      | 1687    | D1                 | D1               | <trainDescription> |
      | HDGW02reading.v    | 1687      | 1697    | D1                 | D1               | <trainDescription> |
      | HDGW02reading.v    | 1697      | 1696    | D1                 | D1               | <trainDescription> |

    Examples:
      | fromBerth | toBerth | toBerth2 | trainDescriber | trainDescription | trainUid  | toPunctualityColour |
      | 0239      | 0243    | 0253     | D4             | generated        | generated | green               |

  Scenario Outline: 84045-2 Manual Matching - Unscheduled Trains List - Remains Matched Until Unmatched and Remains Unmatched
    Given I am on the unscheduled trains list
    And the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth     | trainDescriber   | trainDescription   |
      | <fromBerth> | <trainDescriber> | <trainDescription> |
    * I take a screenshot
    And I give the train 2 seconds to dwell
    And the following live berth step message is sent from LINX (to create an unmatched service)
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    * I take a screenshot
    And the following unscheduled trains list entry can be seen
      | trainId            | entryTime | entryBerth                  | entrySignal | entryLocation    | currentBerth              | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><fromBerth> | SN239       |                  | <trainDescriber><toBerth> | SN243         | Southall East Jn | <trainDescriber>      |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1L24_PADTON_RDNGSTN.cif | STHALL      | WTT_arr       | <trainDescription>  | <trainUid>    |
    And I wait until today's train '<trainUid>' has loaded
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And I give the train 2 seconds to reach Elastic
    And I refresh the Elastic Search indices
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth                  | entrySignal | entryLocation    | currentBerth              | currentSignal | currentLocation  | currentTrainDescriber |
      | <trainDescription> | now       | <trainDescriber><fromBerth> | SN239       |                  | <trainDescriber><toBerth> | SN243         | Southall East Jn | <trainDescriber>      |
    And I click match on the unscheduled trains list context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    And I select to match the result for todays service with planning Id '<trainUid>'
    And the matched service uid is shown as '<trainUid>'
    And I am viewing the map HDGW01paddington.v
    When the following live berth step message is sent from LINX (to create a consistent step)
      | fromBerth   | toBerth    | trainDescriber   | trainDescription   |
      | <toBerth>   | <toBerth2> | <trainDescriber> | <trainDescription> |
    Then the train headcode color for berth '<trainDescriber><toBerth2>' is <toPunctualityColour>
    And the train remains matched throughout the following berth steps
      | map                | fromBerth | toBerth | fromTrainDescriber | toTrainDescriber | trainDescription   |
      | HDGW01paddington.v | 0243      | 0469    | D4                 | D4               | <trainDescription> |
      | HDGW01paddington.v | 0469      | 0477    | D4                 | D4               | <trainDescription> |
      | HDGW01paddington.v | 0477      | 0483    | D4                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0483      | 0491    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0491      | 0529    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0529      | 0535    | D6                 | D6               | <trainDescription> |
    And I invoke the context menu on the map for train <trainDescription>
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And I un-match the currently matched schedule
    And I switch to the second-newest tab
    And the train remains unmatched throughout the following berth steps
      | map                | fromBerth | toBerth | fromTrainDescriber | toTrainDescriber | trainDescription   |
      | HDGW02reading.v    | 0535      | 0547    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0547      | 0551    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0551      | 0559    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0559      | 0577    | D6                 | D6               | <trainDescription> |
      | HDGW02reading.v    | 0577      | 1637    | D6                 | D1               | <trainDescription> |
      | HDGW02reading.v    | 1637      | 1677    | D1                 | D1               | <trainDescription> |
      | HDGW02reading.v    | 1677      | 1687    | D1                 | D1               | <trainDescription> |
      | HDGW02reading.v    | 1687      | 1697    | D1                 | D1               | <trainDescription> |
      | HDGW02reading.v    | 1697      | 1696    | D1                 | D1               | <trainDescription> |
    When I am on the unscheduled trains list
    * I take a screenshot
    Then the following unscheduled trains list entry can be seen
      | trainId            | entryTime | entryBerth | entrySignal | entryLocation    | currentBerth | currentSignal | currentLocation | currentTrainDescriber |
      | <trainDescription> | now       | D40239     | SN239       |                  | D11696       | T1696,T1696X  | Reading         | <trainDescriber>      |


    Examples:
      | fromBerth | toBerth | toBerth2 | trainDescriber | trainDescription | trainUid  | toPunctualityColour |
      | 0239      | 0243    | 0253     | D4             | generated        | generated | green               |
