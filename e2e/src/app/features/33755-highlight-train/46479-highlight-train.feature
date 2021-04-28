@tdd
Feature: 33755 - TMV Highlight Train

  As a TMV User
  I want the ability to highlight a train
  So that I can track or identify a train that may require operational intervention

  Background:
    Given I am viewing the map hdgw01paddington.v
    And I have cleared out all headcodes

  Scenario: 33755-1a Highlight Train (Menu) - Berth Interpose
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user selects a train for highlighting using the secondary mouse click
    #Then the user is presented with an option to highlight/unhighlight the train
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A001      | D3 		             | 1D34 		          |
    And I right click on berth with id 'D3A001'
    And the berth context menu is displayed with berth name '1D34'
    And the headcode displayed for 'D3A001' is R001
    And the train headcode color for berth 'D3A001' is stone
    Then the menu is displayed with 'Highlight' option


  Scenario: 33755-1b Highlight Train (Menu) - Berth Interpose and Step
    When the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    And berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    And the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | 0115    | D3            | 1G69             |
    And berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '1G69' and is visible
    And I right click on berth with id 'D30115'
    Then the menu is displayed with 'Highlight' option

  Scenario: 33755-1c Highlight Train (Menu) - Matched services
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F21                | L00001         |
    And I see todays schedule for 'L00001' has loaded by looking at the timetable page
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | 1F21             |
    And the headcode displayed for 'A007' is 1F21
    And the train headcode color for berth 'D3A007' is green
    Then the menu is displayed with 'Highlight' option

  Scenario: 33755-2a Highlight Train (Headcode) - Berth Interpose
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user has opted to highlight a train
    #Then the train is highlighted (latest) until the headcode is removed from all maps (open or not)
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth   | trainDescriber     | trainDescription   |
      | 10:02:06  | A001      | D3 		             | 1D34 		          |
    And I right click on berth with id 'D3A001'
    And the berth context menu is displayed with berth name '1D34'
    And the headcode displayed for 'D3A001' is R001
    And the train headcode color for berth 'D3A001' is stone
    And the menu is displayed with 'Highlight' option
    When I click on 'Highlight' link
    Then the train highlight color for berth 'D3A001' is 'XXXXXX'

  Scenario: 33755-2b Highlight Train (Headcode) - Berth Interpose and Step
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099    | D3            | 1G69             |
    And berth '0099' in train describer 'D3' contains '1G69' and is visible
    And berth '0115' in train describer 'D3' contains '' and is visible
    And the following berth step message is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber| trainDescription |
      | 09:59:00  | 0099      | 0115    | D3            | 1G69             |
    And berth '0099' in train describer 'D3' contains '' and is visible
    And berth '0115' in train describer 'D3' contains '1G69' and is visible
    And I right click on berth with id 'D30115'
    And the menu is displayed with 'Highlight' option
    When I click on 'Highlight' link
    Then the train highlight color for berth 'D30115' is 'XXXXXX'

  Scenario: 33755-2c Highlight Train (Headcode) - Matched services
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F21                | L00001         |
    And I see todays schedule for 'L00001' has loaded by looking at the timetable page
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | 1F21             |
    And the headcode displayed for 'A007' is 1F21
    And the menu is displayed with 'Highlight' option
    When I click on 'Highlight' link
    Then the train highlight color for berth 'D3A007' is 'XXXXXX'

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
