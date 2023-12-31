Feature: 47637 - Process C Class Messages - Berth Translation

  As a TMV User
  I want the berth state messages to be processed
  So that I can record berth stepping for use by the system

  # Test Data taken from berth-translation stream in redis
  #I = Interpose
  #C = Clear Out
  #T = To step
  #F = From Step

  @tdd
  Scenario Outline: 33758 Berth Translation - Interpose With Matching Config
    # Has type I
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newBerth>' in train describer '<newTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | toTrainDescriber | toBerth | newTrainDescriber | newBerth |
      | 1E01             | D3               | 6071    | D3                | 6068     |
      | 1E02             | C1               | 1624    | C1                | 1029     |
      | 1E03             | D4               | 0310    | Q1                | 0310     |

  Scenario Outline: 33758 Berth Translation - Interpose With No Matching Config
    # Does not have type I
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newBerth>' in train describer '<newTrainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | toTrainDescriber | toBerth | newTrainDescriber | newBerth |
      | 1E04             | EX               | EJ08    | ZY                | EJ08     |

    @bug @bug:55362
  Scenario Outline: 33758 Berth Translation - Interpose to Null
    # Translation is ******
    Given I am on a map showing berth '<toBerth>' and in train describer '<toTrainDescriber>'
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<toBerth>' in train describer '<toTrainDescriber>' does not contain '<trainDescription>'

    Examples:
      | trainDescription | toTrainDescriber | toBerth |
      | 1E05             | D5               | 2494    |
      | 1E06             | RA               | 0626    |

  @tdd
  Scenario Outline: 33758 Berth Translation - Step With Matching Config - To
    # Has Type T
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    When the following berth step message is sent from LINX
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<fromBerth>' in train describer '<fromTrainDescriber>' does not contain '<trainDescription>'
    And berth '<newBerth>' in train describer '<newTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newTrainDescriber | newBerth |
      | 1E07             | D3                 | 6067      | D3               | 6071    | D3                | 6068     |
      | 1E08             | C1                 | 1628      | C1               | 1624    | C1                | 1029     |
      | 1E09             | ZY                 | EJ04      | EX               | EJ08    | ZY                | EJ08     |

  @tdd
  Scenario Outline: 33758 Berth Translation - Step With Matching Config - From
    # Has Type F
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
      | 1E10             | D3                 | 6071      | D3               | 6067    | D3                | 6068     |
      | 1E11             | C1                 | 1624      | C1               | 1628    | C1                | 1029     |
      | 1E12             | EX                 | EJ08      | ZY               | EJ04    | ZY                | EJ08     |

  @tdd
  # no map config for scenario
  Scenario Outline: 33758 Berth Translation - Step With No Matching Config
    # Does not have type T or F
    Given I am on a map showing berth '<newBerth>' and in train describer '<newTrainDescriber>'
    When the following berth step message is sent from LINX
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription   |
      | 09:59:00  | <fromBerth> | <toBerth> | <toTrainDescriber> | <trainDescription> |
    Then berth '<newBerth>' in train describer '<newTrainDescriber>' does not contain '<trainDescription>'
    And berth '<toBerth>' in train describer '<toTrainDescriber>' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription | fromTrainDescriber | fromBerth | toTrainDescriber | toBerth | newTrainDescriber | newBerth |
      | 1E13             | D4                 | 0466      | D4               | 0310    | Q1                | 0310     |

  @tdd
  Scenario Outline: 33758 Berth Translation - Cancel With Matching Config
    # Has type C
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
      | 1E14             | D3                 | 6067      | D3                | 6068     |
      | 1E15             | C1                 | 1628      | C1                | 1029     |
      | 1E16             | ZY                 | EJ04      | ZY                | EJ08     |

  @tdd
  # no map config for scenario
  Scenario Outline: 33758 Berth Translation - Cancel With No Matching Config
    # Does not have type C
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
      | 1E17             | D4                 | 0310      | Q1                | 0310     |
