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
    * I add the following planned schedule to the replay schedule data, modified to be 32 days old plus 0 minutes
      | trainDescription   | planningUid    | numberOfEntries |
      | <trainDescription> | <planningUid>  | 1               |
    * I add the following active service to the replay schedule data with planningUid <planningUid> and headcode <trainDescription>, modified to be 32 days old plus 0 minutes
      | type               | location   | dateTime               | reason          |
    * I add the following punctuality to the replay schedule data, modified to be 32 days old plus 0 minutes
      | planningUid   | punctuality |
      | <planningUid> | 60          |
    * I add the following planned schedule to the replay schedule data, modified to be 32 days old plus 1 minutes
      | trainDescription   | planningUid    | numberOfEntries |
      | <trainDescription> | <planningUid>  | 2               |

    # Start a replay
    And I give the replay data a further 2 seconds to be recorded
    And I refresh the Elastic Search indices
    When I am on the replay page
    When I set the date and time for replay to
      | date                      | time    | duration |
      | today - <replayAgeInDays> | now - 4 | 5        |
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I open the context menu for the continuation button 'GW02'
    And I open the next map in a new tab from the continuation button context menu
    And I switch to the new tab
    And I navigate to the replay timetable page for planningUid '<planningUid>' to be <replayAgeInDays> days old
    And I switch to the new tab
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    Then the replay start date is 'today - <replayAgeInDays>'
    And The timetable entries contains the following data
      | rowNum | location               | locInstance | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1      | London Paddington      | 1           |                    | 14:09           |                   | 14:09          | 4                 |                  | 1                |            | TB         |                 |              |           |          |          |             |
    When I click Skip forward button '1' times
    Then The timetable entries contains the following data
      | rowNum | location               | locInstance | workingArrivalTime | workingDeptTime | publicArrivalTime | publicDeptTime | originalAssetCode | originalPathCode | originalLineCode | allowances | activities | arrivalDateTime | deptDateTime | assetCode | pathCode | lineCode | punctuality |
      | 1      | London Paddington      | 1           |                    | 14:09           |                   | 14:09          | 4                 |                  | 1                |            | TB         |                 |              |           |          |          |             |
      | 2      | Royal Oak Junction     | 1           |                    | 14:10           |                   |                |                   | 1                | 1                |            |            |                 |              |           |          |          |             |
    And I switch to the timetable details tab
    And The timetable details tab is visible
    And I give the timetable a settling time of 2 seconds to update
    And The timetable details table contains the following data in each row
      | daysRun                                                | runs | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class | seatingClass | reservations | timingLoad | powerType | speed | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | today - <replayAgeInDays> to today - <replayAgeInDays> |      |             |         | EF       | 25507005         |                 | XX            |           |              | 7     |              |              |            |           | mph   |           | m           |                              |                 |

    Examples:
      | trainDescription | planningUid | replayAgeInDays |
      | generated        | T02202      | 32              |


#    Given has started a replay session
#    And are viewing a map with trains present
#    When they open and timetable
#    Then the Train Journey Modifications are displayed for the day corresponding to the date of the replay
  Scenario Outline: 34372-8 Replay - View Train Journey Modifications in the timetable
        # Replay Setup
    * I add map grouping configuration to the old replay data, modified to be 32 days old
    * I add the following planned schedule to the replay schedule data, modified to be 32 days old plus 0 minutes
      | trainDescription   | planningUid   | numberOfEntries |
      | <trainDescription> | <planningUid> | 1               |
    * I add the following punctuality to the replay schedule data, modified to be 32 days old plus 0 minutes
      | planningUid   | punctuality |
      | <planningUid> | 60          |
    * I add the following associations to the replay schedule data with planningUid <planningUid>, modified to be 32 days old plus 0 minutes
      | headcode  | type        | location |
      | 1A11      | NP Next     | WSTBRYW  |
    * I add the following active service to the replay schedule data with planningUid <planningUid> and headcode <trainDescription>, modified to be 32 days old plus 0 minutes
      | type               | location   | dateTime               | reason          |
      | CHANGE_OF_IDENTITY | PADTON     | 1970-01-01T12:00:00    | Change to 1B99  |
    * I add the following active service to the replay schedule data with planningUid <planningUid> and headcode <trainDescription>, modified to be 32 days old plus 1 minutes
      | type               | location   | dateTime               | reason          |
      | CHANGE_OF_IDENTITY | PADTON     | 1970-01-01T12:00:00    | Change to 1B98  |
      | CANCELLATION       | OXFD       | 1970-01-01T12:00:00    | Cancelled       |

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
    Then The timetable details tab is visible
    And there is a record in the modifications table
      | description        | location           | time              | reason         |
      | Change Of Identity | London Paddington  | 01/01/1970 12:00  | Change to 1B99 |
    When I click Skip forward button '1' times
    Then there is a record in the modifications table
      | description        | location           | time              | reason         |
      | Change Of Identity | London Paddington  | 01/01/1970 12:00  | Change to 1B98 |
    And there is a record in the modifications table
      | description        | location | time              | reason         |
      | Cancellation       | Oxford   | 01/01/1970 12:00  | Cancelled      |
    Examples:
      | trainDescription | planningUid |
      | generated        | T02201      |
