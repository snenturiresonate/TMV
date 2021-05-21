Feature: 33755 - TMV Highlight Train

  As a TMV User
  I want the ability to highlight a train
  So that I can track or identify a train that may require operational intervention

  Background:
    * I remove all trains from the trains list
    * I am viewing the map hdgw01paddington.v
    * I have cleared out all headcodes

  @blp
  Scenario Outline: 33755-1a, 2a Highlight Train (Menu) - Berth Interpose
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user selects a train for highlighting using the secondary mouse click
    #Then the user is presented with an option to highlight/unhighlight the train
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif    | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>         |
    And I am on the trains list page
    Then the following service is displayed on the trains list
      | trainId            | trainUId      |
      | <trainDescription> | <planningUid> |
    When the following berth interpose message is sent from LINX (creating a match)
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | <berth>   | <trainDescriber>   | <trainDescription> |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When I wait for the Open timetable option for train description <trainDescription> in berth <berth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><berth>'
    Then the menu is displayed with 'Highlight' option
    When I click on 'Highlight' link
    Then the train in berth '<trainDescriber><berth>' is highlighted
    When I right click on berth with id '<trainDescriber><berth>'
    Then the menu is displayed with 'Unhighlight' option

    Examples:
    | trainDescription | planningUid | trainDescriber | berth |
    | 5B11             | B53311      | D3             | A001  |
    | 5C11             | C53311      | D3             | A007  |

  @blp
  Scenario Outline: 33755-1b, 2b Highlight Train (Menu) - Berth Interpose and Step
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user selects a train for highlighting using the secondary mouse click
    #Then the user is presented with an option to highlight/unhighlight the train
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif    | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>         |
    And I am on the trains list page
    Then the following service is displayed on the trains list
      | trainId            | trainUId      |
      | <trainDescription> | <planningUid> |
    When the following berth interpose message is sent from LINX (creating a match)
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | <berth>      | <trainDescriber>   | <trainDescription> |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth       | trainDescriber   | trainDescription   |
      | 09:59:00  | <berth>   | <secondBerth> | <trainDescriber> | <trainDescription> |
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When I wait for the Open timetable option for train description <trainDescription> in berth <secondBerth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><secondBerth>'
    Then the menu is displayed with 'Highlight' option
    When I click on 'Highlight' link
    Then the train in berth '<trainDescriber><secondBerth>' is highlighted
    When I right click on berth with id '<trainDescriber><secondBerth>'
    Then the menu is displayed with 'Unhighlight' option

    Examples:
      | trainDescription | planningUid | trainDescriber | berth | secondBerth |
      | 5B12             | B53312      | D3             | A001  | 6003        |
      | 5C12             | C53312      | D3             | A007  | 0039        |






  Scenario: 33755-2d Highlight Train (Headcode) - Berth Interpose same headcode for two different berths
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A001      | D3 		             | 1D34 		          |
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | C001      | D3 		             | 1D34 		          |
    And I right click on berth with id 'D3A001'
    And the berth context menu is displayed with berth name '1D34'
    And the headcode displayed for 'D3A001' is R001
    And the train headcode color for berth 'D3A001' is stone
    And the menu is displayed with 'Highlight' option
    When I click on 'Highlight' link
    Then the train highlight color for berth 'D3A001' is 'XXXXXX'
    And the train highlight color for berth 'D3A003' is 'grey'


  Scenario: 33755-3a Unhighlight Train (Menu) - Berth Interpose
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user selects a train for highlighting using the secondary mouse click
    #Then the user is presented with an option to highlight/unhighlight the train
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A001      | D3 		             | 1D34 		          |
    And I right click on berth with id 'D3A001'
    And the berth context menu is displayed with berth name '1D34'
    And the train headcode color for berth 'D3A001' is stone
    And the menu is displayed with 'Highlight' option
    And I click on 'Highlight' link
    And the train highlight color for berth 'D3A001' is 'XXXXXX'
    And I right click on berth with id 'D3A001'
    Then the menu is displayed with 'Unhighlight' option
    And I click on 'Unhighlight' link
    #And the train highlight color for berth 'D3A001' is removed

  Scenario: 33755-3b Unhighlight Train (Menu) - Berth Interpose and Step
    #Given the user is viewing a live schematic map
    #And there are services running
    #And a service is highlighted
    #When the user has opts to unhighlight the train
    #Then the train is highlighting is removed
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    And berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    And the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099     | 0115    | D3            | 1G69             |
    And berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '1G69' and is visible
    And I right click on berth with id 'D30115'
    And the menu is displayed with 'Highlight' option
    And I click on 'Highlight' link
    And the train highlight color for berth 'D30115' is stone
    Then the menu is displayed with 'Unhighlight' option
    And I click on 'Unhighlight' link
    #And the train highlight color for berth 'D3A001' is removed
