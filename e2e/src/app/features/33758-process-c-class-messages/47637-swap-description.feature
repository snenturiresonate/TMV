Feature: 47637 - Process C Class Messages - Swap Description scenarios

  As a TMV User
  I want the berth state messages to be processed
  So that I can record berth stepping for use by the system

  @tdd
  Scenario Outline: 33758-2 Swap Description
    #Train descriptions, the first 2 characters are swapped when in certain berths. tracks shared with underground mainly
    #Data taken from oddswap.dat
    Given I am viewing the map <map>
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber   | trainDescription   |
      | 09:59:00  | <toBerth> | <trainDescriber> | <trainDescription> |
    Then berth '<toBerth>' in train describer '<trainDescriber>' contains the train description '<trainDescription>' but the first 2 characters have been swapped

    Examples:
      | map          | toBerth | trainDescriber | trainDescription |
      | md01euston.v | 0015    | WS             | 1G70             |
