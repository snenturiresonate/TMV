Feature: 37659 - Schedule Matching - Matched and Unmatched trains are removed from the map on receipt of a cancel message

  As a TMV user
  I want C-class data on running services to be matched to the planned train schedule from the CIF
  So that the system can build and update a train models to allow schematic maps to display trains and their timetables

  Background:
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And the access plan located in CIF file 'access-plan/37659-schedules/9F01.cif' is received from LINX


  Scenario Outline: 37659 -10   Clearing berth following unmatched cancel
    Given the following live berth interpose messages is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber   | trainDescription   |
      | <berth> | <trainDescriber> | <trainDescription> |
    And berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When the following live berth cancel messages are sent from LINX
      | fromBerth | trainDescriber   | trainDescription   |
      | <berth>   | <trainDescriber> | <trainDescription> |
    Then berth '<berth>' in train describer '<trainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | trainDescriber | berth | location | subdivision | matchLevel |
      | 9F01             | D3             | 0222  |          |             |            |

  Scenario Outline: 37659 -11 Clearing berth following matched cancel
    Given the following live berth interpose messages is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber   | trainDescription   |
      | <berth> | <trainDescriber> | <trainDescription> |
    And berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When the following live berth cancel messages are sent from LINX
      | fromBerth | trainDescriber   | trainDescription   |
      | <berth>   | <trainDescriber> | <trainDescription> |
    Then berth '<berth>' in train describer '<trainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | trainDescriber | berth | location | subdivision | matchLevel   |
      | 9F01             | D3             | A001  | PADTON   | 401         | berth        |
      | 9F01             | D3             | A011  | PADTON   | 401         | location     |
      | 9F01             | D3             | 0106  | PRTOBJP  | 401         | sub-division |

  Scenario Outline: 37659 -12 Clearing berth following consistent stepping cancel
    Given the following live berth interpose messages is sent from LINX (to indicate train is present)
      | toBerth         | trainDescriber   | trainDescription   |
      | <matchingBerth> | <trainDescriber> | <trainDescription> |
    And the following live berth step messages is sent from LINX (to indicate train is moving)
      | fromBerth       | toBerth            | trainDescriber   | trainDescription   |
      | <matchingBerth> | <nonMatchingBerth> | <trainDescriber> | <trainDescription> |
    And berth '<nonMatchingBerth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When the following live berth cancel messages are sent from LINX
      | fromBerth          | trainDescriber   | trainDescription   |
      | <nonMatchingBerth> | <trainDescriber> | <trainDescription> |
    Then berth '<nonMatchingBerth>' in train describer '<trainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | trainDescriber | matchingBerth | nonMatchingBerth |
      | 9F01             | D3             | R001          | 0222             |

  Scenario Outline: 37659 -13 Berth not cleared following cancel with a different train description
    Given the following live berth interpose messages is sent from LINX (to indicate train is present)
      | toBerth | trainDescriber   | trainDescription   |
      | <berth> | <trainDescriber> | <trainDescription> |
    And berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When the following live berth cancel messages are sent from LINX
      | fromBerth | trainDescriber   | trainDescription         |
      | <berth>   | <trainDescriber> | <cancelTrainDescription> |
    And berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | cancelTrainDescription | trainDescriber | berth |
      | 9F01             | 8F10                   | D3             | R001  |


