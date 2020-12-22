Feature: 46474 - Administration Display Settings - full end to end testing

  As a tester
  I want to verify the administration page - Display Settings
  So, that I can identify if the build meet the end to end requirements

  #33767-4 Navigating to Display Settings view
  #Given that I have the admin screen open on a tab other than the Display settings view
  #When I select the Display settings option
  #Then the Display settings view tab is highlighted
  #And the Display settings are displayed (Punctuality, Berth Colours, Line Status, Trains List Indication, )

  #33767- 5 Editing Display Settings
  #Given that I have the admin screen open on the Display settings view
  #When I change the Punctuality, Berth Colours, Line Status and Trains List Indication,
  #Then the values I entered are displayed
  #And the unsaved changed indicator is displayed on the Display Settings tab

  Background:
    Given I am on the admin page

    #Punctuality settings
  Scenario: Admin punctuality settings table header
    Then the admin punctuality header is displayed as 'Punctuality'

  Scenario: Admin punctuality settings default color and entries
    And I refresh the browser
    And I have navigated to the 'Display Settings' admin tab
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ffb4b4              |          | -20    | 20 minutes or more early |
      | #e5b4ff              | -19      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -9       | -5     | 5 to 9 minutes early     |
      | #78ff78              | -4       | -1     | 1 to 4 minutes early     |
      | #00ff00              | 0        | 0      | Right Time               |
      | #ffff00              | 1        | 4      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 9      | 5 to 9 minutes late      |
      | #ff0000              | 10       | 19     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  Scenario: Admin punctuality settings default color and entries updated and reset
    And I refresh the browser
    And I have navigated to the 'Display Settings' admin tab
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ffb4b4              |          | -20    | 20 minutes or more early |
      | #e5b4ff              | -19      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -9       | -5     | 5 to 9 minutes early     |
      | #78ff78              | -4       | -1     | 1 to 4 minutes early     |
      | #00ff00              | 0        | 0      | Right Time               |
      | #ffff00              | 1        | 4      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 9      | 5 to 9 minutes late      |
      | #ff0000              | 10       | 19     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |
    When I add punctuality time-bands until count of 11
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ddd                 |          | -22    | 22 minutes or more early |
      | #ddd                 | -22      | -21    | 21 to 22 minutes early   |
      | #ffb4b4              | -21      | -20    | 20 to 21 minutes early   |
      | #e5b4ff              | -19      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -9       | -5     | 5 to 9 minutes early     |
      | #78ff78              | -4       | -1     | 1 to 4 minutes early     |
      | #00ff00              | 0        | 0      | Right Time               |
      | #ffff00              | 1        | 4      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 9      | 5 to 9 minutes late      |
      | #ff0000              | 10       | 19     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |
    And I reset the punctuality settings
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ffb4b4              |          | -20    | 20 minutes or more early |
      | #e5b4ff              | -19      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -9       | -5     | 5 to 9 minutes early     |
      | #78ff78              | -4       | -1     | 1 to 4 minutes early     |
      | #00ff00              | 0        | 0      | Right Time               |
      | #ffff00              | 1        | 4      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 9      | 5 to 9 minutes late      |
      | #ff0000              | 10       | 19     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  Scenario: User should be able to add a punctuality time-band
    When I add a punctuality time-band
    And I save the punctuality settings
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ddd                 |          | -21    | 21 minutes or more early |
      | #ffb4b4              | -21      | -20    | 20 to 21 minutes early   |
      | #e5b4ff              | -19      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -9       | -5     | 5 to 9 minutes early     |
      | #78ff78              | -4       | -1     | 1 to 4 minutes early     |
      | #00ff00              | 0        | 0      | Right Time               |
      | #ffff00              | 1        | 4      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 9      | 5 to 9 minutes late      |
      | #ff0000              | 10       | 19     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  Scenario: User should be able to update punctuality settings and save
    When I update the admin punctuality settings as
      | punctualityColorText | fromTime | toTime | entryValue                   |
      | #bb2                 |          | -21    | 21 to 22 minutes early-edit  |
      | #cc3                 | -20      | -11    | 11 to 20 minutes early-edit  |
      | #dde                 | -10      | -5     | 5 to 10 minutes early-edit   |
      | #ff7                 | -4       | -1     | 1 to 4 minutes early-edit    |
      | #aac                 | 0        | 0      | Right Time                   |
      | #bbc                 | 1        | 5      | 1 to 5 minutes late-edit     |
      | #c4d                 | 6        | 10     | 6 to 10 minutes late-edit    |
      | #de7                 | 11       | 20     | 11 to 20 minutes late-edit   |
      | #ff6                 | 21       |        | 21 minutes or more late-edit |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue                   |
      | #bbbb22              |          | -21    | 21 to 22 minutes early-edit  |
      | #cccc33              | -20      | -11    | 11 to 20 minutes early-edit  |
      | #ddddee              | -10      | -5     | 5 to 10 minutes early-edit   |
      | #ffff77              | -4       | -1     | 1 to 4 minutes early-edit    |
      | #aaaacc              | 0        | 0      | Right Time                   |
      | #bbbbcc              | 1        | 5      | 1 to 5 minutes late-edit     |
      | #cc44dd              | 6        | 10     | 6 to 10 minutes late-edit    |
      | #ddee77              | 11       | 20     | 11 to 20 minutes late-edit   |
      | #ffff66              | 21       |        | 21 minutes or more late-edit |

  Scenario: User should be able to add a maximum of 20 time-bands
    When I add punctuality time-bands until count of 20
    Then I should not be able to add any more punctuality time-bands
    When I save the punctuality settings
    Then I should not be able to add any more punctuality time-bands


  Scenario: User should be able to add, edit and save a punctuality time-band
    When I add a punctuality time-band
    And I edit the display name of the added time band as "Time band Added"
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue              |
      | #ddd                 |          | -21    | Time band Added         |
      | #ffb4b4              | -21      | -20    | 20 to 21 minutes early  |
      | #e5b4ff              | -19      | -10    | 10 to 19 minutes early  |
      | #78e7ff              | -9       | -5     | 5 to 9 minutes early    |
      | #78ff78              | -4       | -1     | 1 to 4 minutes early    |
      | #00ff00              | 0        | 0      | Right Time              |
      | #ffff00              | 1        | 4      | 1 to 4 minutes late     |
      | #ffa700              | 5        | 9      | 5 to 9 minutes late     |
      | #ff0000              | 10       | 19     | 10 to 19 minutes late   |
      | #ff009c              | 20       |        | 20 minutes or more late |

  Scenario: User should be able to delete, edit and save a punctuality time-band
    When I delete the first punctuality time-band
    And I save the punctuality settings
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue              |
      | #e5b4ff              | -19      | -10    | 10 to 19 minutes early  |
      | #78e7ff              | -9       | -5     | 5 to 9 minutes early    |
      | #78ff78              | -4       | -1     | 1 to 4 minutes early    |
      | #00ff00              | 0        | 0      | Right Time              |
      | #ffff00              | 1        | 4      | 1 to 4 minutes late     |
      | #ffa700              | 5        | 9      | 5 to 9 minutes late     |
      | #ff0000              | 10       | 19     | 10 to 19 minutes late   |
      | #ff009c              | 20       |        | 20 minutes or more late |

  Scenario: User should see the unsaved dialogue when refreshing the page without saving the changes
    When I add a punctuality time-band
    And I edit the display name of the added time band as "Time band Added"
    And I refresh the browser
    And I confirm on browser popup
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ffb4b4              |          | -20    | 20 minutes or more early |
      | #e5b4ff              | -19      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -9       | -5     | 5 to 9 minutes early     |
      | #78ff78              | -4       | -1     | 1 to 4 minutes early     |
      | #00ff00              | 0        | 0      | Right Time               |
      | #ffff00              | 1        | 4      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 9      | 5 to 9 minutes late      |
      | #ff0000              | 10       | 19     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  Scenario: User should see the unsaved dialogue when closing the page without saving the changes
    When I add a punctuality time-band
    And I edit the display name of the added time band as "Time band Added"
    And I refresh the browser
    And I cancel on browser popup
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue              |
      | #ddd                 |          | -21    | Time band Added         |
      | #ffb4b4              | -21      | -20    | 20 to 21 minutes early  |
      | #e5b4ff              | -19      | -10    | 10 to 19 minutes early  |
      | #78e7ff              | -9       | -5     | 5 to 9 minutes early    |
      | #78ff78              | -4       | -1     | 1 to 4 minutes early    |
      | #00ff00              | 0        | 0      | Right Time              |
      | #ffff00              | 1        | 4      | 1 to 4 minutes late     |
      | #ffa700              | 5        | 9      | 5 to 9 minutes late     |
      | #ff0000              | 10       | 19     | 10 to 19 minutes late   |
      | #ff009c              | 20       |        | 20 minutes or more late |
    And I reset the punctuality settings

  @bug
  Scenario: User should see the unsaved dialogue when closing the page without saving the changes
    When I add a punctuality time-band
    And I edit the display name of the added time band as "Time band Added"
    And I close the browser
    And I cancel on browser popup
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue              |
      | #ddd                 |          | -21    | Time band Added         |
      | #ffb4b4              | -21      | -20    | 20 to 21 minutes early  |
      | #e5b4ff              | -19      | -10    | 10 to 19 minutes early  |
      | #78e7ff              | -9       | -5     | 5 to 9 minutes early    |
      | #78ff78              | -4       | -1     | 1 to 4 minutes early    |
      | #00ff00              | 0        | 0      | Right Time              |
      | #ffff00              | 1        | 4      | 1 to 4 minutes late     |
      | #ffa700              | 5        | 9      | 5 to 9 minutes late     |
      | #ff0000              | 10       | 19     | 10 to 19 minutes late   |
      | #ff009c              | 20       |        | 20 minutes or more late |

    #Trains Indication
  Scenario: Trains indication table header
    Then the train indication header is displayed as 'Trains List Indication'

  Scenario: Trains indication table
    Then the following can be seen on the trains list indication table
      | name                     | colour  | minutes | toggleValue |
      | Change of Origin         | #cccc00 |         | on          |
      | Change of Identity       | #ccff66 |         | off         |
      | Cancellation             | #00ff00 |         | on          |
      | Reinstatement            | #00ffff |         | off         |
      | Off-route                | #cc6600 |         | on          |
      | Next report overdue      | #ffff00 | 10      | off         |
      | Origin Called            | #9999ff | 50      | on          |
      | Origin Departure Overdue | #339966 | 20      | on          |

  Scenario: Trains indication table - Update and Save
    When I update the train list indication table as
      | name                     | colour | minutes | toggleValue |
      | Change of Origin         | #bb2   |         | on          |
      | Change of Identity       | #cc3   |         | on          |
      | Cancellation             | #dde   |         | off         |
      | Reinstatement            | #ff7   |         | off         |
      | Off-route                | #aac   |         | on          |
      | Next report overdue      | #bbc   | 15      | off         |
      | Origin Called            | #995   | 60      | on          |
      | Origin Departure Overdue | #356   | 10      | on          |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the trains list indication table
      | name                     | colour  | minutes | toggleValue |
      | Change of Origin         | #bbbb22 |         | on          |
      | Change of Identity       | #cccc33 |         | on          |
      | Cancellation             | #ddddee |         | off         |
      | Reinstatement            | #ffff77 |         | off         |
      | Off-route                | #aaaacc |         | on          |
      | Next report overdue      | #bbbbcc | 15      | off         |
      | Origin Called            | #999955 | 60      | on          |
      | Origin Departure Overdue | #335566 | 10      | on          |

    #Berth Settings
  Scenario: Berth settings header
    Then the berth settings header is displayed as 'Berth Colours'

  Scenario: Berth colour settings default color and entries
    Then the following can be seen on the berth color settings table
      | name          | colour  | toggleState |
      | Attention     | #2b78e4 | On          |
      | Unknown Delay | #fff    | On          |
      | No Timetable  | #dddddd | On          |
      | Left Behind   | #999999 | On          |
      | Last Berth    | #f9cb9c | On          |

  Scenario: Berth colour settings - Update and Save
    When I update the Berth settings table as
      | name          | colour | toggleState |
      | Attention     | #bb2   | On          |
      | Unknown Delay | #cc3   | On          |
      | No Timetable  | #dde   | On          |
      | Left Behind   | #ff7   | On          |
      | Last Berth    | #356   | On          |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the berth color settings table
      | name          | colour  | toggleState |
      | Attention     | #bbbb22 | On          |
      | Unknown Delay | #cccc33 | On          |
      | No Timetable  | #ddddee | On          |
      | Left Behind   | #ffff77 | On          |
      | Last Berth    | #335566 | On          |

    #Line Status Settings
  Scenario: Line Status settings header
    Then the line settings header is displayed as 'Line Status'

  Scenario: Line Status -Restriction type settings default color and entries
    Then the following can be seen on the Line Status restriction type settings table
      | name       | colour  |
      | Blockage   | #e5b4ff |
      | Not in use | #78e7ff |
      | ESR        | #ffff00 |
      | TSR        | #00ff00 |
      | Possession | #ffa700 |

  Scenario: Line Status -Route type settings default color and entries
    Then the following can be seen on the Line Status route type settings table
      | name      | colour  | lineWidth | lineStyle |
      | Route On  | #e5b4ff | 1         | Dashed    |
      | Route Off | #ffb4b4 | 2         | Solid     |

  Scenario: Line Status -Path type settings default color and entries
    Then the following can be seen on the Line Status path type settings table
      | name     | colour  | lineWidth | lineStyle |
      | Path On  | #78e7ff | 4         | Solid     |
      | Path Off | #ffb4b4 | 2         | Dashed    |

  Scenario: Line Status -Note settings default color and entries
    Then the following can be seen on the Line Status note settings table
      | name         | colour  | lineWidth | lineStyle |
      | Note applied | #78e7ff | 2         | Solid    |

  Scenario: Line Status -Restriction type settings reset to default color and entries
    When I update the Line Status restriction type settings table as
      | name       | colour  |
      | Blockage   | #85549f |
      | Not in use | #829397 |
      | ESR        | #35351a |
      | TSR        | #87e787 |
      | Possession | #6c675d |
    Then I reset the punctuality settings
    Then the following can be seen on the Line Status restriction type settings table
      | name       | colour  |
      | Blockage   | #e5b4ff |
      | Not in use | #78e7ff |
      | ESR        | #ffff00 |
      | TSR        | #00ff00 |
      | Possession | #ffa700 |

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
      | Blockage   | #bb2 |
      | Not in use | #cc3 |
      | ESR        | #dde |
      | TSR        | #ff7 |
      | Possession | #356 |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status restriction type settings table
      | name       | colour  |
      | Blockage   | #bbbb22 |
      | Not in use | #cccc33 |
      | ESR        | #ddddee |
      | TSR        | #ffff77 |
      | Possession | #335566 |

  Scenario: Update Line Status -Route type settings
    When I update the Line Status route type settings table as
      | name      | colour  | lineWidth | lineStyle |
      | Route On  | #bb2 | 5         | Dashed    |
      | Route Off | #cc3 | 6         | Solid    |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status route type settings table
      | name      | colour  | lineWidth | lineStyle |
      | Route On  | #bbbb22 | 5         | Dashed    |
      | Route Off | #cccc33 | 6         | Solid     |

  Scenario: Update Line Status -Path type settings
    When I update the Line Status path type settings table as
      | name      | colour  | lineWidth | lineStyle |
      | Path On  | #bb2 | 5         | Dashed    |
      | Path Off | #cc3 | 6         | Solid    |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status path type settings table
      | name     | colour  | lineWidth | lineStyle |
      | Path On  | #bbbb22 | 5         | Dashed     |
      | Path Off | #cccc33 | 6         | Solid    |

  Scenario: Update Line Status -Note settings
    When I update the Line Status note settings table as
      | name         | colour  | lineWidth | lineStyle |
      | Note applied | #bb2 | 8         | Dashed    |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the Line Status note settings table
      | name         | colour  | lineWidth | lineStyle |
      | Note applied | #bbbb22 | 8         | Dashed    |


