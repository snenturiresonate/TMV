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
    * I add the following berth interpose to the old replay snapshot data, modified to be 32 days old plus 0 minutes
      | trainDescriber | trainDescription   | berthName | signalName | punctuality   |
      | D3             | <trainDescription> | 0099      | SN99       | 60            |
    * I add the following berth interpose to the old replay object state data, modified to be 32 days old plus 0 minutes
      | trainDescriber | trainDescription   | berthName | signalName | punctuality   |
      | D3             | <trainDescription> | 0099      | SN99       | 60            |

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

  #  Given a user has selected to start a replay
  #  And entered the time period in recent time window
  #  And selected the maps containing manual trust berths
  #  When they press play
  #  Then the manual trust berth updates are displayed on the map
  Scenario Outline: 34372 -5 Replay - Play replay map Manual TRUST berth data (recent data)
    # Replay Setup
    Given I clear all MTBs
    And I remove today's train '<trainUID>' from the trainlist
    And the access plan located in CIF file '<cif>' is received from LINX
    And I wait until today's train '<trainUID>' has loaded
    And I am viewing the map nw05sandhillsnl.v
    And the following train running info message with time is sent from LINX
      | trainUID   | trainNumber   | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | timestamp |
      | <trainUID> | <trainNumber> | today              | 85621               | RUFDORD                | Departure from Station | now       |
    And headcode '<trainNumber>' is present in manual-trust berth '30155U'
    And I give the replay data 2 seconds to load

    # Replay Test
    When I am on the replay page
    * I select Next
    * I expand the replay group of maps with name 'North West and Central'
    * I select the map 'NW05sandhillsnl.v'
    * I wait for the buffer to fill
    * I click Skip forward button '4' times
    * I increase the replay speed at position 15
    * I click Play button
    Then headcode '<trainNumber>' is present in manual-trust berth '30155U'

    Examples:
      | cif                                     | trainUID | trainNumber |
      | access-plan/34082-schedules/60651-1.cif | C33605   | 2N02        |

  #  Given a user has selected to start a replay
  #  And entered the time period in old time window
  #  And selected the maps containing manual trust berths
  #  When they press play
  #  Then the manual trust berth updates are displayed on the map
  Scenario Outline: 34372 -6 Replay - Play replay map Manual TRUST berth data (old data)
    # Replay Setup
    Given I add map grouping configuration to the old replay data, modified to be 32 days old
    * I add the following train running info message to the old replay snapshot data, modified to be 32 days old plus 0 minutes
      | mapId             | trainUID   | trainNumber   | locationSubsidiaryCode | manualTrustBerthId |
      | NW05sandhillsnl.v | <trainUID> | <trainNumber> | RUFDORD                | 30155U             |
    * I add the following train running info message to the old replay object state data, modified to be 32 days old plus 0 minutes
      | trainDescriber    | trainUID   | trainNumber   | locationSubsidiaryCode | manualTrustBerthId |
      | PK                | <trainUID> | <trainNumber> | RUFDORD                | 30155U             |

    # Replay Test
    When I am on the replay page
    * I set the date and time for replay to
      | date       | time    | duration |
      | today - 32 | now - 5 | 5        |
    * I select Next
    * I expand the replay group of maps with name 'North West and Central'
    * I select the map 'NW05sandhillsnl.v'
    * I wait for the buffer to fill
    * I click Skip forward button '3' times
    * I increase the replay speed at position 15
    * I click Play button
    Then headcode '<trainNumber>' is present in manual-trust berth '30155U'

    Examples:
      | trainUID | trainNumber |
      | C33605   | 2N02        |

