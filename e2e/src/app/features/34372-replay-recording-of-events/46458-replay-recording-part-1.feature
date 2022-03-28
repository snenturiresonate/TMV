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


  #  Given a user has selected to start a replay
  #  When they enter a time period for the replay session
  #  Then the replay map selection is presented to select the starting map with maps that were available during that time period
  Scenario: 34372-1 Replay - Select a map available for the replay time period
    Given I am on the replay page
    When I select Next
    And I expand the replay group of maps with name 'North West and Central'
    Then the following replay maps are listed
    | mapName                   |
    | MD01 London Euston        |
    | MD08 Birmingham Stour Val |
    | NW22 MP SCC Signaller     |


  #  Given a user has selected to start a replay
  #  And entered the time period
  #  When they select the maps they want to include in the replay session
  #  Then the maps displayed corresponds to the version of the map that was available during that time period
  @superseded
  # Superseded by: Feature: 79622 - TMV Schematic Map Version - Display map version and applicable date
  Scenario: 34372-2 Replay - View replay map


  #  Given a user has selected to start a replay
  #  And entered the time period in the recent time window
  #  And selected the maps
  #  When they press play
  #  Then the train describer updates are displayed on the map
  @superseded
  # Superseded by: Feature: 34375 - TMV Replay Timetable - Open Timetable
  Scenario: 34372-3 Replay - Play replay map Train describer data (recent data)


  #  Given a user has selected to start a replay
  #  And entered the time period in the old time window
  #  And selected the maps
  #  When they press play
  #  Then the train describer updates are displayed on the map
  Scenario Outline: 34372-4 Replay - Play replay map Train describer data (old data)
    # Replay Setup
    * I add map grouping configuration to the old replay data, modified to be 32 days old
    * I add the following berth interpose to the old replay snapshot data, modified to be 32 days old
      | trainDescriber | trainDescription   | berthName | signalName |
      | D3             | <trainDescription> | 0099      | SN99       |
    * I add the following berth interpose to the old replay object state data, modified to be 32 days old
      | trainDescriber | trainDescription   | berthName | signalName |
      | D3             | <trainDescription> | 0099      | SN99       |

    # Replay Test
    Given I am on the replay page
    When I set the date and time for replay to
      | date       | time    | duration |
      | today - 32 | now - 5 | 5        |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    Then berth '0099' in train describer 'D3' contains '<trainDescription>' and is visible on map

    Examples:
      | trainDescription |
      | generated        |
