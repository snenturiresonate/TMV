@TMVPhase2 @P2.S4
Feature: 80970 - TMV Restrictions - Save

  As a TMV User (with restrictions role)
  I want the ability manage restrictions
  So that I can ensure user are aware of future and current restrictions

  Background:
    Given I have not already authenticated
    And I access the homepage as restriction user

  Scenario Outline: 81572 - 1 Save restriction

#   Given the user is viewing a live schematic map
#   And the user has the restrictions role
#   And the user is on the restriction view
#   And has entered the minimum set of details for the restriction
#   When the user opts to save (apply changes) the restriction
#   Then the restriction is saved
#   And the restrictions list is updated with the new restriction

#   Comment: Restrictions can have no end date

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I make a note of the number of existing restrictions
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
      | Comment               | Snow on the line                  |
    And I click on done on the open restriction
    When I click apply changes
    Then the new restriction row contains the following fields
      | field                 | value                             |
      | Type                  | TSR (Temporary Speed Restriction) |
      | Start-Distance-miles  | 1 m                               |
      | Start-Distance-chains | 2 ch                              |
      | End-Distance-miles    | 3 m                               |
      | End-Distance-chains   | 4 ch                              |
      | Start-Date            | today                             |
      | End-Date              | blank                             |
      | Max-Speed             | 20 mph                            |
      | Delay-Penalty         | 10 mins                           |
      | Comment               | Snow on the line                  |

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |


  Scenario Outline: 81572 - 2 Reset restriction

#   Comment: The user may wish to not apply the changes made in this view and close the view without saving any changes

    Given I remove all restrictions for track division <trackDivisionId>
    And I clear all restrictions events and snapshots for map <map>
    And I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new restriction tab
    And I make a note of the number of existing restrictions
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
      | Comment               | Leaves on the line                |
    And I click on done on the open restriction
    When I click reset
    Then no new restriction has been added to the list

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |

