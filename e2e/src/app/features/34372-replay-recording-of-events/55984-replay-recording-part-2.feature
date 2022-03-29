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
#    Then the agreed plan is displayed for the day corresponding to the date of the replay
  Scenario Outline: 34372-7 Replay - View Agreed Plan in the timetable
        # Replay Setup
    * I add map grouping configuration to the old replay data, modified to be 32 days old
    * I add the following active service to the replay schedule data, modified to be 32 days old plus 0 minutes
      | trainDescription   | planningUid |
      | <trainDescription> | T02201      |
    * I add the following punctuality to the replay schedule data, modified to be 32 days old plus 0 minutes
      | planningUid | punctuality |
      | T02201      | 60          |
    * I add the following planned schedule to the replay schedule data, modified to be 32 days old plus 0 minutes
      | trainDescription   | planningUid | numberOfEntries |
      | <trainDescription> | T02201      | 1               |
    * I add the following planned schedule to the replay schedule data, modified to be 32 days old plus 1 minutes
      | trainDescription   | planningUid | numberOfEntries |
      | <trainDescription> | T02201      | 2               |

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
    And I navigate to the replay timetable page for planningUid 'T02201' to be 32 days old
    And I switch to the new tab
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    Then The timetable entries contains the following data
      | rowNum | location               | locInstance | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1      | London Paddington      | 1           |                    | 14:09           |                   | 14:09          | 4                 |                  | 1                |            | TB         |                 |              |           |          |          |             |
    When I click Skip forward button '1' times
    Then The timetable entries contains the following data
      | rowNum | location               | locInstance | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1      | London Paddington      | 1           |                    | 14:09           |                   | 14:09          | 4                 |                  | 1                |            | TB         |                 |              |           |          |          |             |
      | 2      | Royal Oak Junction     | 1           |                    | 14:10           |                   |                |                   | 1                | 1                |            |            |                 |              |           |          |          |             |

    Examples:
      | trainDescription |
      | generated        |
