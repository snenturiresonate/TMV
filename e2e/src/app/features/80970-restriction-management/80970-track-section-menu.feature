@TMVPhase2 @P2.S4
Feature: 80970 - TMV Restrictions - Track Section Menu

  As a TMV User (with restrictions role)
  I want the ability manage restrictions
  So that I can ensure user are aware of future and current restrictions

#    Given the user is viewing a live schematic map
#    When the user selects a track section with the secondary click
#    Then the user is presented menu containing the track division ID
#    And a comment is displayed if a restriction is present
#    And an option to view the restrictions tab
#
#    Comments:
#    Cover where no restriction is displayed and if comment is blank

#    If more than one restriction is applied then display the highest priority based on the following Restriction Type prioritisation:
#     BLOK (Line Blockage)
#     OOU (Out of Use)
#     POSS (Possession)
#     ESR (Emergency Speed Restriction)
#     TSR (Temporary Speed Restriction)
#     BTET (Blocked to Electric Traction)
#     CAU (Cautioning of Trains)

#   If there two restrictions of the same type then prioritise by:
#     Operational start date & time (early first) and then operational end date & time (later first with blank highest)

  Background:
    Given I have not already authenticated
    And I access the homepage as restriction user

  Scenario Outline:81559 - 1 Track Section Menu - no restriction present

#    Cover where no restriction is displayed and if comment is blank

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'Track Division: <trackDivisionId>' on line 1
    And the map context menu has 2 items
    And the map context menu contains 'Restrictions' on line 2
    And the map context menu on line 2 has text colour 'blue'
    And the map context menu on line 2 has text underline 'underline'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH6M          |

  Scenario Outline:81559 - 2 Track Section Menu - 1 restriction present with comment

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I click to add a new restriction
    And the following restriction values are entered
      | field                 | value                             |
      | Type                  | TSR (Temporary Speed Restriction) |
      | Start-Distance-miles  | 1                                 |
      | Start-Distance-chains | 2                                 |
      | End-Distance-miles    | 3                                 |
      | End-Distance-chains   | 4                                 |
      | Start-Date            | now                               |
      | End-Date              | blank                             |
      | Max-Speed             | 20                                |
      | Delay-Penalty         | 10                                |
      | Comment               | <comment>                         |
    And I click on done on the open restriction
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    When I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'Track Division: <trackDivisionId>' on line 1
    And the map context menu has 3 items
    And the map context menu contains 'Restrictions' on line 2
    And the map context menu on line 2 has text colour 'blue'
    And the map context menu on line 2 has text underline 'underline'
    And the map context menu contains '<comment>' on line 3

    Examples:
      | map                | trackDivisionId | comment            |
      | HDGW01paddington.v | PNSH6M          | Leaves on the line |

  Scenario Outline:81559 - 3 Track Section Menu - 1 restriction present with no comment

#    Cover where no restriction is displayed and if comment is blank

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I click to add a new restriction
    And the following restriction values are entered
      | field   | value                             |
      | Type    | TSR (Temporary Speed Restriction) |
      | Comment |                                   |
    And I click on done on the open restriction
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    When I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'Track Division: <trackDivisionId>' on line 1
    And the map context menu has 2 items
    And the map context menu contains 'Restrictions' on line 2
    And the map context menu on line 2 has text colour 'blue'
    And the map context menu on line 2 has text underline 'underline'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH6M          |


  Scenario Outline:81559 - 4 Track Section Menu - Many concurrent restrictions - comment reflects highest priority type

#    If more than one restriction is applied then display the highest priority based on the following Restriction Type prioritisation:
#     BLOK (Line Blockage)
#     OOU (Out of Use)
#     POSS (Possession)
#     ESR (Emergency Speed Restriction)
#     TSR (Temporary Speed Restriction)
#     BTET (Blocked to Electric Traction)
#     CAU (Cautioning of Trains)

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I add the following restrictions starting now
      | type                                | comment                          |
      | TSR (Temporary Speed Restriction)   | TSR - area-wide restriction      |
      | BLOK (Line Blockage)                | BLOK - Tree on the line          |
      | BTET (Blocked to Electric Traction) | BTET - Notice 5.3.4              |
      | CAU (Cautioning of Trains)          | CAU - All afternoon              |
      | POSS (Possession)                   | POSS - track relaying            |
      | ESR (Emergency Speed Restriction)   | ESR - (suspected points problem) |
      | OOU (Out of Use)                    | OOU - pending investigation      |
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    When I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'BLOK - Tree on the line' on line 3
    When I switch to the new restriction tab
    And I click to edit the restriction with comment BLOK - Tree on the line
    And the following restriction values are entered
      | field    | value |
      | End-Date | now   |
    And I click on done on the open restriction
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    And I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'OOU - pending investigation' on line 3
    When I switch to the new restriction tab
    And I click to edit the restriction with comment OOU - pending investigation
    And the following restriction values are entered
      | field    | value |
      | End-Date | now   |
    And I click on done on the open restriction
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    When I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'POSS - track relaying' on line 3
    When I switch to the new restriction tab
    And I click to edit the restriction with comment POSS - track relaying
    And the following restriction values are entered
      | field    | value |
      | End-Date | now   |
    And I click on done on the open restriction
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    When I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'ESR - (suspected points problem)' on line 3
    When I switch to the new restriction tab
    And I click to edit the restriction with comment ESR - (suspected points problem)
    And the following restriction values are entered
      | field    | value |
      | End-Date | now   |
    And I click on done on the open restriction
    And I click to edit the restriction with comment TSR - area-wide restriction
    And the following restriction values are entered
      | field    | value |
      | End-Date | now   |
    And I click on done on the open restriction
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    When I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'BTET - Notice 5.3.4' on line 3

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH6M          |


  @bug @bug:92716
  Scenario Outline:81559 - 5 Track Section Menu - Concurrent restrictions of same type  - comment reflects operational restriction that started first

#   If there two restrictions of the same type then prioritise by:
#     Operational start date & time (early first) and then operational end date & time (later first with blank highest)

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I give the map an extra 1 second to load
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I add the following restrictions
      | type              | comment       | start-date | end-date  |
      | POSS (Possession) | POSS - Team 1 | now - 30   |           |
      | POSS (Possession) | POSS - Team 2 | now - 60   | now + 60  |
      | POSS (Possession) | POSS - Team 3 | now - 100  | now + 120 |
      | POSS (Possession) | POSS - Team 4 | now - 120  | now - 20  |
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    When I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'POSS - Team 3' on line 3
    When I switch to the new restriction tab
    And I click to edit the restriction with comment POSS - Team 3
    And the following restriction values are entered
      | field    | value |
      | End-Date | now   |
    And I click on done on the open restriction
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    When I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'POSS - Team 2' on line 3

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH6M          |


  Scenario Outline:81559 - 6 Track Section Menu - Concurrent restrictions of same type and start  - comment reflects operational restriction that ends latest

#   If there two restrictions of the same type then prioritise by:
#     Operational start date & time (early first) and then operational end date & time (later first with blank highest)

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I add the following restrictions starting now
      | type                 | comment                                                                                                                         | end-date  |
      | BLOK (Line Blockage) | BLOK - area-wide restriction                                                                                                    |           |
      | BLOK (Line Blockage) | BLOK - Bridge strike debris? For further information call (01367) 672828. /**UPDATE Current estimate for clearance is 19:00 **/ | now + 120 |
      | BLOK (Line Blockage) | BLOK - Tree on the line                                                                                                         | now + 60  |
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    When I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'BLOK - area-wide restriction' on line 3
    When I switch to the new restriction tab
    And I click to edit the restriction with comment BLOK - area-wide restriction
    And the following restriction values are entered
      | field    | value |
      | End-Date | now   |
    And I click on done on the open restriction
    And I click apply changes
    And I switch to the second-newest tab
    And I wait for the tracks to be displayed
    When I right click on track with id '<trackDivisionId>'
    Then the map context menu contains 'BLOK - Bridge strike debris? For further information call (01367) 672828. /**UPDATE Current estimate for clearance is 19:00 **/' on line 3

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH6M          |
