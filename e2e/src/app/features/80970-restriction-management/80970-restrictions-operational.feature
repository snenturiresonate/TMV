@TMVPhase2 @P2.S4
Feature: 80970 - TMV Restrictions - Operational

  As a TMV User (with restrictions role)
  I want the ability manage restrictions
  So that I can ensure user are aware of future and current restrictions

#  There may be multiple restrictions for a track division of which more than one may be active.
#  If this is the case then the highest priority restriction style and colour will be applied to the track section
#     If more than one restriction is applied then display the highest priority based on the following Restriction Type prioritisation:
#         BLOK (Line Blockage)
#         OOU (Out of Use)
#         POSS (Possession)
#         ESR (Emergency Speed Restriction)
#         TSR (Temporary Speed Restriction)
#         BTET (Blocked to Electric Traction)
#         CAU (Cautioning of Trains)
#         Multiple Restriction Apply
#     If there two restrictions of the same type then prioritise by:
#         Operational start date & time (early first) and then operational end date & time (later first with blank highest)
#  If there are multiple restrictions that includes BTET or CAU then the colour style is: Multiple Restrictions Apply
#  Admin setting changes do not take effect until after a refresh

  Background:
    Given I have not already authenticated
    And I access the homepage as admin user
    And The admin setting defaults are as originally shipped


  Scenario Outline: 81573 - 1 - No restrictions on track division

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I publish all restriction changes
    When I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' is palegrey
    And the track line style for track '<trackDivisionId>' is 'Solid'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH18          |


  Scenario Outline: 81573 - 2 - Styling of a single operational restriction on a track division

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    When I add the following restrictions
      | type              | comment       | start-date | end-date  |
      | <restrictionType> |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type '<restrictionType>'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type '<restrictionType>'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId | restrictionType                      |
      | HDGW01paddington.v | PNSH18          | BLOK (Line Blockage)                 |
      | HDGW01paddington.v | PNSH18          | OOU (Out of Use)                     |
      | HDGW01paddington.v | PNSH18          | POSS (Possession)                    |
      | HDGW01paddington.v | PNSH18          | ESR (Emergency Speed Restriction)    |
      | HDGW01paddington.v | PNSH18          | TSR (Temporary Speed Restriction)    |
      | HDGW01paddington.v | PNSH18          | BTET (Blocked to Electric Traction)  |
      | HDGW01paddington.v | PNSH18          | CAU (Cautioning of Trains)           |

  Scenario Outline: 81573 - 3 - Updating type of operational restriction results in update of style of track division on map

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I add the following restrictions whilst preserving allocated dates
      | type                              | comment       | start-date | end-date  |
      | BLOK (Line Blockage)              |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    And the track colour for track '<trackDivisionId>' matches the colour for restriction type 'BLOK (Line Blockage)'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'BLOK (Line Blockage)'
    And the track state width for '<trackDivisionId>' is '2px'
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I click on edit on the restriction in the last row
    When the following restriction values are entered
      | field                 | value                             |
      | Type                  | OOU (Out of Use)                  |
    And I click on done on the open restriction
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type 'OOU (Out of Use)'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'OOU (Out of Use)'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH18          |


  Scenario Outline: 81573 - 4 - Non-operational restrictions not shown on map

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    When I add the following restrictions whilst preserving allocated dates
      | type                              | comment       | start-date | end-date  |
      | BLOK (Line Blockage)              |  xx           | now + 30   |           |
      | POSS (Possession)                 |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type 'POSS (Possession)'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'POSS (Possession)'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH18          |


  Scenario Outline: 81573 - 5 - Styling of a multiple restrictions of different types on different start dates

#  There may be multiple restrictions for a track division of which more than one may be active.
#  If this is the case then the highest priority restriction style and colour will be applied to the track section
#     If more than one restriction is applied then display the highest priority based on the following Restriction Type prioritisation:
#         BLOK (Line Blockage)
#         OOU (Out of Use)
#         POSS (Possession)
#         ESR (Emergency Speed Restriction)
#         TSR (Temporary Speed Restriction)
#         BTET (Blocked to Electric Traction)
#         CAU (Cautioning of Trains)
#         Multiple Restriction Apply

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    When I add the following restrictions whilst preserving allocated dates
      | type                              | comment       | start-date | end-date  |
      | POSS (Possession)                 |  xx           | now - 32   |           |
      | ESR (Emergency Speed Restriction) |  xx           | now - 31   |           |
      | TSR (Temporary Speed Restriction) |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type 'POSS (Possession)'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'POSS (Possession)'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH18          |


  Scenario Outline: 81573 - 6 - Styling of a multiple restrictions of different types starting on same date

#  There may be multiple restrictions for a track division of which more than one may be active.
#  If this is the case then the highest priority restriction style and colour will be applied to the track section
#     If there two restrictions of the same type then prioritise by:
#         Operational start date & time (early first) and then operational end date & time (later first with blank highest)

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    When I add the following restrictions whilst preserving allocated dates
      | type                              | comment       | start-date | end-date  |
      | POSS (Possession)                 |  xx           | now - 30   |           |
      | ESR (Emergency Speed Restriction) |  xx           | now - 30   |           |
      | TSR (Temporary Speed Restriction) |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type 'POSS (Possession)'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'POSS (Possession)'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH18          |


  Scenario Outline: 81573 - 7 - Styling of a multiple restrictions of same type starting on different dates

