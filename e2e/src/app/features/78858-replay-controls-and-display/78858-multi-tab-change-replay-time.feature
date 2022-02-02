@TMVPhase2 @P2.S1
@newSession
Feature: 78858 - TMV Replay Controls & Display - Multi-tab Change Replay Session Start and End Time
  As a TMV User
  I want to the replay controls and view updated
  So that it is closer to CCF which I am familiar with

  #  Given a user has already started a replay session
  #  And has multiple maps and timetable open
  #  When the user changes the start and/or end date & time of the replay session
  #  Then the replay session is re-initalised for all open tabs
  #
  #  Comments:
  #  Check the time in the nav bar is updated
  #  Check the time on the replay control is updated
  #  Check the data on the view is updated based on the time

  Background:
    * I have not already authenticated
    * I have cleared out all headcodes
    * I generate a new trainUID
    * I generate a new train description

  Scenario Outline: 84098-1 - Change Replay Session Start and End Time (Multi-Tab) - Multiple Maps
    # setup the replay data
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUID>  |
    And I wait until today's train '<planningUID>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                 | now                    | 99999               | PADTON                 | today         |
    And the following live berth interpose messages are sent from LINX (to generate some replay data to load)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following live berth step message is sent from LINX (departing from Paddington)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And I give the replay data 4 seconds to be stored
    And I refresh the Elastic Search indices

    # starting conditions
    When I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I record the replay nav bar time
    And I record the replay control time
    Then berth '0039' in train describer 'D3' contains '<trainDescription>' and is visible on map
    When I launch a new replay map 'HDGW01'
    And I switch to the new tab
    And I wait for the tracks to be displayed
    Then the replay nav bar time matches that which was recorded
    And the replay control time matches that which was recorded
    And berth '0039' in train describer 'D3' contains '<trainDescription>' and is visible on map

    # change the replay start time
    When I primary click the replay time
    And I select time period 'Last 9 minutes' from the quick dropdown
    And I select Next
    And I wait for the buffer to fill
    And I click Skip forward button '5' times

    # check that the tabs are in sync
    Then berth '0039' in train describer 'D3' does not contain '<trainDescription>'
    And the replay nav bar time does not match that which was recorded
    And the replay control time does not match that which was recorded
    When I switch to the second-newest tab
    And I wait for the tracks to be displayed
    Then berth '0039' in train describer 'D3' does not contain '<trainDescription>'
    And the replay nav bar time does not match that which was recorded
    And the replay control time does not match that which was recorded

    # check that original replay state is in sync across tabs
    When I click Skip forward button '4' times
    And I record the replay nav bar time
    And I record the replay control time
    Then berth '0039' in train describer 'D3' contains '<trainDescription>' and is visible on map
    And I switch to the new tab
    And I wait for the tracks to be displayed
    Then the replay nav bar time matches that which was recorded
    And the replay control time matches that which was recorded
    And berth '0039' in train describer 'D3' contains '<trainDescription>' and is visible on map

    Examples:
      | trainDescription | planningUID |
      | generated        | generated   |

  Scenario Outline: 84098-2 - Change Replay Session Start and End Time (Multi-Tab) - Map and Timetable
    # setup the replay data
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUID>  |
    And I wait until today's train '<planningUID>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                 | now                    | 99999               | PADTON                 | today         |
    And the following live berth interpose messages are sent from LINX (to generate some replay data to load)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following live berth step message is sent from LINX (departing from Paddington)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And I give the replay data 4 seconds to be stored
    And I refresh the Elastic Search indices

    # starting conditions
    When I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I record the replay nav bar time
    And I record the replay control time
    Then berth '0039' in train describer 'D3' contains '<trainDescription>' and is visible on map
    When I invoke the context menu on the map for train <trainDescription>
    And I open timetable from the map context menu
    And I switch to the new tab
    And I wait for the last Signal to populate
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode           |
      | LTP       | SN7        |            | <planningUID> |         |         | <trainDescription> |
    And the timetable table tab text is '<trainDescription> TMV Timetable'
    And the replay nav bar time matches that which was recorded
    And the replay control time matches that which was recorded

    # change the replay start time
    When I primary click the replay time
    And I select time period 'Last 9 minutes' from the quick dropdown
    And I select Next
    And I wait for the buffer to fill
    And I click Skip forward button '5' times

    # check that the tabs are in sync
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode           |
      |           |            |            |               |         |         |                    |
    And the timetable table tab text is 'TMV Timetable'
    And the replay nav bar time does not match that which was recorded
    And the replay control time does not match that which was recorded
    When I switch to the second-newest tab
    And I wait for the tracks to be displayed
    Then berth '0039' in train describer 'D3' does not contain '<trainDescription>'
    And the replay nav bar time does not match that which was recorded
    And the replay control time does not match that which was recorded

    # check that original replay state is in sync across tabs
    When I click Skip forward button '4' times
    And I record the replay nav bar time
    And I record the replay control time
    Then berth '0039' in train describer 'D3' contains '<trainDescription>' and is visible on map
    And I switch to the new tab
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode           |
      | LTP       | SN7        |            | <planningUID> |         |         | <trainDescription> |
    And the timetable table tab text is '<trainDescription> TMV Timetable'
    And the replay nav bar time matches that which was recorded
    And the replay control time matches that which was recorded

    Examples:
      | trainDescription | planningUID |
      | generated        | generated   |

  Scenario Outline: 84098-3 - Change Replay Session Start and End Time (Multi-Tab) - Multiple Timetables
    # setup the replay data
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUID>  |
    And I wait until today's train '<planningUID>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                 | now                    | 99999               | PADTON                 | today         |
    And the following live berth interpose messages are sent from LINX (to generate some replay data to load)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following live berth step message is sent from LINX (departing from Paddington)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And I give the replay data 4 seconds to be stored
    And I refresh the Elastic Search indices

    # starting conditions
    When I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I record the replay nav bar time
    And I record the replay control time
    Then berth '0039' in train describer 'D3' contains '<trainDescription>' and is visible on map
    When I invoke the context menu on the map for train <trainDescription>
    And I open timetable from the map context menu
    And I switch to the second-newest tab
    And I invoke the context menu on the map for train <trainDescription>
    And I open timetable from the map context menu
    And I switch to the new tab
    And I wait for the last Signal to populate
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode           |
      | LTP       | SN7        |            | <planningUID> |         |         | <trainDescription> |
    And the timetable table tab text is '<trainDescription> TMV Timetable'
    And the replay nav bar time matches that which was recorded
    And the replay control time matches that which was recorded
    And I switch to the second-newest tab
    And I wait for the last Signal to populate
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode           |
      | LTP       | SN7        |            | <planningUID> |         |         | <trainDescription> |
    And the timetable table tab text is '<trainDescription> TMV Timetable'
    And the replay nav bar time matches that which was recorded
    And the replay control time matches that which was recorded

    # change the replay start time
    When I primary click the replay time
    And I select time period 'Last 9 minutes' from the quick dropdown
    And I select Next
    And I wait for the buffer to fill
    And I click Skip forward button '5' times

    # check that the tabs are in sync
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode           |
      |           |            |            |               |         |         |                    |
    And the timetable table tab text is 'TMV Timetable'
    And the replay nav bar time does not match that which was recorded
    And the replay control time does not match that which was recorded
    When I switch to the new tab
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode           |
      |           |            |            |               |         |         |                    |
    And the timetable table tab text is 'TMV Timetable'
    And the replay nav bar time does not match that which was recorded
    And the replay control time does not match that which was recorded

    # check that original replay state is in sync across tabs
    When I click Skip forward button '4' times
    And I record the replay nav bar time
    And I record the replay control time
    And I switch to the second-newest tab
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode           |
      | LTP       | SN7        |            | <planningUID> |         |         | <trainDescription> |
    And the timetable table tab text is '<trainDescription> TMV Timetable'
    And the replay nav bar time matches that which was recorded
    And the replay control time matches that which was recorded
    When I switch to the second-newest tab
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId | lastTJM | headCode           |
      | LTP       | SN7        |            | <planningUID> |         |         | <trainDescription> |
    And the timetable table tab text is '<trainDescription> TMV Timetable'
    And the replay nav bar time matches that which was recorded
    And the replay control time matches that which was recorded

    Examples:
      | trainDescription | planningUID |
      | generated        | generated   |
