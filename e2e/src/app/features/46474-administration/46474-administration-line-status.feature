@TMVPhase2 @P2.S4 @bdd:83085
Feature: 46474 - Administration Display Settings - full end to end testing - line status

  As a tester
  I want to verify the administration page - Display Settings
  So, that I can identify if the build meet the end to end requirements

  Background:
    Given I have not already authenticated
    And I am on the admin page
    And The admin setting defaults are as originally shipped

  Scenario: Line Status settings header
    Then the line settings header is displayed as 'Line Status'

   Scenario: Line Status -Restriction type settings default color and entries
    Then the following can be seen on the Line Status restriction type settings table
      | name                                | colour  | lineStyle    |
      | BLOK (Line Blockage)                | #ff0000 | Solid        |
      | OOU (Out of Use)                    | #ffa700 | Solid        |
      | POSS (Possession)                   | #ff0000 | Long Dashed  |
      | ESR (Emergency Speed Restriction)   | #ffff00 | Short Dashed |
      | TSR (Temporary Speed Restriction)   | #ffa700 | Short Dashed |
      | BTET (Blocked to Electric Traction) | #ffc0cb | Short Dashed |
      | CAU (Cautioning of Trains)          | #ffff00 | Solid        |
      | Multiple Restrictions Apply         | #800080 | Solid        |

  Scenario: Line Status -Route type settings default color and entries
    Then the following can be seen on the Line Status route type settings table
      | name      | colour  | lineStyle |
      | Route Set | #ffffff | Solid     |

  Scenario: Line Status -Path type settings default color and entries
    Then the following can be seen on the Line Status path type settings table
      | name           | colour  | lineStyle |
      | Predicted Path | #00d2ff | Solid     |

  Scenario: Line Status -Restriction type settings reset to default color and entries
    When I update the Line Status restriction type settings table as
      | name                                | colour  | lineStyle    |
      | BLOK (Line Blockage)                | #bb2    | Long Dashed  |
      | OOU (Out of Use)                    | #bb2    | Short Dashed |
      | POSS (Possession)                   | #bb2    | Solid        |
      | ESR (Emergency Speed Restriction)   | #bb2    | Long Dashed  |
      | TSR (Temporary Speed Restriction)   | #bb2    | Short Dashed |
      | BTET (Blocked to Electric Traction) | #bb2    | Solid        |
      | CAU (Cautioning of Trains)          | #bb2    | Long Dashed  |
      | Multiple Restrictions Apply         | #bb2    | Short Dashed |
    Then I reset the punctuality settings
    Then the following can be seen on the Line Status restriction type settings table
      | name                                | colour  | lineStyle    |
      | BLOK (Line Blockage)                | #ff0000 | Solid        |
      | OOU (Out of Use)                    | #ffa700 | Solid        |
      | POSS (Possession)                   | #ff0000 | Long Dashed  |
      | ESR (Emergency Speed Restriction)   | #ffff00 | Short Dashed |
      | TSR (Temporary Speed Restriction)   | #ffa700 | Short Dashed |
      | BTET (Blocked to Electric Traction) | #ffc0cb | Short Dashed |
      | CAU (Cautioning of Trains)          | #ffff00 | Solid        |
      | Multiple Restrictions Apply         | #800080 | Solid        |

  Scenario: User should see the unsaved dialogue when refreshing the page without saving the changes
    When I update the Line Status path type settings table as
      | name           | colour  | lineStyle    |
      | Predicted Path | #bb2    | Short Dashed |
    And I refresh the browser
    And I confirm on browser popup
    Then the following can be seen on the Line Status path type settings table
      | name            | colour  | lineStyle |
      | Predicted Path  | #00d2ff | Solid     |

  Scenario: Update Line Status -Restriction type settings
    When I update the Line Status restriction type settings table as
      | name                  | colour  | lineStyle   |
      | BLOK (Line Blockage)  | #bb2    | Long Dashed |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status restriction type settings table
      | name                                | colour  | lineStyle    |
      | BLOK (Line Blockage)                | #bbbb22 | Long Dashed  |
      | OOU (Out of Use)                    | #ffa700 | Solid        |
      | POSS (Possession)                   | #ff0000 | Long Dashed  |
      | ESR (Emergency Speed Restriction)   | #ffff00 | Short Dashed |
      | TSR (Temporary Speed Restriction)   | #ffa700 | Short Dashed |
      | BTET (Blocked to Electric Traction) | #ffc0cb | Short Dashed |
      | CAU (Cautioning of Trains)          | #ffff00 | Solid        |
      | Multiple Restrictions Apply         | #800080 | Solid        |

  Scenario: Update Line Status -Route type settings
    When I update the Line Status route type settings table as
      | name      | colour  | lineStyle |
      | Route Set | #bb2    | Solid     |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status route type settings table
      | name      | colour  | lineStyle |
      | Route Set | #bbbb22 | Solid     |

  Scenario: Update Line Status -Path type settings
    When I update the Line Status path type settings table as
      | name           | colour  | lineStyle |
      | Predicted Path | #bb2    | Solid     |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status path type settings table
      | name            | colour  | lineStyle |
      | Predicted Path  | #bbbb22 | Solid     |
