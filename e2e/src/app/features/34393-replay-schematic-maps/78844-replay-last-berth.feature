Feature: 78855 - Replay Last Berth

  As a TMV User
  I want to view trains that have reached the last berth in replay
  So that I see the last 10 trains that have reached a particular location

  Background:
    * I have cleared out all headcodes
    * I remove all trains from the trains list
    * I am on the home page
    * I restore to default train list config '1'
    * I delete 'last-berth-states' from Redis
    * I reset redis


  Scenario Outline: 34080-2a Last Berth (Select Timetable, left click) - matched trains
    # Given the user is viewing a live schematic map
    # And there are services running
    # And performs a secondary click on the last berth
    # When the user views a list of the last services that have finished at this berth
    # And performs a primary click on a train
    # Then the user is presented with the timetable in a new tab

    #setup
    * I delete 'C56471:today' from hash 'schedule-modifications'
    * I remove today's train 'C56471' from the Redis trainlist

    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B71                | C56471         |
    * I wait until today's train 'C56471' has loaded
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56471     | 2B71        | now                    | 99999               | MDNHEAD                | today         |

    # Log the berth level schedule
    * I log the berth & locations from the berth level schedule for 'C56471'

    # Inject stepping
    * the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B71             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B71             |

    # Check that trains have loaded
    * I am on the trains list page 1
    * I save the trains list config
    * train '2B71' with schedule id 'C56471' for today is visible on the trains list

    # Check the last berth
    * I am viewing the map <map>
    * berth '<lB1>' in train describer '<lBTD>' contains '<lTD1>' and is visible

    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW2Aslough.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then berth '<lB1>' in train describer '<lBTD>' contains '<lTD1>' and is visible
    When I click on the map for train 2B71
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the tab title contains 'TMV Replay Timetable'

    Examples:
      | cifFile                                              | map          | lBTD | lB1  | lTD1 | TDandBerthId1 |
      | access-plan/34080-schedules/2B51-MDNHEAD-BORNEND.cif | gw2aslough.v | D6   | LMBE | 2B71 | D6LMBE        |

  Scenario: 34080-2b Last Berth (Select Timetable) - unmatched trains
    # Inject stepping
    * the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B72             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B72             |

    # Check the last berth
    * I am viewing the map gw2aslough.v
    * berth 'LMBE' in train describer 'D6' contains '2B72' and is visible

    And I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'GW2Aslough.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I click Play button
    Then berth 'LMBE' in train describer 'D6' contains '2B72' and is visible
    When I click on the map for train 2B72
    Then the number of tabs open is 1
