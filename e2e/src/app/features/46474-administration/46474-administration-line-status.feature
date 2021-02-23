Feature: 46474 - Administration Display Settings - full end to end testing - line status

  As a tester
  I want to verify the administration page - Display Settings
  So, that I can identify if the build meet the end to end requirements

  Background:
    Given I am on the admin page
    And The admin setting defaults are as originally shipped

  Scenario: Line Status settings header
    Then the line settings header is displayed as 'Line Status'

  Scenario: Line Status -Restriction type settings default color and entries
    Then the following can be seen on the Line Status restriction type settings table
      | name       | colour  |
      | Blockage   | #ff0000 |
      | TSR        | #ffa700 |
      | ESR        | #ffff00 |
      | Possession | #ff0000 |
      | Not in use | #ffa700 |

  Scenario: Line Status -Route type settings default color and entries
    Then the following can be seen on the Line Status route type settings table
      | name      | colour  | lineWidth | lineStyle |
      | Route Set | #ffffff | 2         | Solid     |

  Scenario: Line Status -Path type settings default color and entries
    Then the following can be seen on the Line Status path type settings table
      | name           | colour  | lineWidth | lineStyle |
      | Predicted Path | #0000ff | 3         | Solid     |

  Scenario: Line Status -Note settings default color and entries
    Then the following can be seen on the Line Status note settings table
      | name         | colour  | lineWidth | lineStyle |
      | Note applied | #78e7ff | 2         | Solid    |

  Scenario: Line Status -Restriction type settings reset to default color and entries
    When I update the Line Status restriction type settings table as
      | name       | colour  |
      | Blockage   | #ff4    |
      | TSR        | #ffa700 |
      | ESR        | #ffff00 |
      | Possession | #ff0000 |
      | Not in use | #ffa700 |
    Then I reset the punctuality settings
    Then the following can be seen on the Line Status restriction type settings table
      | name       | colour  |
      | Blockage   | #ff0000 |
      | TSR        | #ffa700 |
      | ESR        | #ffff00 |
      | Possession | #ff0000 |
      | Not in use | #ffa700 |

  @manual
  Scenario: User should see the unsaved dialogue when refreshing the page without saving the changes
    When I update the Line Status note settings table as
      | name         | colour  | lineWidth | lineStyle |
      | Note applied | #8bb5be | 8         | Dashed    |
    And I refresh the browser
    And I confirm on browser popup
    Then the following can be seen on the Line Status note settings table
      | name         | colour  | lineWidth | lineStyle |
      | Note applied | #78e7ff | 2         | Solid    |

  Scenario: Update Line Status -Restriction type settings
    When I update the Line Status restriction type settings table as
      | name       | colour  |
      | Blockage   | #bb2    |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status restriction type settings table
      | name       | colour  |
      | Blockage   | #bbbb22 |
      | TSR        | #ffa700 |
      | ESR        | #ffff00 |
      | Possession | #ff0000 |
      | Not in use | #ffa700 |

  Scenario: Update Line Status -Route type settings
    When I update the Line Status route type settings table as
      | name      | colour  | lineWidth | lineStyle |
      | Route Set | #bb2    | 3         | Solid     |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status route type settings table
      | name      | colour  | lineWidth | lineStyle |
      | Route Set | #bbbb22 | 3         | Solid     |

  Scenario: Update Line Status -Path type settings
    When I update the Line Status path type settings table as
      | name           | colour  | lineWidth | lineStyle |
      | Predicted Path | #bb2    | 3         | Solid     |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status path type settings table
      | name            | colour  | lineWidth | lineStyle |
      | Predicted Path  | #bbbb22 | 3         | Solid     |

  Scenario: Update Line Status -Note settings
    When I update the Line Status note settings table as
      | name         | colour  | lineWidth | lineStyle |
      | Note applied | #bb2    | 8         | Dashed    |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status note settings table
      | name         | colour  | lineWidth | lineStyle |
      | Note applied | #bbbb22 | 8         | Dashed    |
