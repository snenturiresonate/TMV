Feature: 33998 - TMV Train Service - Calculate Punctuality at Each Berth

  As a TMV User
  I want to view information about a train on schematic map
  So that I can track and confirm the train is operating as planned

  #  Given the user is authenticated to use TMV
  #  And the user is viewing the schematic map
  #  And there are service matched to schedules
  #  When the services step from one berth to another
  #  Then the current punctuality is re-calculated

  Background:
    * I am on the home page
    * The admin setting defaults are as originally shipped
    * I have cleared out all headcodes
    * I generate a new trainUID
    * I generate a new train description

  Scenario Outline: 83312-1 - Calculate Punctuality at Each Berth - Early - <fromPunctualityColour> -> <toPunctualityColour>
    * the train in CIF file below is updated accordingly so time at the reference point is now + '1' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUID>  |
    * I wait until today's train '<planningUID>' has loaded
    * I give the cif a further 2 seconds to fully process
    * I log the berth & locations from the berth level schedule for '<planningUID>'
    Given I am viewing the map <fromMap>
    When the following live berth interpose messages are sent from LINX (to match the first part of the step)
      | toBerth     | trainDescriber       | trainDescription   |
      | <fromBerth> | <fromTrainDescriber> | <trainDescription> |
    Then the train headcode color for berth '<fromTrainDescriber><fromBerth>' is <fromPunctualityColour>
    When the following live berth cancel message is sent from LINX
      | fromBerth   | trainDescriber   | trainDescription       |
      | <fromBerth> | <fromTrainDescriber> | <trainDescription> |
    And berth '<fromBerth>' in train describer '<fromTrainDescriber>' does not contain '<trainDescription>'
    And I am viewing the map <toMap>
    And the following live berth interpose messages are sent from LINX (to match the second part of the step)
      | toBerth   | trainDescriber     | trainDescription   |
      | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then the train headcode color for berth '<toTrainDescriber><toBerth>' is <toPunctualityColour>

    Examples:
      | fromMap            | toMap              | trainDescription | planningUID | fromTrainDescriber | toTrainDescriber  | fromBerth      | toBerth       | fromPunctualityColour | toPunctualityColour |
      | HDGW01paddington.v | HDGW01paddington.v | generated        | generated   | D3                 | D3                | A007           | 0037          | green                 | lightgreen          |
      | HDGW01paddington.v | HDGW01paddington.v | generated        | generated   | D3                 | D4                | 0037           | 0255          | lightgreen            | lightblue           |
      | HDGW01paddington.v | HDGW02reading.v    | generated        | generated   | D4                 | D6                | 0255           | 0489          | lightblue             | lilac               |
      | HDGW02reading.v    | HDGW02reading.v    | generated        | generated   | D6                 | D1                | 0489           | 1686          | lilac                 | salmon              |

  Scenario Outline: 83312-2 - Calculate Punctuality at Each Berth - Late - <fromPunctualityColour> -> <toPunctualityColour>
    * the train in CIF file below is updated accordingly so time at the reference point is now + '6' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | OXFD        | WTT_arr       | <trainDescription>  | <planningUID>  |
    * I wait until today's train '<planningUID>' has loaded
    * I give the cif a further 2 seconds to fully process
    * I log the berth & locations from the berth level schedule for '<planningUID>'
    Given I am viewing the map <fromMap>
    When the following live berth interpose messages are sent from LINX (to match the first part of the step)
      | toBerth     | trainDescriber       | trainDescription   |
      | <fromBerth> | <fromTrainDescriber> | <trainDescription> |
    Then the train headcode color for berth '<fromTrainDescriber><fromBerth>' is <fromPunctualityColour>
    When the following live berth cancel message is sent from LINX
      | fromBerth   | trainDescriber   | trainDescription       |
      | <fromBerth> | <fromTrainDescriber> | <trainDescription> |
    And berth '<fromBerth>' in train describer '<fromTrainDescriber>' does not contain '<trainDescription>'
    And I am viewing the map <toMap>
    And the following live berth interpose messages are sent from LINX (to match the second part of the step)
      | toBerth   | trainDescriber     | trainDescription   |
      | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then the train headcode color for berth '<toTrainDescriber><toBerth>' is <toPunctualityColour>

    Examples:
      | fromMap            | toMap              | trainDescription | planningUID | fromTrainDescriber | toTrainDescriber  | fromBerth      | toBerth       | fromPunctualityColour | toPunctualityColour |
      | HDGW01paddington.v | HDGW03oxford.v     | generated        | generated   | D3                 | D5                | A007           | 0921          | pink                  | red                 |
      | HDGW03oxford.v     | HDGW03oxford.v     | generated        | generated   | D5                 | D5                | 0921           | 2323          | red                   | orange              |
      | HDGW03oxford.v     | HDGW03oxford.v     | generated        | generated   | D5                 | D5                | 2323           | 2368          | orange                | lightblue           |
