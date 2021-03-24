@tdd
Feature: 34080 - Last Berth

  As a TMV User
  I want to view trains that have reached the last berth
  So that I see the last 10 trains that have reached a particular location

  Scenario Outline: 34080-1a Last Berth (Secondary Click) - less than 10
#    Given the user is viewing a live schematic map
#    And there are services running
#    When the user views a last berth containing a service
#    And performs a secondary click on the last berth
#    Then the user is presented with a list of the last services that have finished at this berth

    Given the access plan located in CIF file '<cifFile>' is received from LINX
    And the following berth interpose messages are sent from LINX (setting up matches)
      | timeStamp | toBerth | trainDescriber | trainDescription |
      | 10:40:00  | 0581    | D6             | 2B51             |
      | 11:40:00  | 0581    | D6             | 2B53             |
      | 12:40:00  | 0581    | D6             | 2B55             |
      | 13:40:00  | 0581    | D6             | 2B57             |
    And the following berth step messages are sent from LINX (moving through last berth)
      | fromBerth | timeStamp | toBerth | trainDescriber | trainDescription |
      | 0581      | 10:43:00  | LMBE    | D6             | 2B51             |
      | 0581      | 11:45:00  | LMBE    | D6             | 2B53             |
      | 0581      | 12:50:00  | LMBE    | D6             | 2B55             |
      | 0581      | 13:50:00  | MDES    | D6             | 2B57             |
    When I am viewing the map <map>
    And berth '<lB1>' in train describer '<lBTD>' contains '<lTD1>' and is visible
    And berth '<lB2>' in train describer '<lBTD>' contains '<lTD2>' and is visible
    And I use the secondary mouse on last berth <TDandBerthId1>
    Then the user is presented with a list of the last '<numTrains1>' services that have finished at this berth
      | serviceDescription | operatorCode | punct   | arrivalTime | arrivalDate |
      | 2B55               | GW           | +7m     | 12:50:00    | today       |
      | 2B53               | GW           | +2m     | 11:45:00    | today       |
      | 2B51               | GW           | on time | 10:43:00    | today       |
    And the records in the last berth service list are in reverse date-time order
    When I use the secondary mouse on last berth <TDandBerthId2>
    Then the user is presented with a list of the last '<numTrains2>' services that have finished at this berth
      | serviceDescription | operatorCode | punct   | arrivalTime | arrivalDate |
      | 2B57               |              | unknown | 13:50:00    | today       |

    Examples:
      | cifFile                     | map          | lBTD | lB1  | lTD1 | TDandBerthId1 | numTrains1 | lB2  | lTD2 | TDandBerthId2 | numTrains2 |
      | schedules_to_bourne_end.cif | gw2aslough.v | D6   | LMBE | 2B55 | D6LMBE        | 3          | MDES | 2B55 | D6MDES        | 1          |

  Scenario Outline: 34080-1b Last Berth (Secondary Click) - more than 10
    Given the access plan located in CIF file '<cifFile>' is received from LINX
    And the following berth interpose messages are sent from LINX (setting up matches)
      | timeStamp | toBerth | trainDescriber | trainDescription |
      | 07:00:30  | SBUP    | D5             | 1W12             |
      | 08:13:00  | SBUP    | D5             | 1W14             |
      | 08:59:00  | SBUP    | D5             | 1W16             |
      | 09:32:00  | SBUP    | D5             | 1W00             |
      | 11:33:30  | SBUP    | D5             | 1W01             |
      | 12:33:30  | SBUP    | D5             | 1W23             |
      | 13:31:30  | SBUP    | D5             | 1W25             |
      | 14:27:30  | SBUP    | D5             | 1W27             |
      | 16:59:00  | SBUP    | D5             | 1W32             |
      | 17:34:30  | SBUP    | D5             | 1W33             |
      | 18:25:00  | SBUP    | D5             | 1W02             |
      | 18:59:00  | SBUP    | D5             | 1W36             |
      | 19:42:30  | SBUP    | D5             | 1W03             |
      | 20:31:00  | SBUP    | D5             | 1W04             |
      | 21:32:30  | SBUP    | D5             | 1W39             |
      | 23:04:30  | SBUP    | D5             | 1W42             |
    And the following berth step messages are sent from LINX (moving through last berth)
      | fromBerth | timeStamp | toBerth | trainDescriber | trainDescription |
      | SBUP      | 07:02:30  | A407    | D5             | 1W12             |
      | SBUP      | 08:18:00  | A407    | D5             | 1W14             |
      | SBUP      | 09:00:00  | A407    | D5             | 1W16             |
      | SBUP      | 09:34:00  | A407    | D5             | 1W00             |
      | SBUP      | 11:35:00  | A407    | D5             | 1W01             |
      | SBUP      | 12:37:30  | A407    | D5             | 1W23             |
      | SBUP      | 13:32:00  | A407    | D5             | 1W25             |
      | SBUP      | 14:31:00  | A407    | D5             | 1W27             |
      | SBUP      | 17:19:30  | A407    | D5             | 1W32             |
      | SBUP      | 17:36:00  | A407    | D5             | 1W33             |
      | SBUP      | 18:31:00  | A407    | D5             | 1W02             |
      | SBUP      | 19:01:00  | A407    | D5             | 1W36             |
      | SBUP      | 19:45:00  | A407    | D5             | 1W03             |
      | SBUP      | 20:33:00  | A407    | D5             | 1W04             |
      | SBUP      | 21:33:00  | A407    | D5             | 1W39             |
      | SBUP      | 23:56:00  | A407    | D5             | 1W42             |
    When I am viewing the map <map>
    And berth '<lastBerth>' in train describer '<lastBerthTD>' contains '<lastTrainDesc>' and is visible
    And I use the secondary mouse on last berth <TDandBerthId>
    Then the user is presented with a list of the last '<numberTrains>' services that have finished at this berth
      | serviceDescription | operatorCode | punct   | arrivalTime | arrivalDate |
      | 1W42               | GW           | +50m    | 23:04:30    | today       |
      | 1W39               | GW           | -1m     | 21:32:30    | today       |
      | 1W04               | GW           | on time | 20:31:00    | today       |
      | 1W03               | GW           | +1m     | 19:42:30    | today       |
      | 1W36               | GW           | on time | 18:59:00    | today       |
      | 1W02               | GW           | +4m     | 18:29:00    | today       |
      | 1W33               | GW           | on time | 17:36:00    | today       |
      | 1W32               | GW           | +18m    | 17:19:30    | today       |
      | 1W27               | GW           | +2m     | 14:31:00    | today       |
      | 1W25               | GW           | -1m     | 13:32:00    | today       |
    And the records in the last berth service list are in reverse date-time order

    Examples:
      | cifFile                      | map          | numberTrains | lastBerth | lastBerthTD | lastTrainDesc | TDandBerthId |
      | schedules_via_hanborough.cif | gw4aoxford.v | 10           | A407      | D5          | 1W42          | D5A407       |

  Scenario Outline: 34080-1c Last Berth (Secondary Click) - list updates in real time and terminations get removed
    Given the access plan located in CIF file '<cifFile>' is received from LINX
    And the following berth interpose messages are sent from LINX (setting up matches)
      | timeStamp | toBerth | trainDescriber | trainDescription |
      | 06:09:00  | LD36    | PH             | 1C99             |
      | 06:45:30  | LD36    | PH             | 1C09             |
      | 11:38:00  | LD36    | PH             | 1C04             |
      | 13:12:00  | LD36    | PH             | 1X35             |
      | 16:27:00  | LD36    | PH             | 2C48             |
      | 18:46:00  | LD36    | PH             | 2C74             |
      | 17:21:00  | LD36    | PH             | 2C50             |
      | 19:19:00  | LD36    | PH             | 1V58             |
      | 20:07:00  | LD36    | PH             | 1V60             |
    And the following berth step messages are sent from LINX (moving through last berth)
      | fromBerth | timeStamp | toBerth | trainDescriber | trainDescription |
      | LD36      | 06:09:06  | LD35    | D5             | 1C99             |
      | LD36      | 06:45:46  | LD35    | D5             | 1C09             |
      | LD36      | 11:38:30  | LD35    | D5             | 1C04             |
      | LD36      | 13:12:30  | LD35    | D5             | 1X35             |
      | LD36      | 16:28:00  | LD35    | D5             | 2C48             |
      | LD36      | 18:47:00  | LD35    | D5             | 2C74             |
      | LD36      | 17:22:00  | LD35    | D5             | 2C50             |
      | LD36      | 19:19:10  | LD35    | D5             | 1V58             |
      | LD36      | 20:07:12  | LD35    | D5             | 1V60             |
    And I make a note that last berth data has been loaded for '<TDandBerthId>'
    When I am viewing the map <map>
    And berth '<lastBerth>' in train describer '<lastBerthTD>' contains '<lastTrainDesc>' and is visible
    And I use the secondary mouse on last berth <TDandBerthId>
    Then the user is presented with a list of the last '9' services that have finished at this berth
      | serviceDescription | operatorCode | punct   | arrivalTime | arrivalDate |
      | 1V60               | XC           | on time | 20:07       | today       |
      | 1V58               | XC           | on time | 19:19       | today       |
      | 2C50               | GW           | on time | 17:22       | today       |
      | 2C74               | GW           | on time | 18:47       | today       |
      | 2C48               | GW           | on time | 16:28       | today       |
      | 1X35               | unknown      | unknown | 13:12       | today       |
      | 1C04               | GW           | on time | 11:38       | today       |
      | 1C09               | XC           | on time | 06:45       | today       |
      | 1C99               | GW           | on time | 06:09       | today       |
    And the records in the last berth service list are in reverse date-time order
    When the following train running information message are sent from LINX
      | trainUID | trainNumber | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            |
      | V95541   | 2C48        | today              | 85734               | PENZNCE                | Arrival at Destination |
      | V95541   | 1C99        | yesterday          | 85734               | PENZNCE                | Arrival at Destination |
    And I use the secondary mouse on last berth lastBerth
    Then the user is presented with a list of the last '7' services that have finished at this berth
      | serviceDescription | operatorCode | punct   | arrivalTime | arrivalDate |
      | 1V60               | XC           | on time | 20:07       | today       |
      | 1V58               | XC           | on time | 19:19       | today       |
      | 2C50               | GW           | on time | 17:22       | today       |
      | 2C74               | GW           | on time | 18:47       | today       |
      | 1X35               | unknown      | unknown | 13:12       | today       |
      | 1C04               | GW           | on time | 11:38       | today       |
      | 1C09               | XC           | on time | 06:45       | today       |
    When the following berth interpose messages are sent from LINX (setting up matches)
      | timeStamp | toBerth | trainDescriber | trainDescription |
      | 21:41:00  | LD36    | PH             | 1C92             |
    And the following berth step messages are sent from LINX (moving through last berth)
      | fromBerth | timeStamp | toBerth | trainDescriber | trainDescription |
      | LD36      | 21:42:00  | LD35    | D5             | 1C92             |
    Then berth '<lastBerth>' in train describer '<lastBerthTD>' contains '1C92' and is visible
    And I use the secondary mouse on last berth <TDandBerthId>
    Then the user is presented with a list of the last '8' services that have finished at this berth
      | serviceDescription | operatorCode | punct   | arrivalTime | arrivalDate |
      | 1C92               | GW           | on time | 21:42       | today       |
      | 1V60               | XC           | on time | 20:07       | today       |
      | 1V58               | XC           | on time | 19:19       | today       |
      | 2C50               | GW           | on time | 17:22       | today       |
      | 2C74               | GW           | on time | 18:47       | today       |
      | 1X35               | unknown      | unknown | 13:12       | today       |
      | 1C04               | GW           | on time | 11:38       | today       |
      | 1C09               | XC           | on time | 06:45       | today       |

    Examples:
      | cifFile                   | map              | lastBerth | lastBerthTD | lastTrainDesc | TDandBerthId |
      | schedules_to_penzance.cif | hdgw09penzance.v | LD35      | PH          | 1V60          | PHLD35       |


  Scenario Outline: 34080-2a Last Berth (Select Timetable) - matched trains