#  There may be multiple restrictions for a track division of which more than one may be active.
#  If this is the case then the highest priority restriction style and colour will be applied to the track section
#     If there two restrictions of the same type then prioritise by:
#         Operational start date & time (early first) and then operational end date & time (later first with blank highest)

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    When I add the following restrictions whilst preserving allocated dates
      | type                              | comment       | start-date | end-date  |
      | POSS (Possession)                 |  xx           | now - 30   |           |
      | POSS (Possession)                 |  xx           | now - 31   |           |
      | POSS (Possession)                 |  xx           | now - 32   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type 'POSS (Possession)'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'POSS (Possession)'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH18          |


  Scenario Outline: 81573 - 8 - Styling of a multiple restrictions of same type starting on same date

#  There may be multiple restrictions for a track division of which more than one may be active.
#  If this is the case then the highest priority restriction style and colour will be applied to the track section
#     If there two restrictions of the same type then prioritise by:
#         Operational start date & time (early first) and then operational end date & time (later first with blank highest)

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    When I add the following restrictions whilst preserving allocated dates
      | type                              | comment       | start-date | end-date  |
      | POSS (Possession)                 |  xx           | now - 30   |           |
      | POSS (Possession)                 |  xx           | now - 30   |           |
      | POSS (Possession)                 |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type 'POSS (Possession)'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'POSS (Possession)'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH18          |


  Scenario Outline: 81573 - 9 - Multiple restrictions apply - CAU

#  If there are multiple restrictions that includes BTET or CAU then the colour style is: Multiple Restrictions Apply

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    When I add the following restrictions whilst preserving allocated dates
      | type                                | comment       | start-date | end-date  |
      | BLOK (Line Blockage)                |  xx           | now - 30   |           |
      | CAU (Cautioning of Trains)          |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type 'Multiple Restrictions Apply'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'Multiple Restrictions Apply'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH18          |


  Scenario Outline: 81573 - 10 - Multiple restrictions apply - BTET

#  If there are multiple restrictions that includes BTET or CAU then the colour style is: Multiple Restrictions Apply

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    When I add the following restrictions whilst preserving allocated dates
      | type                                | comment       | start-date | end-date  |
      | BLOK (Line Blockage)                |  xx           | now - 30   |           |
      | BTET (Blocked to Electric Traction) |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type 'Multiple Restrictions Apply'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'Multiple Restrictions Apply'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH18          |


  Scenario Outline: 81573 - 11 - Multiple restrictions apply after adding BTET to 2 other operational restrictions

#  If there are multiple restrictions that includes BTET or CAU then the colour style is: Multiple Restrictions Apply

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    When I add the following restrictions whilst preserving allocated dates
      | type                  | comment       | start-date | end-date  |
      | BLOK (Line Blockage)  |  xx           | now - 30   |           |
      | POSS (Possession)     |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type 'BLOK (Line Blockage)'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'BLOK (Line Blockage)'
    And the track state width for '<trackDivisionId>' is '2px'
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    When I add the following restrictions whilst preserving allocated dates
      | type                                | comment       | start-date | end-date  |
      | BTET (Blocked to Electric Traction) |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type 'Multiple Restrictions Apply'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type 'Multiple Restrictions Apply'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH18          |


  Scenario Outline: 81573 - 12 - Admin setting changes do not take effect until after a refresh

#  Admin setting changes do not take effect until after a refresh

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events for map <map>
    And I clear all restrictions snapshots for map <map>
    And I am on the admin page
    And I make a note of the restriction type settings
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I add the following restrictions
      | type              | comment       | start-date | end-date  |
      | <restrictionType> |  xx           | now - 30   |           |
    And I click apply changes
    And I publish all restriction changes
    And I am viewing the map <map>
    Then the track colour for track '<trackDivisionId>' matches the colour for restriction type '<restrictionType>'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type '<restrictionType>'
    And the track state width for '<trackDivisionId>' is '2px'
    And I am on the admin page
    When I update the Line Status restriction type settings table as
      | name              | colour  | lineStyle   |
      | <restrictionType> | #0f0    | Long Dashed |
    And I save the punctuality settings
    And I switch to the second-newest tab
    And the track colour for track '<trackDivisionId>' matches the colour for restriction type '<restrictionType>'
    And the track line style for track '<trackDivisionId>' matches the line style for restriction type '<restrictionType>'
    And the track state width for '<trackDivisionId>' is '2px'
    And I refresh the browser
    And I wait for the tracks to be displayed
    Then the track hex colour for track '<trackDivisionId>' is #00ff00
    And the track line style for track '<trackDivisionId>' is 'Long Dashed'
    And the track state width for '<trackDivisionId>' is '2px'

    Examples:
      | map                | trackDivisionId | restrictionType      |
      | HDGW01paddington.v | PNSH18          | BLOK (Line Blockage) |

