@TMVPhase2 @P2.S4
Feature: 80970 - TMV Restrictions - Delete

  As a TMV User (with restrictions role)
  I want the ability manage restrictions
  So that I can ensure user are aware of future and current restrictions

  Background:
    Given I have not already authenticated
    And I access the homepage as restriction user

  Scenario Outline: 82850 - 1- Delete non-operational restriction

#    Given the user is viewing a live schematic map
#    And the user has the restrictions role
#    And the user is on the restriction view
#    When the user opts to delete a restriction
#    And the restriction is not operational (date/time in the future)) or has been not been operational
#    Then the restriction is removed on apply
#    And is verified that the restriction has been deleted on subsequent access

    Given I remove all restrictions for track division <trackDivisionId>
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
      | Start-Date            | tomorrow                          |
      | End-Date              | blank                             |
      | Max-Speed             | 20                                |
      | Delay-Penalty         | 10                                |
      | Comment               | Leaves on the line                |
    And I click on done on the open restriction
    And I click apply changes
    And I refresh the restrictions page
    And there is 1 restriction in the restrictions table
    When I click on delete on the restriction in the last row
    And I click apply changes
    And I refresh the restrictions page
    Then there are 0 restrictions in the restrictions table

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |

  Scenario Outline: 82850 - 2 - Unable to delete operational restriction

#    And the restriction is not operational (date/time in the future)) or has been not been operational

    Given I remove all restrictions for track division <trackDivisionId>
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
      | Start-Date            | yesterday                         |
      | End-Date              | blank                             |
      | Max-Speed             | 20                                |
      | Delay-Penalty         | 10                                |
      | Comment               | Leaves on the line                |
    And I click on done on the open restriction
    And I click apply changes
    And I refresh the restrictions page
    And there is 1 restriction in the restrictions table
    And the delete button is disabled on the last restriction

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |

