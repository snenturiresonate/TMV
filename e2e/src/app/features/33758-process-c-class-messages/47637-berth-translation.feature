Feature: 47637 - Process C Class Messages - Berth Translation scenarios

  As a TMV User
  I want the berth state messages to be processed
  So that I can record berth stepping for use by the system

  # Test Data taken from berth-translation stream in redis
  #I = Interpose
  #C = Clear Out
  #T = To step
  #F = From Step

  @bug
  #49500 only first example is correctly translated
  Scenario Outline: 33758 Berth Translation - Interpose With Matching Config
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newBerth>' in train describer '<newTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | toTrainDescriber | toBerth | newTrainDescriber | newBerth |
      | 1E22             | D3               | 6071    | D3                | 6068     |
      | 1E22             | C1               | 1624    | C1                | 1029     |
      | 1E22             | D4               | 0310    | Q1                | 0310     |


  Scenario Outline: 33758 Berth Translation - Interpose With No Matching Config
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newBerth>' in train describer '<newTrainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | toTrainDescriber | toBerth | newTrainDescriber | newBerth |
      | 1E22             | EX               | EJ08    | ZY                | EJ08     |


  Scenario Outline: 33758 Berth Translation - Interpose to Wildcard
    Given I am on a map showing berth '<toBerth>' and in train describer '<toTrainDescriber>'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<toBerth>' in train describer '<toTrainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | toTrainDescriber | toBerth |
      | 1E22             | D5               | 2494    |
      | 1E22             | RA               | 0626    |

  @bug
  #49502 berth translations are not applied
  Scenario Outline: 33758 Berth Translation - Step With Matching Config - To
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    When the following berth step message is sent from LINX
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<fromBerth>' in train describer '<fromTrainDescriber>' does not contain '<trainDescription>'
    And berth '<newBerth>' in train describer '<newTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newTrainDescriber | newBerth |
      | 1E22             | D3                 | 6067      | D3               | 6071    | D3                | 6068     |
      | 1E22             | C1                 | 1628      | C1               | 1624    | C1                | 1029     |
      | 1E22             | ZY                 | EJ04      | EX               | EJ08    | ZY                | EJ08     |

  @bug
  #49529 Step and Interpose messages with no translation config not showing on screen
  Scenario Outline: 33758 Berth Translation - Step With Matching Config - From
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth    | trainDescriber      | trainDescription   |
      | 09:59:00  | <newBerth> | <newTrainDescriber> | <trainDescription> |
    And berth '<newBerth>' in train describer '<newTrainDescriber>' contains '<trainDescription>' and is visible
    When the following berth step message is sent from LINX
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newBerth>' in train describer '<newTrainDescriber>' does not contain '<trainDescription>'
    And berth '<toBerth>' in train describer '<toTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newTrainDescriber | newBerth |
      | 1E22             | D3                 | 6071      | D3               | 6067    | D3                | 6068     |
      | 1E22             | C1                 | 1624      | C1               | 1628    | C1                | 1029     |
      | 1E22             | EX                 | EJ08      | ZY               | EJ04    | ZY                | EJ08     |

  @bug
  #49529 Step and Interpose messages with no translation config not showing on screen
  Scenario Outline: 33758 Berth Translation - Step With No Matching Config
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    When the following berth step message is sent from LINX
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newBerth>' in train describer '<newTrainDescriber>' does not contain '<trainDescription>'
    And berth '<toBerth>' in train describer '<toTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newTrainDescriber | newBerth |
      | 1E22             | D4                 | 0466      | D4               | 0310    | Q1                | 0310     |

  @bug
  #49529 Step and Interpose messages with no translation config not showing on screen
  Scenario Outline: 33758 Berth Translation - Cancel With Matching Config
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth    | trainDescriber      | trainDescription   |
      | 09:59:00  | <newBerth> | <newTrainDescriber> | <trainDescription> |
    And berth '<newBerth>' in train describer '<newTrainDescriber>' contains '<trainDescription>' and is visible
    When the following berth cancel message is sent from LINX
      | timestamp | fromBerth   | trainDescriber       | trainDescription   |
      | 09:59:00  | <fromBerth> | <fromTrainDescriber> | <trainDescription> |
    Then berth '<newBerth>' in train describer '<newTrainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | newTrainDescriber | newBerth |
      | 1E22             | D3                 | 6067      | D3                | 6068     |
      | 1E22             | C1                 | 1628      | C1                | 1029     |
      | 1E22             | ZY                 | EJ04      | ZY                | EJ08     |

  @bug
  #49529 Step and Interpose messages with no translation config not showing on screen
  Scenario Outline: 33758 Berth Translation - Cancel With No Matching Config
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth    | trainDescriber      | trainDescription   |
      | 09:59:00  | <newBerth> | <newTrainDescriber> | <trainDescription> |
    And berth '<newBerth>' in train describer '<newTrainDescriber>' contains '<trainDescription>' and is visible
    When the following berth cancel message is sent from LINX
      | timestamp | fromBerth   | trainDescriber       | trainDescription   |
      | 09:59:00  | <fromBerth> | <fromTrainDescriber> | <trainDescription> |
    Then berth '<fromBerth>' in train describer '<fromTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | newTrainDescriber | newBerth |
      | 1E22             | D4                 | 0310      | Q1                | 0310     |

