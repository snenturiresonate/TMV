Feature: 47637 - Process C Class Messages - Step Translation

  As a TMV User
  I want the berth state messages to be processed
  So that I can record berth stepping for use by the system

  @tdd
  Scenario Outline: 33758-9 Step Translation - Config with no null values
    Given I am on a map showing berth '<newToBerth>' and in train describer '<newToTrainDescriber>'
    When the following berth step message is sent from LINX
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newToBerth>' in train describer '<newToTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E01             | D5                 | 0904      | D5               | R834    | D5                    | 0904         | D1                  | 0834       |

  @tdd
  # no map config for scenario
  Scenario Outline: 33758-9 Step Translation - old To Berth is null - New values are populated
    #clear out message received with from berth -> step translation
    Given I am on a map showing berth '<newToBerth>' and in train describer '<newToTrainDescriber>'
    When the following berth cancel message is sent from LINX
      | timestamp | fromBerth   |  trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> |  <fromTrainDescriber> | <trainDescription> |
    Then berth '<newFromBerth>' in train describer '<newFromTrainDescriber>' does not contain '<trainDescription>'
    And berth '<newToBerth>' in train describer '<newToTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E02             | D3                 | C311      | **               | ****    | D3                    | C311         | D3                  | XDLS       |

  @tdd
  # no map config for scenario
  Scenario Outline: 33758-9 Step Translation - old From Berth is null - New values are populated
    #interpose message received with from berth -> step translation
    Given I am on a map showing berth '<newToBerth>' and in train describer '<newToTrainDescriber>'
    When the following berth interpose message are sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newFromBerth>' in train describer '<newFromTrainDescriber>' does not contain '<trainDescription>'
    And berth '<newToBerth>' in train describer '<newToTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E03             | **                 | ****      | D7               | 1294    | D0                    | 1868         | D7                  | 1294       |

  @tdd
  #no data in test environment - data taken from national/oddstep.dat
  Scenario Outline: 33758-10 Step Translation - new From Berth is null - new To Berth is populated - treat as Interpose
    Given I am on a map showing berth '<newToBerth>' and in train describer '<newToTrainDescriber>'
    When the following berth step message is sent from LINX
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newToBerth>' in train describer '<newToTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E04             | WS                 | STIN      | WS               | ULLS    | **                    | ****         | WS                  | H102       |

  @tdd
  #no data in test environment - data taken from national/oddstep.dat
  Scenario Outline: 33758-10 Step Translation - new From Berth is populated - new To Berth is null - treat as Cancel
    Given I am on a map showing berth '<newFromBerth>' and in train describer '<newFromTrainDescriber>'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth        | trainDescriber          | trainDescription   |
      | 09:59:00  | <newFromBerth> | <newFromTrainDescriber> | <trainDescription> |
    And berth '<fromBerth>' in train describer '<fromTrainDescriber>' contains '<trainDescription>' and is visible
    When the following berth step message is sent from LINX
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newFromBerth>' in train describer '<newFromTrainDescriber>' does not contain '<trainDescription>'
    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E05             | NJ                 | DH02      | NJ               | WHLB    | NJ                    | DH02         | **                  | ****       |

  @tdd
  # no map config for scenario
  Scenario Outline: 33758-10 Step Translation - New To and New From are null - Ignore message
    Given I am on a map showing berth '<toBerth>' and in train describer '<toTrainDescriber>'
    When the following berth step message is sent from LINX
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<toBerth>' in train describer '<toTrainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E06             | BG                 | 3672      | BG               | COUT    | **                    | ****         | **                  | ****       |

  @tdd
  #no data in test environment - data taken from national/oddstep.dat
  Scenario Outline: 33758-12 (Applying Berth and Step translation in precedence)

    Given I am on a map showing berth '<newToBerth>' and in train describer '<newToTrainDescriber>'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth     | trainDescriber       | trainDescription   |
      | 09:59:00  | <fromBerth> | <fromTrainDescriber> | <trainDescription> |
    And berth '<fromBerth>' in train describer '<fromTrainDescriber>' contains '<trainDescription>' and is visible
    When the following berth step message is sent from LINX
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newToBerth>' in train describer '<newToTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newFromTrainDescriber | newFromBerth | newToTrainDescriber | newToBerth |
      | 2E07             | X0                 | 5508      | X0               | 3009    | X0                    | 1018         | X0                  | TCLS       |
      | 2E08             | D3                 | 6149      | D3               | A146    | D3                    | 0180         | AW                  | 0146       |
