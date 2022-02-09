@TMVPhase2 @P2.S2
Feature: 79143 - TMV Movement Log Viewer - View Additional Data (Previous Train ID)

  As a TMV User
  I want to view, filter and search the Movement Logs
  So that I can work with the data that is of interest to me within the Movement Logs

  #  Applicable to trains describer berths only
  #  Two conditions for either Previous Train ID available or not available.

  Background:
    Given I clear the logged-berth-states Elastic Search index
    And I clear the logged-signal-states Elastic Search index
    And I clear the logged-latch-states Elastic Search index
    And I clear the logged-s-class Elastic Search index
    And I clear the logged-agreed-schedules Elastic Search index

  Scenario Outline: 80275 - Movement Log - View Additional Data (Previous Train ID)
    # Given the user is authenticated to use TMV
    # And the user is viewing the Movement Logs
    # When the search results are loaded:
    # And a Previous Train ID is available
    # Then the Previous Train ID column displays The Train ID of the Train previously occupying the To Berth
    Given I am on the log viewer page
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth1> | <trainDescriber> | <trainDescription1> |
    And the following live berth cancel messages are sent from LINX
      | fromBerth  | trainDescriber   | trainDescription    |
      | <berth1>   | <trainDescriber> | <trainDescription1> |
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth1> | <trainDescriber> | <trainDescription2> |
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth1> | <trainDescriber> | <trainDescription1> |
    And I navigate to the Movement log tab
    When I search for Berth logs for fromToBerthId 'D3C007'
    Then the berth log results from row 2 are
      | trainId             | fromBerth | toBerth | previousTrainId     |
      | <trainDescription1> | D3C007    |         |                     |
      | <trainDescription2> |           | D3C007  |                     |
      | <trainDescription1> |           | D3C007  | <trainDescription2> |

    Examples:
      | berth1 | trainDescriber | trainDescription1 | trainDescription2 |
      | C007   | D3             | 2D19              | 4H19              |
