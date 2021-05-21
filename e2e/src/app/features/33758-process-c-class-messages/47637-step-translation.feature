Feature: 47637 - Process C Class Messages - Step Translation

  As a TMV User
  I want the berth state messages to be processed
  So that I can record berth stepping for use by the system

  #  Given a from Berth and to Berth has configuration data for a Step Translation
  #    And neither of the new berths are null in the configuration data
  #    When a step message is received for those from and to berths
  #    Then the Train Description in the step message is removed from the new From Berth
  #    And the Train Description in the step message is displayed in the new To Berth
  Scenario Outline: 33758-9 Step Translation - Config with no null values
    Given I am on a map showing berth '<newToBerth>' and in train describer '<newToTrainDescriber>'
    And I have cleared out all headcodes
    When the following berth step message is sent from LINX (to move train)
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newToBerth>' in train describer '<newToTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E01             | D3                 | 0180      | D3               | A146    | D3                    | 0180         | AW                  | 0146       |

  @bug @bug:61444
  Scenario Outline: 33758-9 Step Translation - old To Berth is null - New values are populated
    #clear out message received with from berth -> step translation
    Given I am on a map showing berth '<newToBerth>' and in train describer '<newToTrainDescriber>'
    And I have cleared out all headcodes
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth     | trainDescriber       | trainDescription   |
      | 09:59:00  | <fromBerth> | <fromTrainDescriber> | <trainDescription> |
    When the following berth cancel message is sent from LINX
      | timestamp | fromBerth   | trainDescriber       | trainDescription   |
      | 09:59:00  | <fromBerth> | <fromTrainDescriber> | <trainDescription> |
    And the maximum amount of time is allowed for end to end transmission
    Then berth '<newFromBerth>' in train describer '<newFromTrainDescriber>' does not contain '<trainDescription>'
    And berth '<newToBerth>' in train describer '<newToTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E02             | D3                 | 0177      | **               | ****    | D3                    | 0177         | D3                  | LSAY       |

  Scenario Outline: 33758-9 Step Translation - old From Berth is null - New values are populated
    #interpose message received with from berth -> step translation
    Given I am on a map showing berth '<newToBerth>' and in train describer '<newToTrainDescriber>'
    And I have cleared out all headcodes
    When the following berth interpose message is sent from LINX (to indicate train is present)
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <toBerth> | <toTrainDescriber> | <trainDescription> |
    And berth '<newToBerth>' in train describer '<newToTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E03             | **                 | ****      | AW               | 0149    | WY                    | 0623         | AW                  | 0149       |

  Scenario Outline: 33758-10 Step Translation - new From Berth is null - new To Berth is populated - treat as Interpose
    Given I am on a map showing berth '<newToBerth>' and in train describer '<newToTrainDescriber>'
    And I have cleared out all headcodes
    When the following berth step message is sent from LINX (to move train)
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newToBerth>' in train describer '<newToTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E04             | WY                 | STIN      | WY               | 0811    | **                    | ****         | WY                  | 0811       |

  #    Given from Berth and to Berth has configuration data for a Step Translation
  #    And the new To Berth is null in the configuration data
  #    And the new From Berth populated in the configuration data
  #    When a step message is received for those from and to berths
  #    Then the Train Description in the step message is removed from the new From Berth
  #    And the Train Description in the step message is not displayed in the new To Berth
  Scenario Outline: 33758-10 Step Translation - new From Berth is populated - new To Berth is null - treat as Cancel
    Given I am on a map showing berth '<newFromBerth>' and in train describer '<newFromTrainDescriber>'
    And I have cleared out all headcodes
    When the following berth interpose message is sent from LINX (to indicate train is present)
      | timestamp | toBerth        | trainDescriber          | trainDescription   |
      | 09:59:00  | <newFromBerth> | <newFromTrainDescriber> | <trainDescription> |
    And berth '<fromBerth>' in train describer '<fromTrainDescriber>' contains '<trainDescription>' and is visible
    When the following berth step message is sent from LINX (to move train)
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newFromBerth>' in train describer '<newFromTrainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E05             | WY                 | 1185      | WY               | COUT    | WY                    | 1185         | **                  | ****       |

  Scenario Outline: 33758-10 Step Translation - New To and New From are null - Ignore message
    Given I am on a map showing berth '<toBerth>' and in train describer '<toTrainDescriber>'
    And I have cleared out all headcodes
    When the following berth step message is sent from LINX (to move train)
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<toBerth>' in train describer '<toTrainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E06             | CE                 | B175      | CE               | A175    | **                    | ****         | **                  | ****       |

  # To find test data, use the following step:
  # Given I find berths that have configuration data for Berth translation and Step Translation
  #
  #    Given a step (matching old To and From Berths) has configuration data for a Berth translation and Step Translation
  #    And the configuration has the type of step (Berth Translation)
  #    When a step message is received for those old From and To Berths
  #    Then the Train Description in the step message is removed from the new From Berth from the step translation
  #    And the Train Description in the step message is displayed in the new To Berth from the step translation
  Scenario Outline: 33758-12 (Applying Berth and Step translation in precedence)
    #* I find berths that have configuration data for Berth translation and Step Translation
    Given I am on a map showing berth '<newToBerth>' and in train describer '<newToTrainDescriber>'
    When the following berth step message is sent from LINX (to move train)
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newToBerth>' in train describer '<newToTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E07             | FH                 | R780      | FH               | W520    | D1                    | 2780         | FH                  | W520       |
      | 2E08             | NL                 | 2057      | NL               | 2069    | SX                    | 2057         | NL                  | 2069       |
      | 2E09             | SX                 | 2066      | SX               | 2060    | NL                    | 2069         | SX                  | 2060       |
