@TMVPhase2 @P2.S4
Feature: 80970 - TMV Restrictions - Track Section Menu

  As a TMV User (with restrictions role)
  I want the ability manage restrictions
  So that I can ensure user are aware of future and current restrictions

  Background:
    Given I have not already authenticated
    And I access the homepage as restriction user

  Scenario Outline:81559 - 1 Track Section Menu - no restriction present

#    Given the user is viewing a live schematic map
#    When the user selects a track section with the secondary click
#    Then the user is presented menu containing the track division ID
#    And a comment is displayed if a restriction is present
#    And an option to view the restrictions tab

#    Cover where no restriction is displayed and if comment is blank

    Given I remove all restrictions for track division <trackDivisionId>
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

#    Given the user is viewing a live schematic map
#    When the user selects a track section with the secondary click
#    Then the user is presented menu containing the track division ID
#    And a comment is displayed if a restriction is present
#    And an option to view the restrictions tab

    Given I remove all restrictions for track division <trackDivisionId>
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
      | Start-Date            | today                             |
      | End-Date              | blank                             |
      | Max-Speed             | 20                                |
      | Delay-Penalty         | 10                                |
      | Comment               | <comment>                         |
    And I click on done on the open restriction
    And I click apply changes
    And I switch to the second-newest tab
    And I refresh the browser
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
    And I refresh the browser
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

