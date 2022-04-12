@TMVPhase2 @P2.S4
@newSession
Feature: 80970 - TMV Restrictions - Track Section Menu

  As a TMV User (with standard role)
  I want the ability manage restrictions
  So that I can ensure user are aware of future and current restrictions

#    Given the user is viewing a live schematic map
#    When the user selects a track section with the secondary click
#    Then the user is presented menu containing the track division ID
#    And a comment is displayed if a restriction is present
#    And an option to view the restrictions tab
#
#     The full set of scenarios for this feature are tested in 80970-track-section-menu.feature
#     but one scenario is included here for standard user testing for each of the comments below.

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

      # The full set of scenarios for the above comment are tested in 80970-track-section-menu.feature
      # but one scenario is included here for standard user testing for each of the comments below.

#   If there two restrictions of the same type then prioritise by:
#     Operational start date & time (early first) and then operational end date & time (later first with blank highest)

      # The full set of scenarios for the above comment are tested in 80970-track-section-menu.feature
      # but one scenario is included here for standard user testing for each of the comments below.

  Background:
    Given I have not already authenticated
    And I access the homepage as restriction user

  Scenario Outline:81559 - 1 Track Section Menu - no restriction present

#    Cover where no restriction is displayed and if comment is blank

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>

    # Connect as standard user
    And I logout
    And I access the homepage as standard user

    When I am viewing the map <map>
    And I wait for the tracks to be displayed
    And I right click on track with id '<trackDivisionId>'

    Then the map context menu contains 'Track Division: <trackDivisionId>' on line 1
    And the map context menu has 2 items
    And the map context menu contains 'Restrictions' on line 2
    And the map context menu on line 2 has text colour 'blue'
    And the map context menu on line 2 has text underline 'underline'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |


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
    And I publish all restriction changes

    # Connect as standard user
    And I logout
    And I access the homepage as standard user

    When I am viewing the map <map>
    And I wait for the tracks to be displayed
    And I right click on track with id '<trackDivisionId>'

    Then the map context menu contains 'Track Division: <trackDivisionId>' on line 1
    And the map context menu has 3 items
    And the map context menu contains 'Restrictions' on line 2
    And the map context menu on line 2 has text colour 'blue'
    And the map context menu on line 2 has text underline 'underline'
    And the map context menu contains '<comment>' on line 3

    Examples:
      | map                | trackDivisionId | comment            |
      | HDGW01paddington.v | PNPNDM          | Leaves on the line |


  Scenario Outline:81559 - 3 Track Section Menu - 1 restriction present with no comment

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
    And I publish all restriction changes

    # Connect as standard user
    And I logout
    And I access the homepage as standard user

    When I am viewing the map <map>
    And I wait for the tracks to be displayed
    And I right click on track with id '<trackDivisionId>'

    Then the map context menu contains 'Track Division: <trackDivisionId>' on line 1
    And the map context menu has 2 items
    And the map context menu contains 'Restrictions' on line 2
    And the map context menu on line 2 has text colour 'blue'
    And the map context menu on line 2 has text underline 'underline'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |


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
    And I publish all restriction changes

    # Connect as standard user
    And I logout
    And I access the homepage as standard user

    When I am viewing the map <map>
    And I wait for the tracks to be displayed
    And I right click on track with id '<trackDivisionId>'

    Then the map context menu contains 'BLOK - Tree on the line' on line 3

  Examples:
    | map                | trackDivisionId |
    | HDGW01paddington.v | PNPNDM          |

  # The following test passes when ran locally, but when ran on the server, is unable to perform a right click on the restricted track
  @manual @manual:92961
  Scenario Outline:81559 - 5 Track Section Menu - Concurrent restrictions of same type and start  - comment reflects operational restriction that ends latest

#   If there two restrictions of the same type then prioritise by:
#     Operational start date & time (early first) and then operational end date & time (later first with blank highest)

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I add the following restrictions starting now - 60
      | type                 | comment                                                                                                                         | end-date  |
      | BLOK (Line Blockage) | BLOK - area-wide restriction                                                                                                    | now + 180 |
      | BLOK (Line Blockage) | BLOK - Bridge strike debris? For further information call (01367) 672828. /**UPDATE Current estimate for clearance is 19:00 **/ | now + 120 |
      | BLOK (Line Blockage) | BLOK - Tree on the line                                                                                                         | now + 60  |
    And I click apply changes
    And I publish all restriction changes

    # Connect as standard user
    And I logout
    And I access the homepage as standard user

    When I am viewing the map <map>
    And I wait for the tracks to be displayed
    And I right click on track with id '<trackDivisionId>'

    Then the map context menu contains 'BLOK - area-wide restriction' on line 3

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |
