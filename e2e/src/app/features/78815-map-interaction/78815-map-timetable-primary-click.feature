@TMVPhase2 @P2.S1
Feature: 78815 - TMV Map Interaction - Map Timetable Primary Click

  As a TMV User
  I want the ability to interact with the schematic maps
  So that I can access additional functions or information

  Scenario: 78844 - Open timetable from left click berth (Live)
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | GORASTR     | WTT_pass      | 1F34                | L00014         |
    And I wait until today's train 'L00014' has loaded
    And I am viewing the map GW03reading.v
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0813    | D1             | 1F34             |
    Then berth '0813' in train describer 'D1' contains '1F34' and is visible
    When I wait for the Open timetable option for train description 1F34 in berth 0813, describer D1 to be available
    And I click on the map for train 1F34
    And I switch to the new tab
    Then the tab title is '1F34 TMV Timetable'

  Scenario Outline: 78844 - Last Berth (Select Timetable, left click) - matched trains
    #setup
    * I delete 'C56471:today' from hash 'schedule-modifications'
    * I remove today's train 'C56471' from the Redis trainlist
    * I am on the trains list page 1
    * I restore to default train list config '1'
    * I refresh the browser

    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | <lTD1>              | C56471         |
    * I wait until today's train 'C56471' has loaded
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56471     | <lTD1>      | now                    | 99999               | MDNHEAD                | today         |

    # Log the berth level schedule
    * I log the berth & locations from the berth level schedule for 'C56471'

    # Inject stepping
    When the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | <lTD1>           |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | <lTD1>           |

    # Check that trains have loaded
    And I am on the trains list page 1
    And I save the trains list config
    * train <lTD1> with schedule id 'C56471' for today is visible on the trains list

    # Check the last berth
    And I am viewing the map <map>
    Then berth '<lB1>' in train describer '<lBTD>' contains '<lTD1>' and is visible
    When I click on the map for train <lTD1>
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the tab title is '2B71 TMV Timetable'

    Examples:
      | cifFile                                              | map          | lBTD | lB1  | lTD1 | TDandBerthId1 |
      | access-plan/34080-schedules/2B51-MDNHEAD-BORNEND.cif | gw2aslough.v | D6   | LMBE | 2B71 | D6LMBE        |

  Scenario: 78844 - Open timetable from left click berth (Replay)
    # Replay setup
    * I reset redis
    * the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | GORASTR     | WTT_pass      | 1F34                | L00014         |
    * I wait until today's train 'L00014' has loaded
    * I am viewing the map GW03reading.v
    * the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | 0813    | D1             | 1F34             |
    * berth '0813' in train describer 'D1' contains '1F34' and is visible

    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW03reading.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then berth '0813' in train describer 'D1' contains '1F34' and is visible
    When I wait for the Open timetable option for train description 1F34 in berth 0813, describer D1 to be available
    And I click on the map for train 1F34
    And I switch to the new tab
    Then the tab title is '1F34 TMV Replay Timetable'
