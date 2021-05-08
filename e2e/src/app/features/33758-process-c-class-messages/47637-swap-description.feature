Feature: 47637 - Process C Class Messages - Swap Description scenarios

  As a TMV User
  I want the berth state messages to be processed
  So that I can record berth stepping for use by the system

  #  Scenario 33758-2 Swap Description
  #    Given a Berth has configuration data for an Swap Description
  #    When an interpose message is received for that berth
  #    Then the Train Description from the interpose message is displayed in the berth with the first two characters swapped
  Scenario Outline: 33758-2 Swap Description
    #Train descriptions, the first 2 characters are swapped when in certain berths. tracks shared with underground mainly
    #Data taken from oddswap.dat
    Given I am viewing the map <map>
    And I have cleared out all headcodes
    When the following berth interpose message is sent from LINX (to indicate train is present)
      | timestamp | toBerth   | trainDescriber   | trainDescription           |
      | 09:59:00  | <toBerth> | <trainDescriber> | <originalTrainDescription> |
    Then berth '<toBerth>' in train describer '<trainDescriber>' contains '<swappedTrainDescription>' and is visible

    Examples:
      | map          | toBerth | trainDescriber | originalTrainDescription | swappedTrainDescription |
      | md01euston.v | 0015    | WS             | G170                     | 1G70                    |
