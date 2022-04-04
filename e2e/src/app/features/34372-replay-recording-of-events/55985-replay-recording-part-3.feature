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
#    And are viewing a map with trains present
#    When they open and timetable
#    Then the associations are displayed for the day corresponding to the date of the replay
  Scenario Outline: 34372-9 Replay - View Associations in the timetable
        # Replay Setup
    * I add map grouping configuration to the old replay data, modified to be 32 days old
    * I add the following planned schedule to the replay schedule data, modified to be 32 days old plus 0 minutes
      | trainDescription   | planningUid   | numberOfEntries |
      | <trainDescription> | <planningUid> | 1               |
    * I add the following active service to the replay schedule data with planningUid <planningUid> and headcode <trainDescription>, modified to be 32 days old plus 0 minutes
      | type               | location   | dateTime               | reason          |
    * I add the following punctuality to the replay schedule data, modified to be 32 days old plus 0 minutes
      | planningUid   | punctuality |
      | <planningUid> | 60          |
    * I add the following associations to the replay schedule data with planningUid <planningUid>, modified to be 32 days old plus 0 minutes
      | headcode          | type        | location       |
      | <assocHeadcode1>  | <assocType> | <assocTiploc>  |
    * I add the following associations to the replay schedule data with planningUid <planningUid>, modified to be 32 days old plus 1 minutes
      | headcode          | type        | location       |
      | <assocHeadcode1>  | <assocType> | <assocTiploc>  |
      | <assocHeadcode2>  | <assocType> | <assocTiploc>  |

    # Start a replay
    And I give the replay data a further 2 seconds to be recorded
    And I refresh the Elastic Search indices
    When I am on the replay page
    When I set the date and time for replay to
      | date       | time    | duration |
      | today - 32 | now - 4 | 5        |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I open the context menu for the continuation button 'GW02'
    And I open the next map in a new tab from the continuation button context menu
    And I switch to the new tab
    And I navigate to the replay timetable page for planningUid '<planningUid>' to be 32 days old
    And I switch to the new tab
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I switch to the timetable details tab
    Then The timetable associations table contains the following entries
      | location   | type        | trainDescription |
      | <assocLoc> | <assocType> | <assocHeadcode1> |
    When I click Skip forward button '1' times
    Then The timetable associations table contains the following entries
      | location   | type        | trainDescription |
      | <assocLoc> | <assocType> | <assocHeadcode1> |
      | <assocLoc> | <assocType> | <assocHeadcode2> |
    Examples:
      | trainDescription | assocTiploc | assocLoc  | assocType | assocHeadcode1 | assocHeadcode2 | planningUid |
      | generated        | WSTBRYW     | Westbury  | NP Next   | 1A11           | 1A12           | T02203      |


#    Given has started a replay session
#    And are viewing a map with trains present
#    When they open and timetable
#    Then the current punctuality is displayed for the day corresponding to the date and time of the replay
  Scenario Outline: 34372-11 Replay - Current Punctuality in the timetable
        # Replay Setup
    * I add map grouping configuration to the old replay data, modified to be 32 days old
    * I add the following active service to the replay schedule data with planningUid <planningUid> and headcode <trainDescription>, modified to be 32 days old plus 0 minutes
      | type               | location   | dateTime               | reason          |
    * I add the following punctuality to the replay schedule data, modified to be 32 days old plus 0 minutes
      | planningUid     | punctuality |
      | <planningUid>   | 60          |
    * I add the following punctuality to the replay schedule data, modified to be 32 days old plus 1 minutes
      | planningUid   | punctuality |
      | <planningUid> | 300         |
    * I add the following planned schedule to the replay schedule data, modified to be 32 days old plus 0 minutes
      | trainDescription   | planningUid    | numberOfEntries |
      | <trainDescription> | <planningUid>  | 1               |

    # Start a replay
    And I give the replay data a further 2 seconds to be recorded
    And I refresh the Elastic Search indices
    When I am on the replay page
    When I set the date and time for replay to
      | date       | time    | duration |
      | today - 32 | now - 4 | 5        |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I open the context menu for the continuation button 'GW02'
    And I open the next map in a new tab from the continuation button context menu
    And I switch to the new tab
    And I navigate to the replay timetable page for planningUid '<planningUid>' to be 32 days old
    And I switch to the new tab
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    Then the navbar punctuality indicator is displayed as 'yellow'
    And the punctuality is displayed as '+1m'
    When I click Skip forward button '1' times
    Then the navbar punctuality indicator is displayed as 'orange'
    And the punctuality is displayed as '+5m'
    Examples:
      | trainDescription | planningUid |
      | generated        | T02204      |


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
