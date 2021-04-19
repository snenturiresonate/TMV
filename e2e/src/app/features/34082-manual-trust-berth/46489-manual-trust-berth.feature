@tdd
Feature: 34082 - Manual TRUST Berths

  As a TMV dev team member
  I want end to end tests to be created for the Manual Trust Berth functionality
  So that there is confidence that it continues to work as expected as more of the system is developed

  Background:
    Given the access plan located in CIF file 'schedules_to_penzance_mtb.cif' is received from LINX
    And I am viewing the map 'gw19penzance.v'

  Scenario: 34082-1a MTB (Secondary Click - less than 9 services)
  #Given the user is viewing a live schematic map
  #And there are services running
  #When the user views an MTB
  #And performs a secondary click on the MTB
  #Then the user is presented with a list of the last services that have been interposed into the MTB
    When the following train running info message with time is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode| messageType                | timeInfo  |
      | 555292       | 2D04               | today              | 85621                | CBORRXO               |Departure from Origin       |20:55      |
      | 117342       | 2D02               | today              | 85621                | CBORR10               |Departure from Origin       |21:43      |
      | 117322       | 2D08               | today              | 85621                | CBORRXO               |Departure from Origin       |20:54      |
    And the manual trust berth is shown
    And I use the secondary mouse on manual-trust berth '85622U'
    Then the user is presented with a list of the last '3' services that have 'interposed into (in chronological order)' this berth
      | serviceDescription | operatorCode | punct   | arrivalTime |
      | 2D02               | GW           | 1E      | 21:43:00    |
      | 2D04               | GW           | 1E      | 20:55:00    |
      | 2D08               | GW           | 1E      | 20:54:00    |


  Scenario: 34082-1b MTB (Secondary Click - 9 services)
  #Given the user is viewing a live schematic map
  #And there are services running
  #When the user views an MTB
  #And performs a secondary click on the MTB
  #Then the user is presented with a list of the last services that have been interposed into the MTB
     When the following train running info message with time is sent from LINX
       | trainUid | trainNumber      | scheduledStartDate       | locationPrimaryCode  |locationSubsidiaryCode |messageType                 |timeInfo   |
       | 539721   | 2C44             | today                    | 85621                | CBORRXO               |Departure from Origin       |18:13      |
       | 565922   | 2C48             | today                    | 85621                | CBORRXO               |Departure from Origin       |18:08      |
       | 117342   | 2D02             | today                    | 85621                | CBORR10               |Departure from Origin       |21:43      |
       | 566142   | 2C74             | today                    | 85621                | CBORRXO               |Departure from Origin       |17:36      |
       | 555132   | 2C70             | today                    | 85621                | CBORR10               |Departure from Origin       |17:10      |
       | 555292   | 2D04             | today                    | 85621                | CBORRXO               |Departure from Origin       |20:55      |
       | 117322   | 2D08             | today                    | 85621                | CBORRXO               |Departure from Origin       |20:54      |
       | 565941   | 2D26             | today                    | 85621                | CBORRXO               |Departure from Origin       |19:36      |
       | 117292   | 2D30             | today                    | 85621                | CBORRXO               |Departure from Origin       |18:52      |
       | 565942   | 2C60             | today                    | 85621                | CBORR10               |Departure from Origin       |18:04      |
       | 117292   | 2C60             |  today                   | 85621                | CBORR10               |Departure from Origin      |16:16      |
    And the manual trust berth is shown
    And I use the secondary mouse on manual-trust berth '85622U'
    Then the user is presented with a list of the last '9' services that have 'interposed into (in chronological order)' this berth
      | serviceDescription | operatorCode | punct   | arrivalTime |
      | 2D02               | GW           | 1E      | 21:43:00    |
      | 2D04               | GW           | 1E      | 20:55:00    |
      | 2D08               | GW           | 1E      | 20:54:00    |
      | 2D26               | GW           | 1E      | 19:36:00    |
      | 2D30               | GW           | 1E      | 18:52:00    |
      | 2C44               | GW           | 2E      | 18:13:00    |
      | 2C48               | GW           | 1E      | 18:08:00    |
      | 2C60               | GW           | 1E      | 18:04:00    |
      | 2C74               | GW           | 1E      | 17:36:00    |
      | 2C60               | GW           | 2E      | 16:16:00    |

  Scenario: 34082-2a Manual Trust Berth (Select Timetable) - matched trains
    #Given the user is viewing a live schematic map
    #And there are services running
    #And performs a secondary click on the MTB
    #When the user views a list of the last services that have been interposed into the MTB
    #And performs a primary click on a train
    #Then the user is presented with the timetable in a new tab
   When the following train running info message with time is sent from LINX
     | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType                       | timeInfo       |
     | 555292       | 2D04               | today              | 85621                | CBORRXO               |Departure from Origin       |20:55      |
    And the manual trust berth is shown
    And I use the secondary mouse on manual-trust berth '85622U'
    And I use the primary mouse on train '2D04'
    And I switch to the new tab
    And the tab title contains '2D04'
    And the timetable header train description is '2D04'
    Then The values for the header properties are as follows
      | schedType    | lastSignal | lastReport | trainUid       | trustId | lastTJM | headCode           |
      | LTP          |            |            | 555292         |         |         | 2D04               |

  Scenario: 34080-2b Manual Trust Berth (Select Timetable) - unmatched trains
    When the following train running info message with time is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType                       | timeInfo       |
      | 539721       | 1X35               |  today             | 85511                | PRYN                    | Departure from Origin             |13:13           |
    And the manual trust berth is shown
    And I use the secondary mouse on manual-trust berth '85511U'
    And I use the primary mouse on train '1X35'
    Then no new tab is launched

  Scenario: 34082-3 Manual Trust Berth Arrival
    #Given the user is viewing a live schematic map
    #And there are services running
    #And an arrival MTB is on the map
    #When the services that have been interposed into the MTB
    #Then the services are displayed in a stack and a particular direction
    When the following train running info message with time is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType         | timeInfo       |
      | 565932       | 2C91               |  today             | 85734                | PENZNCE                 | Arrival at Station  |18:04           |
      | 565931       | 2C90               |  today             | 85734                | PENZNCE                 | Arrival at Station  |18:04           |
    And the manual trust berth is shown
    And I use the secondary mouse on manual-trust berth '85734A'
    Then the user is presented with a list of the last '2' services that have 'interposed into (in chronological order)' this berth
      | serviceDescription | operatorCode | punct   | arrivalTime |
      | 2C91               | GW           | 1E      | 18:04:00    |
      | 2C90               | GW           | 1E      | 18:04:00    |
    #And the following berths are displayed as stack
    #|2C91|
    #|2C90|
    And the manual trust berth type for '85734A' is 'ARR'
    #Then the punctuality color for service 'Arrival MTB ' in MTB stack at berth '2C91' is 'stonecolor'))
    And the punctuality color for berth '2C91' is 'stonecolor'
    And the punctuality color for berth '2C90' is 'stonecolor'

  Scenario: 34082-4 Manual Trust Berth Departure
    #Given the user is viewing a live schematic map
    #And there are services running
    #And a departure MTB is on the map
    #When the services that have been interposed into the MTB
    #Then the services are displayed in a stack and a particular direction
    When the following train running info message with time is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType             | timeInfo       |
      | 565922       | 2C48               |  today             | 85734                | PENZNCE                 | Departure from Origin   |18:08           |
      | 565941       | 2D26               |  today             | 85734                | PENZNCE                 | Departure from Origin   |19:36           |
    And the manual trust berth is shown
    And I use the secondary mouse on manual-trust berth '85734U'
    Then the user is presented with a list of the last '2' services that have 'interposed into (in chronological order)' this berth
      | serviceDescription | operatorCode | punct   | arrivalTime |
      | 2D26               | GW           | 1E      | 19:36:00    |
      | 2C48               | GW           | 1E      | 18:08:00    |
    #And the following berth are displayed as stack
      #|2D26|
      #|2C48|
    And the manual trust berth type for '85734U' is 'DEP'

  Scenario: 34082- 5 Manual Trust Berth (Off Route)
    #Given the user is viewing a live schematic map
    #And there are services running
    #And an off route MTB is on the map
    #When the services that have been interposed into the MTB
    #Then the services are displayed in a stack and a particular direction
    When the following train running info message with time is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType                       | timeInfo       |
      | 565932       | 2C91               |  today             | 84139                | PLYMTH                  | Departure from Origin             |15:57           |
      | 565932       | 2C91               |  today             | 84199                | DEVNPRT                 | Departure from Origin             |16:00           |
      | 565932       | 2C91               |  today             | 85601                | REDRUTH                 | Departure from Origin             |17:35           |
    And the manual trust berth is shown
    And I use the secondary mouse on manual-trust berth '85622U'
    Then the manual trust berth type for '85622U' is 'O/R'
