Feature: 34082 - Manual TRUST Berths

  As a TMV dev team member
  I want end to end tests to be created for the Manual Trust Berth functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  Background:
    * I clear all MTBs
    * I generate a new train description
    * I generate a new trainUID

  Scenario Outline: 34082-1 Manual Trust Berth - secondary click
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user views an MTB
    #And performs a secondary click on the MTB
    #Then the user is presented with a list of the last services that have been interposed into the MTB
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | ORMSKRK     | WTT_dep       | <trainDescription>  | <trainUID>     |
    And I wait until today's train '<trainUID>' has loaded
    And I am viewing the map nw05sandhillsnl.v
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | delay | hourDepartFromOrigin |
      | <trainUID> | <trainDescription> | today              | 85621               | RUFDORD                | Departure from Station | 00:01 | now                  |
    And headcode '<trainDescription>' is present in manual-trust berth '30155U'
    When I use the secondary mouse on manual-trust berth 30155U
    Then the user is presented with a list of the last 1 service that has arrived at this manual trust berth
      | trainDescription   | operator | punctuality | time |
      | <trainDescription> | (ED)     | +1m         | now  |

    Examples:
      | cif                                     | trainUID  | trainDescription |
      | access-plan/34082-schedules/60651-1.cif | generated | generated        |

  Scenario Outline: 34082-2 Manual Trust Berth - select timetable - primary click
    #Given the user is viewing a live schematic map
    #And there are services running
    #And performs a secondary click on the MTB
    #When the user views a list of the last services that have been interposed into the MTB
    #And performs a primary click on a train
    #Then the user is presented with the timetable in a new tab
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | ORMSKRK     | WTT_dep       | <trainDescription>  | <trainUID>     |
    And I wait until today's train '<trainUID>' has loaded
    And I am viewing the map nw05sandhillsnl.v
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | delay | hourDepartFromOrigin |
      | <trainUID> | <trainDescription> | today              | 85621               | RUFDORD                | Departure from Station | 00:01 | now                  |
    And headcode '<trainDescription>' is present in manual-trust berth '30155U'
    And I use the secondary mouse on manual-trust berth 30155U
    When I use the primary mouse on manual TRUST berth train <trainDescription>
    And I switch to the new tab
    Then the tab title is '<trainDescription> TMV Timetable'
    And The values for the header properties are as follows
      | schedType | lastSignal | lastReport | trainUid   | trustId | lastTJM | headCode           |
      | LTP       |            |            | <trainUID> |         |         | <trainDescription> |

    Examples:
      | cif                                     | trainUID  | trainDescription |
      | access-plan/34082-schedules/60651-1.cif | generated | generated        |

  Scenario Outline: 34082-3 Manual Trust Berth - arrival
    #Given the user is viewing a live schematic map
    #And there are services running
    #And an arrival MTB is on the map
    #When the services that have been interposed into the MTB
    #Then the services are displayed in a stack and a particular direction
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | WIGANWL     | WTT_arr       | <trainDescription>  | <trainUID>     |
    And I wait until today's train '<trainUID>' has loaded
    And I am viewing the map NW10warringtonpsb.v
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | delay | hourDepartFromOrigin |
      | <trainUID> | <trainDescription> | today              | 24060               | WIGANWL                | Arrival at Station     | 00:01 | now                  |
    And headcode '<trainDescription>' is present in manual-trust berth '35111A'
    When I use the secondary mouse on manual-trust berth 35111A
    Then the user is presented with a list of the last 1 service that has arrived at this manual trust berth
      | trainDescription   | operator | punctuality | time |
      | <trainDescription> | (ED)     | +1m         | now  |
    And the manual trust berth type for 35111A is ARR

    Examples:
      | cif                                                          | trainUID  | trainDescription |
      | access-plan/manual-trust-berth/passing_wigan_arrival_mtb.cif | generated | generated        |

  Scenario Outline: 34082-4 Manual Trust Berth Departure
    #Given the user is viewing a live schematic map
    #And there are services running
    #And a departure MTB is on the map
    #When the services that have been interposed into the MTB
    #Then the services are displayed in a stack and a particular direction
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | ORMSKRK     | WTT_dep       | <trainDescription>  | <trainUID>     |
    And I wait until today's train '<trainUID>' has loaded
    And I am viewing the map nw05sandhillsnl.v
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | delay | hourDepartFromOrigin |
      | <trainUID> | <trainDescription> | today              | 85621               | RUFDORD                | Departure from Station | 00:01 | now                  |
    And headcode '<trainDescription>' is present in manual-trust berth '30155U'
    When I use the secondary mouse on manual-trust berth 30155U
    Then the user is presented with a list of the last 1 service that has arrived at this manual trust berth
      | trainDescription   | operator | punctuality | time |
      | <trainDescription> | (ED)     | +1m         | now  |
    And the manual trust berth type for 30155U is DEP

    Examples:
      | cif                                     | trainUID  | trainDescription |
      | access-plan/34082-schedules/60651-1.cif | generated | generated        |

  Scenario Outline: 34082- 5 Manual Trust Berth (Off Route)
    #Given the user is viewing a live schematic map
    #And there are services running
    #And an off route MTB is on the map
    #When the services that have been interposed into the MTB
    #Then the services are displayed in a stack and a particular direction
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | WIGANWL     | WTT_arr       | <trainDescription>  | <trainUID>     |
    And I wait until today's train '<trainUID>' has loaded
    And I am viewing the map NW10warringtonpsb.v
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            | delay | hourDepartFromOrigin |
      | <trainUID> | <trainDescription> | today              | 24060               | WIGANWL                | Departure from Station | 00:01 | now                  |
    And headcode '<trainDescription>' is present in manual-trust berth '35111X'
    When I use the secondary mouse on manual-trust berth 35111X
    Then the user is presented with a list of the last 1 service that has arrived at this manual trust berth
      | trainDescription   | operator | punctuality | time |
      | <trainDescription> | (ED)     | +1m         | now  |
    And the manual trust berth type for 35111X is O/R

    Examples:
      | cif                                                                  | trainUID  | trainDescription |
      | access-plan/manual-trust-berth/passing_wigan_mtb_unexpected_next.cif | generated | generated        |
