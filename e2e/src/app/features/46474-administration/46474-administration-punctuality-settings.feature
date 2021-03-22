Feature: 46474 - Administration Display Settings - full end to end testing - punctuality settings

  As a tester
  I want to verify the administration page - Display Settings
  So, that I can identify if the build meet the end to end requirements

  Background:
    Given I am on the admin page
    And The admin setting defaults are as originally shipped
    And I reset the punctuality settings

  Scenario: Admin punctuality settings table header
    Then the admin punctuality header is displayed as 'Punctuality'

  Scenario: Admin punctuality settings default color and entries
    And I have navigated to the 'Display Settings' admin tab
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ffb4b4              |          | -20    | 20 minutes or more early |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  @manual
  Scenario: Admin punctuality settings default color and entries updated and reset
    And I have navigated to the 'Display Settings' admin tab
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ffb4b4              |          | -20    | 20 minutes or more early |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |
    When I add punctuality time-bands until count of 11
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ddd                 |          | -22    | 22 minutes or more early |
      | #ddd                 | -22      | -21    | 21 to 22 minutes early   |
      | #ffb4b4              | -21      | -20    | 20 to 21 minutes early   |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |
    And I reset the punctuality settings
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ffb4b4              |          | -20    | 20 minutes or more early |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  Scenario: User should be able to add a punctuality time-band
    When I add a punctuality time-band
    And I save the punctuality settings
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #dddddd              |          | -21    | 21 minutes or more early |
      | #ffb4b4              | -21      | -20    | 20 to 21 minutes early   |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  Scenario: User should be able to add, edit and save a punctuality time-band
    When I add a punctuality time-band
    And I update the admin punctuality settings as
      | punctualityColorText | fromTime | toTime | entryValue      |
      | #dddddd              |          | -21    | Time band Added |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue              |
      | #dddddd              |          | -21    | Time band Added         |
      | #ffb4b4              | -21      | -20    | 20 to 21 minutes early  |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  Scenario: User should be able to delete, edit and save a punctuality time-band
    When I delete the first punctuality time-band
    And I save the punctuality settings
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue              |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  @manual
  Scenario: User should see the unsaved dialogue when refreshing the page without saving the changes
    When I add a punctuality time-band
    And I edit the display name of the added time band as "Time band Added"
    And I refresh the browser
    And I confirm on browser popup
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue               |
      | #ffb4b4              |          | -20    | 20 minutes or more early |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  @manual
  Scenario: User should see the unsaved dialogue when closing the page without saving the changes
    When I add a punctuality time-band
    And I edit the display name of the added time band as "Time band Added"
    And I refresh the browser
    And I cancel on browser popup
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue              |
      | #ddd                 |          | -21    | Time band Added         |
      | #ffb4b4              | -21      | -20    | 20 to 21 minutes early  |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |
    And I reset the punctuality settings

  @manual
  Scenario: User should see the unsaved dialogue when closing the page without saving the changes
    When I add a punctuality time-band
    And I edit the display name of the added time band as "Time band Added"
    And I close the browser
    And I cancel on browser popup
    Then the following can be seen on the admin punctuality settings table
      | punctualityColorText | fromTime | toTime | entryValue              |
      | #bbbb22              |          | -21    | Time band Added         |
      | #ffb4b4              | -21      | -20    | 20 to 21 minutes early  |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     |
      | #00ff00              | -1       | 1      | Right Time               |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    |
      | #ff009c              | 20       |        | 20 minutes or more late  |

  Scenario: User should be able to add a maximum of 20 time-bands
    When I add punctuality time-bands until count of 20
    Then I should not be able to add any more punctuality time-bands
    When I save the punctuality settings
    Then I should not be able to add any more punctuality time-bands
