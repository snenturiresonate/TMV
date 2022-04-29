Feature: 34080 - Last Berth

  As a TMV User
  I want to view trains that have reached the last berth
  So that I see the last 10 trains that have reached a particular location

  Background:
    * I have cleared out all headcodes
    * I remove all trains from the trains list
    * I am on the home page
    * I restore to default train list config '1'
    * I delete 'last-berth-states' from Redis
    * I reset redis


  Scenario Outline: 34080-1a Last Berth (Secondary Click) - less than 10
  #    Given the user is viewing a live schematic map
  #    And there are services running
  #    When the user views a last berth containing a service
  #    And performs a secondary click on the last berth
  #    Then the user is presented with a list of the last services that have finished at this berth

    # setup
    * I delete 'C56451:today' from hash 'schedule-modifications-today'
    * I delete 'C56453:today' from hash 'schedule-modifications-today'
    * I delete 'C56455:today' from hash 'schedule-modifications-today'
    * I delete 'C56457:today' from hash 'schedule-modifications-today'
    * I remove today's train 'C56457' from the trainlist

    # Inject CIFs and activations
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B51                | C56451         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56451     | 2B51        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now - '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B53                | C56453         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56453     | 2B53        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now - '7' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B55                | C56455         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56455     | 2B55        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B57                | C56457         |
    * I wait until today's train 'C56457' has loaded
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56457     | 2B57        | now                    | 99999               | MDNHEAD                | today         |

    # Log the berth level schedules
    * I log the berth & locations from the berth level schedule for 'C56451'
    * I log the berth & locations from the berth level schedule for 'C56453'
    * I log the berth & locations from the berth level schedule for 'C56455'
    * I log the berth & locations from the berth level schedule for 'C56457'

    # Inject stepping
    When the following live - 7 minutes berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B55             |
    * the following live - 7 minutes berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B55             |
    And the following live - 2 minutes berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B53             |
    * the following live - 2 minutes berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B53             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B51             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B51             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B57             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | MDES    | D6             | 2B57             |

    # Check the last berth
    And I am viewing the map <map>
    Then berth '<lB1>' in train describer '<lBTD>' contains '<lTD1>' and is visible
    * berth '<lB2>' in train describer '<lBTD>' contains '<lTD2>' and is visible
    When I use the secondary mouse on last berth <TDandBerthId1>
    Then the user is presented with a list of the last '<numTrains1>' services that have 'finished at' this berth
      | serviceDescription | operatorCode | punct             | eventDateTime |
      | 2B51               | (EF)         | -1m or -2m or -3m | now + 0       |
      | 2B53               | (EF)         | +2m or +3m or +4m | now - 2       |
      | 2B55               | (EF)         | +7m or +8m or +9m | now - 7       |
    When I use the secondary mouse on last berth <TDandBerthId2>
    Then the user is presented with a list of the last '<numTrains2>' services that have 'finished at' this berth
      | serviceDescription | operatorCode | punct      | eventDateTime |
      | 2B57               | (EF)         | -1m or -2m | now + 0       |

    Examples:
      | cifFile                                              | map          | lBTD | lB1  | lTD1 | TDandBerthId1 | numTrains1 | lB2  | lTD2 | TDandBerthId2 | numTrains2 |
      | access-plan/34080-schedules/2B51-MDNHEAD-BORNEND.cif | gw2aslough.v | D6   | LMBE | 2B51 | D6LMBE        | 3          | MDES | 2B57 | D6MDES        | 1          |

  Scenario Outline: 34080-1b Last Berth (Secondary Click) - more than 10
    # setup
    * I delete 'C56458:today' from hash 'schedule-modifications-today'
    * I delete 'C56459:today' from hash 'schedule-modifications-today'
    * I delete 'C56460:today' from hash 'schedule-modifications-today'
    * I delete 'C56461:today' from hash 'schedule-modifications-today'
    * I delete 'C56462:today' from hash 'schedule-modifications-today'
    * I delete 'C56463:today' from hash 'schedule-modifications-today'
    * I delete 'C56464:today' from hash 'schedule-modifications-today'
    * I delete 'C56465:today' from hash 'schedule-modifications-today'
    * I delete 'C56466:today' from hash 'schedule-modifications-today'
    * I delete 'C56467:today' from hash 'schedule-modifications-today'
    * I delete 'C56468:today' from hash 'schedule-modifications-today'
    * I remove today's train 'C56468' from the trainlist

    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B58                | C56458         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56458     | 2B58        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B59                | C56459         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56459     | 2B59        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B60                | C56460         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56460     | 2B60        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B61                | C56461         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56461     | 2B61        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B62                | C56462         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56462     | 2B62        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B63                | C56463         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56463     | 2B63        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B64                | C56464         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56464     | 2B64        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B65                | C56465         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56465     | 2B65        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B66                | C56466         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56466     | 2B66        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B67                | C56467         |
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56467     | 2B67        | now                    | 99999               | MDNHEAD                | today         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B68                | C56468         |
    * I wait until today's train 'C56468' has loaded
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56468     | 2B68        | now                    | 99999               | MDNHEAD                | today         |

    # Inject stepping
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B58             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B58             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B59             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B59             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B60             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B60             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B61             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B61             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B62             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B62             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B63             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B63             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B64             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B64             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B65             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B65             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B66             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B66             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B67             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B67             |
    And the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B68             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B68             |

    # Check the last berth
    And I am viewing the map <map>
    Then berth '<lB1>' in train describer '<lBTD>' contains '<lTD1>' and is visible
    When I use the secondary mouse on last berth <TDandBerthId1>
    Then the user is presented with a list of the last '<numTrains1>' services that have 'finished at' this berth
      | serviceDescription | operatorCode | punct                    | eventDateTime |
      | 2B68               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |
      | 2B67               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |
      | 2B66               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |
      | 2B65               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |
      | 2B64               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |
      | 2B63               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |
      | 2B62               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |
      | 2B61               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |
      | 2B60               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |
      | 2B59               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |
      | 2B58               | (EF)         | -0m or +0m or -1m or +1m | now + 0       |

    Examples:
      | cifFile                                              | map          | lBTD | lB1  | lTD1 | TDandBerthId1 | numTrains1 |
      | access-plan/34080-schedules/2B51-MDNHEAD-BORNEND.cif | gw2aslough.v | D6   | LMBE | 2B68 | D6LMBE        | 10         |

  Scenario Outline: 34080-2a Last Berth (Select Timetable) - matched trains
    # Given the user is viewing a live schematic map
    # And there are services running
    # And performs a secondary click on the last berth
    # When the user views a list of the last services that have finished at this berth
    # And performs a primary click on a train
    # Then the user is presented with the timetable in a new tab

    #setup
    * I generate a new trainUID
    * I delete '<planningUID>:today' from hash 'schedule-modifications-today'
    * I remove today's train '<planningUID>' from the trainlist

    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B71                | <planningUID>  |
    * I wait until today's train '<planningUID>' has loaded
    * the following train activation message is sent from LINX
      | trainUID      | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <planningUID> | 2B71        | now                    | 99999               | MDNHEAD                | today         |

    # Log the berth level schedule
    * I log the berth & locations from the berth level schedule for '<planningUID>'

    # Inject stepping
    When the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B71             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B71             |

    # Check that trains have loaded
    And I am on the trains list page 1
    And I save the trains list config
    * train '2B71' with schedule id '<planningUID>' for today is visible on the trains list

    # Check the last berth
    And I am viewing the map <map>
    Then berth '<lB1>' in train describer '<lBTD>' contains '<lTD1>' and is visible
    When I use the secondary mouse on last berth <TDandBerthId1>
    Then the user is presented with a list of the last '1' services that have 'finished at' this berth
      | serviceDescription | operatorCode | punct      | eventDateTime |
      | 2B71               | (EF)         | -1m or -2m | now + 0       |

    # Open the timetable
    And I use the primary mouse on train '2B71'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the tab title is '2B71 TMV Timetable'
    When I wait for the last Signal to populate
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId       | lastTJM | headCode   |
      | LTP       | TLMBE      |            | <planningUID> | 702B71MHtoday |         | 2B71       |

    Examples:
      | cifFile                                              | map          | lBTD | lB1  | lTD1 | TDandBerthId1 | planningUID |
      | access-plan/34080-schedules/2B51-MDNHEAD-BORNEND.cif | gw2aslough.v | D6   | LMBE | 2B71 | D6LMBE        | generated   |

  Scenario: 34080-2b Last Berth (Select Timetable) - unmatched trains
    # Inject stepping
    When the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B72             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B72             |

    # Check the last berth
    And I am viewing the map gw2aslough.v
    Then berth 'LMBE' in train describer 'D6' contains '2B72' and is visible
    When I click on the map for train 2B72
    When I use the secondary mouse on last berth D6LMBE
    And I use the primary mouse on train '2B72'
      Then the tab title contains 'TMV Map GW2A'

  Scenario Outline: 34080-3 and 34080-4 Last Berth - response times for secondary click and select timetable
    * I delete 'C56473:today' from hash 'schedule-modifications-today'
    * I remove today's train 'C56473' from the trainlist

    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath  | refLocation  | refTimingType | newTrainDescription | newPlanningUid |
      | <cifFile> | MDNHEAD      | WTT_dep       | 2B73                | C56473         |
    * I wait until today's train 'C56473' has loaded
    * the following train activation message is sent from LINX
      | trainUID   | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | C56473     | 2B73        | now                    | 99999               | MDNHEAD                | today         |

    # Inject stepping
    When the following live berth interpose messages are sent from LINX (setting up matches)
      | toBerth | trainDescriber | trainDescription |
      | 0581    | D6             | 2B73             |
    * the following live berth step messages are sent from LINX (moving through last berth)
      | fromBerth | toBerth | trainDescriber | trainDescription |
      | 0581      | LMBE    | D6             | 2B73             |

    # Check that trains have loaded
    And I am on the trains list page 1
    And I save the trains list config
    * train '2B73' with schedule id 'C56473' for today is visible on the trains list

    # Check the last berth
    And I am viewing the map <map>
    Then berth '<lB1>' in train describer '<lBTD>' contains '<lTD1>' and is visible
    When I start the stopwatch
    And I use the secondary mouse on last berth <TDandBerthId1>
    Then the user is presented with a list of the last '1' services that have 'finished at' this berth
      | serviceDescription | operatorCode | punct                    | eventDateTime |
      | 2B73               | (EF)         | -2m or -1m or -0m or +0m or +1m | now + 0       |
    When I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds

    # Open the timetable
    When I reset the stopwatch
    And I start the stopwatch
    And I use the primary mouse on train '2B73'
    Then the number of tabs open is 2
    When I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '500' milliseconds
    When I switch to the new tab
    Then the tab title is '2B73 TMV Timetable'
    When I wait for the last Signal to populate
    Then The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid      | trustId       | lastTJM | headCode   |
      | LTP       | TLMBE      |            | C56473        | 702B73MHtoday |         | 2B73       |

    Examples:
      | cifFile                                              | map          | lBTD | lB1  | lTD1 | TDandBerthId1 |
      | access-plan/34080-schedules/2B51-MDNHEAD-BORNEND.cif | gw2aslough.v | D6   | LMBE | 2B73 | D6LMBE        |
