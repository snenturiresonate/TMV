Feature: 41849 - Basic UI - Display berth state
  As a user
  I want to view berth state information in the UI
  So, that I can prove that stepping information is being processed correctly

  @blp
  Scenario: 47116 - Display Berth State - berth interpose is displayed upon the UI
    Given I am viewing the map GW01paddington.v
    And the berths are toggled on
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    Then berth 0099 contains 1G69
