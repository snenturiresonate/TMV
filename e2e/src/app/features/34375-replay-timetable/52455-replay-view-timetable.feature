@newSession
Feature: 34375 - TMV Replay Timetable - View Timetable

  As a TMV User
  I want to view historic timetable during replay
  So that I can view what timetable the train was running to and its historic actuals

  Background:
    * I have not already authenticated
    * I have cleared out all headcodes
    * I generate a new train description
    * I generate a new trainUID

  Scenario Outline: 34375-4a Replay - View Timetable (Schedule Matched - live updates are applied)
    # Given the user is authenticated to use TMV replay
    # And the user has opened a timetable within Replay
    # And the schedule is matched to live stepping
    # When the user is viewing the timetable
    # Then the schedule is displayed with any predicted and live actual running information and header information
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
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from origin |
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
    Then the tab title is '<trainDescription> TMV Replay Timetable'
    When I wait for the last Signal to populate
    And the last reported information reflects the TRI message 'Departure from London Paddington' for 'London Paddington'
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport                       | trainUid      | trustId                     | lastTJM | headCode           |
      | LTP       | SN7        | Departure from London Paddington | <planningUid> | 70<trainDescription>MHtoday |         | <trainDescription> |
    And the actual/predicted Departure time for location "London Paddington" instance 1 is correctly calculated based on External timing "now"
    And the actual/predicted Departure time for location "Royal Oak Junction" instance 1 is correctly calculated based on Internal timing "now + 1"
    And the actual/predicted Arrival time for location "Slough" instance 1 is correctly calculated based on Internal timing "now + 14"

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 34375-4b Replay - View Timetable (Schedule Matched - becoming unmatched)
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following live berth interpose message is sent from LINX (to create a match at Paddington)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I am viewing the map HDGW01paddington.v
    And berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible
    And I invoke the context menu on the map for train <trainDescription>
    And the Matched version of the Schedule-matching map context menu is displayed
    And I open schedule matching screen from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Schedule Matching <trainDescription>'
    When I un-match the currently matched schedule
    And the following live berth step message is sent from LINX (departing from Paddington and manifesting the scheduling changes)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And I give the replay data a further 2 seconds to be recorded
    And I refresh the Elastic Search indices
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I search Timetable for '<planningUid>' and wait for result
      | PlanningUid   |
      | <planningUid> |
    And the search table is shown
    And I open today's timetable with planning UID <planningUid> from the search results
    And the number of tabs open is 3
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Replay Timetable'
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport                       | trainUid      | trustId                         | lastTJM | headCode           |
      | LTP       | SN7        |                                  | <planningUid> |                                 |         | <trainDescription> |
    And the actual/predicted Departure time for location "London Paddington" instance 1 is correctly calculated based on Internal timing "now"
    And the actual/predicted Departure time for location "Royal Oak Junction" instance 1 is correctly calculated based on Internal timing "now + 1"
    And the actual/predicted Arrival time for location "Slough" instance 1 is correctly calculated based on Internal timing "now + 14"

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 34375-5 Replay - View Timetable (Schedule Not Matched - becoming matched)
    # Given the user is authenticated to use TMV replay
    # And the user has opened a timetable within Replay
    # And the schedule is not matched live stepping
    # When the user is viewing the timetable
    # Then the schedule is displayed with no predicted or live actual running information or header information.

    # Setup an unmatched service
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded

    # Check the unmatched service's timetable in replay
    And I give the replay data a further 2 seconds to be recorded
    And I refresh the Elastic Search indices
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I search Timetable for '<planningUid>' and wait for result
      | PlanningUid   |
      | <planningUid> |
    And the search table is shown
    And I open today's timetable with planning UID <planningUid> from the search results
    And the number of tabs open is 2
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Replay Timetable'
    Then The values for the header properties are as follows
      | schedType | lastSignal  | lastReport                       | trainUid      | trustId                         | lastTJM | headCode           |
      | LTP       |             |                                  | <planningUid> |                                 |         | <trainDescription> |
    And the actual/predicted times are blank

    # Match the service
    When the following live berth interpose message is sent from LINX (Matching at Paddington)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following live berth step message is sent from LINX (departing from Paddington)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And I am viewing the map HDGW01paddington.v
    And berth '0039' in train describer 'D3' contains '<trainDescription>' and is visible
    And I invoke the context menu on the map for train <trainDescription>
    And the Matched version of the Schedule-matching map context menu is displayed

    # Check the matched timetable in replay
    And I give the replay data a further 2 seconds to be recorded
    And I refresh the Elastic Search indices
    And I have not already authenticated
    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I invoke the context menu on the map for train <trainDescription>
    And I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Replay Timetable'
    And I wait for the last Signal to populate
    Then The values for the header properties are as follows
      | schedType | lastSignal  | lastReport                       | trainUid      | trustId                         | lastTJM | headCode           |
      | LTP       | SN7         |                                  | <planningUid> |                                 |         | <trainDescription> |
    And the actual/predicted Departure time for location "London Paddington" instance 1 is correctly calculated based on External timing "now"
    And the actual/predicted Departure time for location "Royal Oak Junction" instance 1 is correctly calculated based on Internal timing "now + 1"
    And the actual/predicted Arrival time for location "Slough" instance 1 is correctly calculated based on Internal timing "now + 14"

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 34375-6 Replay - View Timetable Detail (Schedule Matched)
    # Given the user is authenticated to use TMV replay
    # And the user has opened a timetable within Replay
    # And the schedule is matched to live stepping
    # When the user selects the details tab of the timetable
    # Then the train's CIF information and header information with any TJM, Association and Change-en-route is displayed

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
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from origin |
    And the following change of ID TJM is received
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

    # Check the replay timetable details
    Then The timetable details tab is visible
    And the current headcode in the header row is '1B99'
    And the old headcode in the header row is '(<trainDescription>)'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport                       | trainUid      | trustId                     | lastTJM            | headCode |
      | LTP       | SN7        | Departure from London Paddington | <planningUid> | 70<trainDescription>MHtoday | Change Of Identity | 1B99     |
     And The timetable details table contains the following data in each row
       | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class     | seatingClass | reservations | timingLoad | powerType | speed           | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
       | 04/01/2021 to 25/03/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             |         | EF       | 25507005         | P               | XX            |           | ,            | generated | B ,          | A ,          | 802 , 811  | EMU , DMU | 120mph , 144mph | ,         | m , m       | D , D,B,A                    |                 |
    And there is a record in the modifications table
      | description        | location          | time | reason         |
      | Change Of Identity | London Paddington | now  | Change to 1B99 |
    And The entry of the change en route table contains the following data
      | columnName |
      | Acton West |
      | DMU        |
      | 811        |
      | 144mph     |
      | D,B,A      |

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 34375-7 Replay - View Timetable Detail (Not Schedule Matched)
    # Given the user is authenticated to use TMV replay
    # And the user has opened a timetable within Replay
    # And the schedule is not matched to live stepping
    # When the user selects the details tab of the timetable
    # Then the schedule’s basic header information is displayed

    # Setup an unmatched service
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded

    # Start a replay
    And I give the replay data a further 2 seconds to be recorded
    And I refresh the Elastic Search indices
    When I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '5' times
    And I search Timetable for '<planningUid>' and wait for result
      | PlanningUid   |
      | <planningUid> |
    And the search table is shown
    And I open today's timetable with planning UID <planningUid> from the search results
    And the number of tabs open is 2
    And I switch to the new tab
    And the tab title is '<trainDescription> TMV Replay Timetable'
    And I switch to the timetable details tab

    # Check the replay timetable details
    Then The timetable details tab is visible
    And the current headcode in the header row is '<trainDescription>'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport                       | trainUid      | trustId                         | lastTJM            | headCode           |
      | LTP       |            |                                  | <planningUid> |                                 |                    | <trainDescription> |
    And The timetable details table contains the following data in each row
      | daysRun                  | runs                                                            | bankHoliday | berthId | operator | trainServiceCode | trainStatusCode | trainCategory | direction | cateringCode | class     | seatingClass | reservations | timingLoad | powerType | speed           | portionId | trainLength | trainOperatingCharacteristcs | serviceBranding |
      | 04/01/2021 to 25/03/2023 | Monday, Tuesday, Wednesday, Thursday, Friday, Saturday & Sunday |             |         | EF       | 25507005         | P               | XX            |           | ,            | generated | B ,          | A ,          | 802 , 811  | EMU , DMU | 120mph , 144mph | ,         | m , m       | D , D,B,A                    |                 |
    And The entry of the change en route table contains the following data
      | columnName |
      | Acton West |
      | DMU        |
      | 811        |
      | 144mph     |
      | D,B,A      |

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  # This test passes locally but fails when ran on the build server
#  @manual
  @blp
  Scenario Outline: 34375-8 Replay - View Timetable Detail (Replay Control - covering play and stop)
    # Given the user is authenticated to use TMV replay
    # And the user has opened a timetable within Replay
    # And the schedule is matched to live stepping
    # When the user uses the replay controls
    # Then the train's live information is updated accordingly (actuals, predicated, TJM, last reported, TRI, berth name)

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
    And I give the train 2 seconds to dwell
    And the following live berth step message is sent from LINX (departing from Paddington)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A007      | 0039    | D3             | <trainDescription> |
    And I give the train 2 seconds to dwell
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from origin |
    And the following live berth step message is sent from LINX (moving the train along)
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | 0039      | 0059    | D3             | <trainDescription> |
    And I give the train 2 seconds to dwell
    And the following change of ID TJM is received
      | trainUid      | newTrainNumber  | oldTrainNumber     | departureHour | status | indicator | statusIndicator | primaryCode | modificationTime | subsidiaryCode | modificationReason |
      | <planningUid> | 1B99            | <trainDescription> | now           | create | 07        | 07              | 99999       | now              | PADTON         | Change to 1B99     |

    # Setup a replay at the start of the replay
    And I give the replay data a further 2 seconds to be recorded
    And I refresh the Elastic Search indices
    When I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill

    # Check that the schedule loaded above is not present at the start of the replay
    And I search Timetable for '<planningUid>'
    And the search table is shown
    Then no results are returned with that planning UID '<planningUid>'
    When I click close button at the bottom of table

    # play the replay towards the end of the replay and check that updates are seen
    And I click Skip forward button '4' times
    And I increase the replay speed at position 4
    When I click Play button
    And berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible on map
    And I click Pause button
    And I search Timetable for '<planningUid>' and wait for result
      | PlanningUid   |
      | <planningUid> |
    And the search table is shown
    And I open today's timetable with planning UID <planningUid> from the search results
    And the number of tabs open is 2
    And I switch to the new tab
    And the tab title is '1B99 TMV Replay Timetable'
    And I switch to the timetable details tab
    And I click Play button
#    @bug @bug:83954
    Then The values for 'berthId' are the following as time passes
      | values                 |
      | D3A007, D30039, D30059 |

    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |
