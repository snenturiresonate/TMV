@TMVPhase2 @P2.S2
Feature: 79143 - TMV Movement Log Viewer - View Additional Data (Previous Train ID)

  As a TMV User
  I want to view, filter and search the Movement Logs
  So that I can work with the data that is of interest to me within the Movement Logs

  #  Applicable to trains describer berths only
  #  Two conditions for either Previous Train ID available or not available.

  Scenario Outline: 80275-1 - Movement Log - View Additional Data (Previous Train ID available)
#    Given the user is authenticated to use TMV
#    And the user is viewing the Movement Logs
#    When the search results are loaded:
#    And a Previous Train ID is available
#    Then the Previous Train ID column displays The Train ID of the Train previously occupying the To Berth
    Given I am on the log viewer page
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth1> | <trainDescriber> | <trainDescription1> |
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth1> | <trainDescriber> | <trainDescription2> |
    And I navigate to the Berth log tab
    When I search for Berth logs for toBerthId '<berth1>'
    Then the first movement log berth results are
      | trainId             | fromBerth | toBerth | previousTrainId     |
      | <trainDescription2> |           | D3C007  | <trainDescription1> |

    Examples:
      | berth1 | trainDescriber | trainDescription1 | trainDescription2 |
      | C007   | D3             | 2D19              | 4H19              |

  Scenario Outline: 80275-2 - Movement Log - View Additional Data (Previous Train ID not available)
#    Given the user is authenticated to use TMV
#    And the user is viewing the Movement Logs
#    When the search results are loaded:
#    And a Previous Train ID is not available
#    Then the Previous Train ID column displays an empty cell
    Given I am on the log viewer page
    And the following live berth interpose message is sent from LINX (to ensure following cancel will clear the berth)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth1> | <trainDescriber> | <trainDescription1> |
    And the following live berth cancel messages are sent from LINX
      | fromBerth  | trainDescriber   | trainDescription     |
      | <berth1>   | <trainDescriber> | <trainDescription1> |
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth1> | <trainDescriber> | <trainDescription1> |
    And I navigate to the Berth log tab
    When I search for Berth logs for toBerthId '<berth1>'
    Then the first movement log berth results are
      | trainId             | fromBerth | toBerth | previousTrainId |
      | <trainDescription1> |           | D3C007  |                 |

    Examples:
      | berth1 | trainDescriber | trainDescription1 |
      | C007   | D3             | 2D19              |

