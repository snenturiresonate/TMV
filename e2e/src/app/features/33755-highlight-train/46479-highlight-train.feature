Feature: 33755 - TMV Highlight Train

  As a TMV User
  I want the ability to highlight a train
  So that I can track or identify a train that may require operational intervention

  Background:
    * I remove all trains from the trains list
    * I am viewing the map hdgw01paddington.v
    * I have cleared out all headcodes

  Scenario Outline: 33755-1a & 2a Highlight Train (Menu) - Berth Interpose
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user selects a train for highlighting using the secondary mouse click
    #Then the user is presented with an option to highlight/unhighlight the train
    #When the user selects highlight
    #Then the train is highlighted
    * I remove today's train '<planningUid>' from the trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif    | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth   | trainDescriber     | trainDescription   |
      | <berth>   | <trainDescriber>   | <trainDescription> |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When I wait for the Open timetable option for train description <trainDescription> in berth <berth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><berth>'
    Then the menu is displayed with 'Highlight' option
    When I click on Highlight link
    Then the train in berth <trainDescriber><berth> is highlighted
    When I right click on berth with id '<trainDescriber><berth>'
    Then the menu is displayed with 'Unhighlight' option

    Examples:
    | trainDescription | planningUid | trainDescriber | berth |
    | 5B11             | B53311      | D3             | A001  |
    | 5C11             | C53311      | D3             | A007  |

  Scenario Outline: 33755-1b & 2b Highlight Train (Menu) - Berth Interpose and Step
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user selects a train for highlighting using the secondary mouse click
    #Then the user is presented with an option to highlight/unhighlight the train
    #When the user selects highlight
    #Then the train is highlighted
    * I remove today's train '<planningUid>' from the trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif    | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth   | trainDescriber     | trainDescription   |
      | <berth>      | <trainDescriber>   | <trainDescription> |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When I wait for the Open timetable option for train description <trainDescription> in berth <berth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><secondBerth>'
    Then the menu is displayed with 'Highlight' option
    When I click on Highlight link
    Then the train in berth <trainDescriber><berth> is highlighted
    When the following live berth step message is sent from LINX
      | fromBerth | toBerth       | trainDescriber   | trainDescription   |
      | <berth>   | <secondBerth> | <trainDescriber> | <trainDescription> |
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    And the train in berth <trainDescriber><secondBerth> is highlighted
    When I right click on berth with id '<trainDescriber><secondBerth>'
    Then the menu is displayed with 'Unhighlight' option

    Examples:
      | trainDescription | planningUid | trainDescriber | berth | secondBerth |
      | 5B12             | B53312      | D3             | A001  | 6003        |
      | 5C12             | C53312      | D3             | A007  | 0039        |

  Scenario Outline: 33755-2d Highlight Train (Headcode) - Berth Interpose same headcode for two different berths
    * I remove today's train '<planningUid>' from the trainlist
    * I remove today's train '<secondPlanningUid>' from the trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif    | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid      |
      | access-plan/2P77_RDNGSTN_PADTON.cif | RDNGSTN     | WTT_dep       | <trainDescription>  | <secondPlanningUid> |
    And I wait until today's train '<planningUid>' has loaded
    And I wait until today's train '<secondPlanningUid>' has loaded
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth   | trainDescriber     | trainDescription   |
      | <berth>   | <trainDescriber>   | <trainDescription> |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When I wait for the Open timetable option for train description <trainDescription> in berth <berth>, describer <trainDescriber> to be available
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth       | trainDescriber     | trainDescription   |
      | <secondBerth> | <trainDescriber>   | <trainDescription> |
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When I wait for the Open timetable option for train description <trainDescription> in berth <berth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><berth>'
    Then the menu is displayed with 'Highlight' option
    When I click on Highlight link
    Then the train in berth <trainDescriber><berth> is highlighted
    And the train in berth <trainDescriber><secondBerth> is not highlighted

    Examples:
      | trainDescription | planningUid | secondPlanningUid | trainDescriber | berth | secondBerth |
      | 5B13             | B53313      | C53313            | D3             | A007  | 0078        |

  Scenario Outline: 33755-3a Unhighlight Train (Menu) - Berth Interpose
    #Given the user is viewing a live schematic map
    #And there are services running
    #When the user selects a train for highlighting using the secondary mouse click
    #Then the user is presented with an option to highlight/unhighlight the train
    * I remove today's train '<planningUid>' from the trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif    | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth   | trainDescriber     | trainDescription   |
      | <berth>   | <trainDescriber>   | <trainDescription> |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When I wait for the Open timetable option for train description <trainDescription> in berth <berth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><berth>'
    Then the menu is displayed with 'Highlight' option
    When I click on Highlight link
    Then the train in berth <trainDescriber><berth> is highlighted
    When I right click on berth with id '<trainDescriber><berth>'
    Then the menu is displayed with 'Unhighlight' option
    When I click on Unhighlight link
    Then the train in berth <trainDescriber><berth> is not highlighted

    Examples:
      | trainDescription | planningUid | trainDescriber | berth |
      | 5B14             | B53314      | D3             | A001  |
      | 5C14             | C53314      | D3             | A007  |

  Scenario Outline: 33755-3b Unhighlight Train (Menu) - Berth Interpose and Step
    #Given the user is viewing a live schematic map
    #And there are services running
    #And a service is highlighted
    #When the user has opts to unhighlight the train
    #Then the train is highlighting is removed
    * I remove today's train '<planningUid>' from the trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif    | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    When the following live berth interpose message is sent from LINX (creating a match)
      | toBerth   | trainDescriber     | trainDescription   |
      | <berth>      | <trainDescriber>   | <trainDescription> |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    When I wait for the Open timetable option for train description <trainDescription> in berth <berth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><secondBerth>'
    Then the menu is displayed with 'Highlight' option
    When I click on Highlight link
    Then the train in berth <trainDescriber><berth> is highlighted
    When the following live berth step message is sent from LINX
      | fromBerth | toBerth       | trainDescriber   | trainDescription   |
      | <berth>   | <secondBerth> | <trainDescriber> | <trainDescription> |
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<trainDescription>' and is visible
    And the train in berth <trainDescriber><secondBerth> is highlighted
    When I right click on berth with id '<trainDescriber><secondBerth>'
    Then the menu is displayed with 'Unhighlight' option
    When I click on Unhighlight link
    Then the train in berth <trainDescriber><secondBerth> is not highlighted

    Examples:
      | trainDescription | planningUid | trainDescriber | berth | secondBerth |
      | 5B12             | B53312      | D3             | A001  | 6003        |
      | 5C12             | C53312      | D3             | A007  | 0039        |