#    Given the user is viewing a live schematic map
#    And there are services running
#    And performs a secondary click on the last berth
#    When the user views a list of the last services that have finished at this berth
#    And performs a primary click on a train
#    Then the user is presented with the timetable in a new tab
    Given Last berth data has been loaded for '<TDandBerthId>'
    When I am viewing the map <map>
    And I use the secondary mouse on last berth <TDandBerthId>
    And I use the primary mouse on train '<trainNum1>'
    And I switch to the new tab
    Then the tab title contains '<trainNum1>'
    And the timetable header train description is '<trainNum1>'
    And The values for the header properties are as follows
      | schedType    | lastSignal | lastReport | trainUid       | trustId | lastTJM | headCode    |
      | <schedType1> |            |            | <planningUid1> |         |         | <trainNum1> |
    When I switch to the second-newest tab
    And I use the secondary mouse on last berth <TDandBerthId>
    And I use the primary mouse on train 'trainNum2'
    Then the tab title contains '<trainNum2>'
    And the timetable header train description is '<trainNum2>'
    And The values for the header properties are as follows
      | schedType    | lastSignal | lastReport | trainUid       | trustId | lastTJM | headCode    |
      | <schedType2> |            |            | <planningUid2> |         |         | <trainNum2> |

    Examples:
      | map              | TDandBerthId | trainNum1 | planningUid1 | schedType1 | trainNum2 | planningUid2 | schedType2 |
      | hdgw09penzance.v | PHLD35       | 2C50      | C56594       | LTP        | 1C09      | C11729       | VAR        |

  Scenario Outline: 34080-2b Last Berth (Select Timetable) - unmatched trains
    Given Last berth data has been loaded for '<TDandBerthId>'
    When I am viewing the map <map>
    And I use the secondary mouse on last berth <TDandBerthId>
    And I use the primary mouse on train '<trainNum>'
    Then no new tab is launched

    Examples:
      | map              | TDandBerthId | trainNum |
      | hdgw09penzance.v | PHLD35       | 1X35     |
