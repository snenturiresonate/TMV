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
      | name                                | colour  |
      | BLOK (Line Blockage)                | #ff0000 |
      | OOU (Out Of Use)                    | #ffa700 |
      | POSS (Possession)                   | #ff0000 |
      | ESR (Emergency Speed Restriction)   | #ffff00 |
      | TSR (Temporary Speed Restriction)   | #ffa700 |
      | BTET (Blocked to Electric Traction) | #ffc0cb |
      | CAU (Cautioning of Trains)          | #ffff00 |
      | Multiple Restrictions Apply         | #800080 |

  Scenario: Line Status -Route type settings default color and entries
    Then the following can be seen on the Line Status route type settings table
      | name      | colour  | lineStyle |
      | Route Set | #ffffff | Solid     |

  Scenario: Line Status -Path type settings default color and entries
    Then the following can be seen on the Line Status path type settings table
      | name           | colour  | lineStyle |
      | Predicted Path | #0000ff | Solid     |

  Scenario: Line Status -Restriction type settings reset to default color and entries
    When I update the Line Status restriction type settings table as
      | name                                | colour  |
      | BLOK (Line Blockage)                | #bb2    |
      | OOU (Out Of Use)                    | #bb2    |
      | POSS (Possession)                   | #bb2    |
      | ESR (Emergency Speed Restriction)   | #bb2    |
      | TSR (Temporary Speed Restriction)   | #bb2    |
      | BTET (Blocked to Electric Traction) | #bb2    |
      | CAU (Cautioning of Trains)          | #bb2    |
      | Multiple Restrictions Apply         | #bb2    |
    Then I reset the punctuality settings
    Then the following can be seen on the Line Status restriction type settings table
      | name                                | colour  |
      | BLOK (Line Blockage)                | #ff0000 |
      | OOU (Out Of Use)                    | #ffa700 |
      | POSS (Possession)                   | #ff0000 |
      | ESR (Emergency Speed Restriction)   | #ffff00 |
      | TSR (Temporary Speed Restriction)   | #ffa700 |
      | BTET (Blocked to Electric Traction) | #ffc0cb |
      | CAU (Cautioning of Trains)          | #ffff00 |
      | Multiple Restrictions Apply         | #800080 |

  Scenario: User should see the unsaved dialogue when refreshing the page without saving the changes
    When I update the Line Status path type settings table as
      | name           | colour  | lineStyle    |
      | Predicted Path | #bb2    | Short Dashed |
    And I refresh the browser
    And I confirm on browser popup
    Then the following can be seen on the Line Status path type settings table
      | name            | colour  | lineStyle |
      | Predicted Path  | #0000ff | Solid     |

  Scenario: Update Line Status -Restriction type settings
    When I update the Line Status restriction type settings table as
      | name                  | colour  |
      | BLOK (Line Blockage)  | #bb2    |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status restriction type settings table
      | name                                | colour  |
      | BLOK (Line Blockage)                | #bbbb22 |
      | OOU (Out Of Use)                    | #ffa700 |
      | POSS (Possession)                   | #ff0000 |
      | ESR (Emergency Speed Restriction)   | #ffff00 |
      | TSR (Temporary Speed Restriction)   | #ffa700 |
      | BTET (Blocked to Electric Traction) | #ffc0cb |
      | CAU (Cautioning of Trains)          | #ffff00 |
      | Multiple Restrictions Apply         | #800080 |

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
