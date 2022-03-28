@newSession
Feature: 34372 - TMV Replay Recording of Events
  As a TMV User
  I want the system to record the live railway events
  So that I can replay the railway for replay purposes

  Background:
    * I have not already authenticated
    * I reset redis
    * I have cleared out all headcodes
    * I generate a new train description

#    Given has started a replay session
#    When they view a map with trains present
#    Then the current punctuality is displayed for the day corresponding to the date and time of the replay
  Scenario Outline: 34372-12 Replay - Current Punctuality on the map
    # Replay Setup
    * I add map grouping configuration to the old replay data, modified to be 32 days old
    * I add the following berth interpose to the old replay snapshot data, modified to be 32 days old plus 0 minutes
      | trainDescriber | trainDescription   | berthName | signalName | punctuality   |
      | D3             | <trainDescription> | 0067      | SN99       | 60            |
    * I add the following berth interpose to the old replay object state data, modified to be 32 days old plus 0 minutes
      | trainDescriber | trainDescription   | berthName | signalName | punctuality   |
      | D3             | <trainDescription> | 0067      | SN99       | 60            |
    * I add the following berth interpose to the old replay object state data, modified to be 32 days old plus 1 minutes
      | trainDescriber | trainDescription   | berthName | signalName | punctuality   |
      | D3             | <trainDescription> | 0067      | SN99       | 300           |

    # Replay Test
    Given I am on the replay page
    When I set the date and time for replay to
      | date       | time    | duration |
      | today - 32 | now - 4 | 5        |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    Then berth '0067' in train describer 'D3' contains '<trainDescription>' and is visible on map
    And the train headcode color for berth 'D30067' is yellow
    And I click Skip forward button '1' times
    And the train headcode color for berth 'D30067' is orange

    Examples:
      | trainDescription |
      | generated        |
