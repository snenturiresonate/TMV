@TMVPhase2 @P2.S4
Feature: 80970 - TMV Restrictions - Create

  As a TMV User (with restrictions role)
  I want the ability manage restrictions
  So that I can ensure user are aware of future and current restrictions

  Background:
    Given I have not already authenticated
    And I access the homepage as restriction user

  Scenario Outline:81562 - 1 Create Restriction - fields available and defaults

#    Given the user is viewing a live schematic map
#    And the user has the restrictions role
#    And the user is on the restriction view
#    When the user opts to create a restriction of a certain type
#    Then the user is presented with a list of restriction fields to populate based on the type

#    The new restriction will have the following fields:
#    Track Division ID (read-only)
#    Start distance (miles & chains) - 2 x 3 digit integer (default blank) (optional)
#    End distance (miles & chains) - 2 x 3 digit integer (default blank) (optional)
#    Start time and date (default to current time and date - mandatory)
#    End time and date (optional)
#    Maximum Speed (mph) - 3 digits (default blank) (optional)
#    Delay Penalty (mins) - 3 digits (default blank) (optional)
#    Comment - 150 characters limit (default blank) (optional)

    Given I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    When I switch to the new tab
    Then the restriction header contains the id '<trackDivisionId>'
    When I make a note of the number of existing restrictions
    And I click to add a new restriction
    Then there is a new editable restriction in the list
    And the restriction row contains the following editable fields and defaults
      | field                 | default              |
      | Type                  | BLOK (Line Blockage) |
      | Start-Distance-miles  | blank                |
      | Start-Distance-chains | blank                |
      | End-Distance-miles    | blank                |
      | End-Distance-chains   | blank                |
      | Start-Date            | now                  |
      | End-Date              | blank                |
      | Max-Speed             | blank                |
      | Delay-Penalty         | blank                |
      | Comment               | blank                |

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH6M          |

  Scenario Outline:81562 - 2 Create Restriction - types available

#  Type of restriction selectable from the following options (mandatory)
#  BLOK (Line Blockage)
#  OOU (Out Of Use) POSS (Possession)
#  ESR (Emergency Speed Restriction)
#  TSR (Temporary Speed Restriction)
#  BTET (Blocked to Electric Traction)
#  CAU (Cautioning of Trains)

    Given I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new tab
    When I click to add a new restriction
    Then the editable type drop down contains the following options
      | type                                |
      | BLOK (Line Blockage)                |
      | OOU (Out Of Use)                    |
      | POSS (Possession)                   |
      | ESR (Emergency Speed Restriction)   |
      | TSR (Temporary Speed Restriction)   |
      | BTET (Blocked to Electric Traction) |
      | CAU (Cautioning of Trains)          |

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH6M          |

  Scenario Outline:81562 - 3 Create Restriction - input limits

#    The new restriction will have the following fields:
#    Start distance (miles & chains) - 2 x 3 digit integer (default blank) (optional)
#    End distance (miles & chains) - 2 x 3 digit integer (default blank) (optional)
#    Maximum Speed (mph) - 3 digits (default blank) (optional)
#    Delay Penalty (mins) - 3 digits (default blank) (optional)
#    Comment - 150 characters limit (default blank) (optional)

    Given I am viewing the map <map>
    And I right click on track with id '<trackDivisionId>'
    And I open restrictions screen from the map context menu
    And I switch to the new tab
    When I click to add a new restriction
    Then the restriction fields have the following input limits
      | field                 | inputType | limit |
      | Start-Distance-miles  | digit     | 3     |
      | Start-Distance-chains | digit     | 3     |
      | End-Distance-miles    | digit     | 3     |
      | End-Distance-chains   | digit     | 3     |
      | Max-Speed             | digit     | 3     |
      | Delay-Penalty         | digit     | 3     |
      | Comment               | char      | 150   |

    Examples:
      | map                | trackDivisionId |
      | HDGW01paddington.v | PNSH6M          |
