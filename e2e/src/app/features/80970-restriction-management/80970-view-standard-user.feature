@TMVPhase2 @P2.S4
@newSession
Feature: 80970 - TMV Restrictions - View (Standard User)

  As a TMV User (with restrictions role)
  I want the ability manage restrictions
  So that I can ensure user are aware of future and current restrictions

  Background:
    Given I have not already authenticated
    And I access the homepage as restriction user

  Scenario Outline: 81561 - 1 - View (Standard User) - multiple restrictions present

    #  Given the user is viewing a live schematic map
    #  And the user is a standard user
    #  When the user opts to view the restrictions view
    #  Then the user is presented with a restriction view in a new tab

    # Comments:
    #     The restrictions are ordered with the soonest end date at the top (if no end date these are displayed at the top)
    #     order by restriction type priority (delegated to BDD 87348 TMV Restrictions - View Ordering)
    #     Restrictions that have ended remain on the list up to to 12 hours

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I give the map an extra 1 second to load
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I add the following restrictions
      | type              | comment       | start-date | end-date  |
      | OOU (Out of Use)  | OOU - Team 1  | now - 30   |           |
      | OOU (Out of Use)  | OOU - Team 2  | now - 60   | now + 60  |
      | OOU (Out of Use)  | OOU - Team 3  | now - 100  | now + 120 |
      | OOU (Out of Use)  | OOU - Team 4  | now - 120  | now - 20  |
      | OOU (Out of Use)  | OOU - Team 5  | now - 840  | now - 720 |
    And I click apply changes
    And I logout
    And I access the homepage as standard user
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And the map context menu has 3 items
    And the map context menu contains 'Restrictions' on line 2
    And the map context menu on line 2 has text colour 'blue'
    And the map context menu on line 2 has text underline 'underline'
    And the map context menu contains 'OOU - Team 3' on line 3
    And I open restrictions screen from the map context menu
    When I switch to the new restriction tab
    Then only the following restrictions are shown in order
      | type              | comment       | start-date | end-date  |
      | OOU (Out of Use)  | OOU - Team 3  | now - 100  | now + 120 |
      | OOU (Out of Use)  | OOU - Team 2  | now - 60   | now + 60  |
      | OOU (Out of Use)  | OOU - Team 1  | now - 30   |           |
      | OOU (Out of Use)  | OOU - Team 4  | now - 120  | now - 20  |

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |

  Scenario Outline: 81561 - 2 - View (Standard User) - the user cannot create, edit or delete a restriction

    #  And the user cannot create, edit or delete a restriction

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I add the following restrictions
      | type              | comment       | start-date | end-date  |
      | OOU (Out of Use)  | OOU - Team 1  | now - 30   |           |
      | OOU (Out of Use)  | OOU - Team 2  | now - 60   | now + 60  |
      | OOU (Out of Use)  | OOU - Team 3  | now - 100  | now + 120 |
      | OOU (Out of Use)  | OOU - Team 4  | now - 120  | now - 20  |
    And I click apply changes
    And I logout
    And I access the homepage as standard user
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    When I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    Then there are 4 restrictions in the restrictions table
    And no add restriction button is present
    And no edit restriction buttons are present
    And no delete restriction buttons are present

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |
