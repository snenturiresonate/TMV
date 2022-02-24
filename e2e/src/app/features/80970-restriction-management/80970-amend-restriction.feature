@TMVPhase2 @P2.S4
Feature: 80970 - TMV Restrictions - Amend

  As a TMV User (with restrictions role)
  I want the ability manage restrictions
  So that I can ensure user are aware of future and current restrictions

  Background:
    Given I have not already authenticated
    And I access the homepage as restriction user

  Scenario Outline: 82848 - 1 - Amend restriction - all fields

#    Given the user is viewing a live schematic map
#    And the user has the restrictions role
#    And the user is on the restriction view
#    When the user opts to amend a restriction
#    And the user selects the apply button to save the changes
#    Then the restriction is saved and the restriction view updated
#    And the amended restriction is verified that it has been save on subsequent access to the restrictions view

#  The following fields can be amended:
#   Type of restriction selectable from the following options (mandatory)
#       BLOK (Line Blockage)
#       OOU (Out Of Use) POSS (Possession)
#       ESR (Emergency Speed Restriction)
#       TSR (Temporary Speed Restriction)
#       BTET (Blocked to Electric Traction)
#       CAU (Cautioning of Trains)
#   Start distance (miles & chains) - 2 x 3 digit integer (default blank) (optional)
#   End distance (miles & chains) - 2 x 3 digit integer (default blank) (optional)
#   Start time and date
#   End time and date (optional)
#   Maximum Speed (mph) - 3 digits (default blank) (optional)
#   Delay Penalty (mins) - 3 digits (default blank) (optional)
#   Comment - 150 characters limit (default blank) (optional)

#   The max limits and defaults for the number of characters for text and number fields are tested in 80970-create-restriction.feature

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
      | Start-Date            | today                             |
      | End-Date              | blank                             |
      | Max-Speed             | 20                                |
      | Delay-Penalty         | 10                                |
      | Comment               | Leaves on the line                |
    And I click on done on the open restriction
    And I click apply changes
    And I click on edit on the restriction in the last row
    When the following restriction values are entered
      | field                 | value                             |
      | Type                  | OOU (Out of Use)                  |
      | Start-Distance-miles  | 100                               |
      | Start-Distance-chains | 200                               |
      | End-Distance-miles    | 300                               |
      | End-Distance-chains   | 400                               |
      | End-Date              | tomorrow                          |
      | Max-Speed             | 100                               |
      | Delay-Penalty         | 200                               |
      | Comment               | Cows on track                     |
    And I click on done on the open restriction
    And I click apply changes
    And I refresh the restrictions page
    Then the new restriction row contains the following fields
      | field                 | value                             |
      | Type                  | OOU (Out of Use)                  |
      | Start-Distance-miles  | 100 m                             |
      | Start-Distance-chains | 200 ch                            |
      | End-Distance-miles    | 300 m                             |
      | End-Distance-chains   | 400 ch                            |
      | End-Date              | tomorrow                          |
      | Max-Speed             | 100 mph                           |
      | Delay-Penalty         | 200 mins                          |
      | Comment               | Cows on track                     |

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |

  Scenario Outline: 82848 - 2 - Amend restriction - all optional fields blank

#   Start distance (miles & chains) - 2 x 3 digit integer (default blank) (optional)
#   End distance (miles & chains) - 2 x 3 digit integer (default blank) (optional)
#   End time and date (optional)
#   Maximum Speed (mph) - 3 digits (default blank) (optional)
#   Delay Penalty (mins) - 3 digits (default blank) (optional)
#   Comment - 150 characters limit (default blank) (optional)

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
      | Start-Date            | today                             |
      | End-Date              | blank                             |
      | Max-Speed             | 20                                |
      | Delay-Penalty         | 10                                |
      | Comment               | Leaves on the line                |
    And I click on done on the open restriction
    And I click apply changes
    And I click on edit on the restriction in the last row
    When the following restriction values are entered
      | field                 | value                             |
      | Type                  | OOU (Out of Use)                  |
      | Start-Distance-miles  | blank                             |
      | Start-Distance-chains | blank                             |
      | End-Distance-miles    | blank                             |
      | End-Distance-chains   | blank                             |
      | End-Date              | blank                             |
      | Max-Speed             | blank                             |
      | Delay-Penalty         | blank                             |
      | Comment               | blank                             |
    And I click on done on the open restriction
    And I click apply changes
    And I refresh the restrictions page
    Then the new restriction row contains the following fields
      | field                 | value                             |
      | Type                  | OOU (Out of Use)                  |
      | Start-Distance-miles  | blank                             |
      | Start-Distance-chains | blank                             |
      | End-Distance-miles    | blank                             |
      | End-Distance-chains   | blank                             |
      | Start-Date            | today                             |
      | End-Date              | blank                             |
      | Max-Speed             | blank                             |
      | Delay-Penalty         | blank                             |
      | Comment               | blank                             |

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |

  Scenario Outline: 82848 - 3 - Amend restriction - Cannot amend operational restriction start time and date into the future

#   Start time and date (cannot be amended into the future once operational)

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
      | Start-Date            | today                             |
      | End-Date              | blank                             |
      | Max-Speed             | 20                                |
      | Delay-Penalty         | 10                                |
      | Comment               | Leaves on the line                |
    And I click on done on the open restriction
    And I click apply changes
    And I click on edit on the restriction in the last row
    When the following restriction values are entered
      | field                 | value                             |
      | Start-Date            | tomorrow                          |
    Then the done button is disabled on the open restriction

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNPNDM          |

