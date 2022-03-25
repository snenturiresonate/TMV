@newSession @TMVPhase2
Feature: 33753 - Replay Recording

  As a TMV User
  I want the system to record the live railway events
  So that I can replay the railway for replay purposes

  Background:
    * I have not already authenticated
    * I have cleared out all headcodes
    * I generate a new train description
    * I generate a new trainUID


  Scenario Outline: 34375-8 Replay - View Train Journey Modifications in the timetable
#    Given has started a replay session
#    And are viewing a map with trains present
#    When they open and timetable
#    Then the Train Journey Modifications are displayed for the day corresponding to the date of the replay

    # Setup a service with activation, stepping, TRI and TJM
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID       | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid>  | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX (to create a match at Paddington)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following live berth step message is sent from LINX (departing from Paddington)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    When the following change of ID TJM is received
      | trainUid      | newTrainNumber  | oldTrainNumber     | departureHour | status | indicator | statusIndicator | primaryCode | modificationTime | subsidiaryCode | modificationReason |
      | <planningUid> | 1B99            | <trainDescription> | now           | create | 07        | 07              | 99999       | now              | PADTON         | Change to 1B99     |

    # Start a replay
    And I give the replay data a further 2 seconds to be recorded
    And I refresh the Elastic Search indices
    When I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I invoke the context menu on the map for train <trainDescription>
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is '1B99 TMV Replay Timetable'
    And I switch to the timetable details tab
    Then The timetable details tab is visible
    And there is a record in the modifications table
      | description        | location          | time | reason         |
      | Change Of Identity | London Paddington | now  | Change to 1B99 |
    # Skip backwards to clear event
    When I click Skip back button
    Then there are no records in the modifications table

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |


  Scenario Outline: 55985-9 Replay - View Associations in the timetable
#    Given has started a replay session
#    And are viewing a map with trains present
#    When they open and timetable
#    Then the Actual/Predicted are displayed for the day corresponding to the date and time of the replay
    Given I am on the home page
    And the access plan located in CIF file 'access-plan/associations_test.cif' is received from LINX
    And I give the timetable an extra 2 seconds to load
    And I wait until today's train '<trainUid>' has loaded
    And I refresh the Elastic Search indices
    When I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I search Timetable for '<trainDesc>' and wait for result
      | PlanningUid |
      | <trainUid>  |
    And the search table is shown
    And I open the timetable for the next train with UID <trainUid> from the search results
    And I switch to the new tab
    When I switch to the timetable details tab
    Then the tab title is '<trainDesc> TMV Replay Timetable'
    And The timetable details tab is visible
    Then The timetable associations table contains the following entries
      | location   | type        | trainDescription |
      | <assocLoc> | <assocType> | <assocTrainDesc> |

    Examples:
      | trainDesc | trainUid | assocType | assocLoc       | assocTrainDesc |
      | 2M39      | L78729   | NP Next   | Westbury       | 2F97           |
      | 2G13      | L04499   | JJ Join   | Purley         | 2P13           |
      | 1H63      | G46338   | VV Divide | Haywards Heath | 1H65           |
