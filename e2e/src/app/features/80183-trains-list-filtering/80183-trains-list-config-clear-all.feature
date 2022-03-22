@TMVPhase2 @P2.S3
Feature: Feature: 80183 - TMV Trains List Filtering - Config - Clear All option

  As a TMV user
  I want the ability option to clear trains list configuration
  so that I have a quick method of changing multiple config settings

#
#  Given the user is authenticated to use TMV
#  When the user views the trains list config
#  Then the user has the ability clear all option for TOC/FOC, Location or Punctuality config areas
#

  Background:
    * I have not already authenticated
    Given I am on the home page
    And I restore to default train list config '1'
    And I am on the trains list page 1

  Scenario: 80343-1 - User can clear all TOC/FOC parameters
    Given I have navigated to the 'TOC/FOC' configuration tab
    And I set toc filters to be 'AMEY (RE),EUROSTAR INTL (GA),Swanage Railway (SG)'
    Then the following appear in the selected railway undertaking config
      | selectedColumn                      |
      | AMEY (RE)                           |
      | EUROSTAR INTL (GA)                  |
      | Swanage Railway (SG)                |
    When I click the Clear All selected railway undertakings button
    Then the selected railway undertaking column should be empty
    # the following was added as a result of @bug @bug:91938
    * I click the Reset railway undertakings button

  Scenario: 80343-2 - User can clear all Location parameters
    Given I have navigated to the 'Locations' configuration tab
    And I choose the location filter as 'All locations, order applied'
    And I have only the following locations and stop types selected
      | locationNameValue | Originate  | Stop       | Pass       | Terminate  |
      | PADTON            | Checked    | un-checked | un-checked | un-checked |
      | SLOUGH            | Checked    | un-Checked | checked    | unchecked  |
    Then the following can be seen on the location order type table
      | locationNameValue | Originate  | Stop       | Pass       | Terminate  |
      | PADTON            | Checked    | un-checked | un-checked | un-checked |
      | SLOUGH            | Checked    | un-Checked | checked    | unchecked  |
    When I click the Clear All selected locations button
    Then the location filter table should be empty
    # the following was added as a result of @bug @bug:91938
    * I click the Reset locations button

  Scenario: 80343-3 - User can include and exclude all Punctualities
    Given I have navigated to the 'Punctuality' configuration tab
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue               | include |
      | #ffb4b4              |          | -20    | 20 minutes or more early | on      |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   | on      |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     | on      |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     | on      |
      | #00ff00              | -1       | 1      | On Time                  | on      |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      | on      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      | on      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    | on      |
      | #ff009c              | 20       |        | 20 minutes or more late  | on      |
    When I toggle the include or exclude all punctualities to 'off'
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue               | include |
      | #ffb4b4              |          | -20    | 20 minutes or more early | off     |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   | off     |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     | off     |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     | off     |
      | #00ff00              | -1       | 1      | On Time                  | off     |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      | off     |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      | off     |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    | off     |
      | #ff009c              | 20       |        | 20 minutes or more late  | off     |
    When I toggle the include or exclude all punctualities to 'on'
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue               | include |
      | #ffb4b4              |          | -20    | 20 minutes or more early | on      |
      | #e5b4ff              | -20      | -10    | 10 to 19 minutes early   | on      |
      | #78e7ff              | -10      | -5     | 5 to 9 minutes early     | on      |
      | #78ff78              | -5       | -1     | 1 to 4 minutes early     | on      |
      | #00ff00              | -1       | 1      | On Time                  | on      |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      | on      |
      | #ffa700              | 5        | 10     | 5 to 9 minutes late      | on      |
      | #ff0000              | 10       | 20     | 10 to 19 minutes late    | on      |
      | #ff009c              | 20       |        | 20 minutes or more late  | on      |
    * I click the Reset punctualities button

  Scenario: 80343-4 - Include or exclude Punctuality toggle should override existing user settings
    Given I have navigated to the 'Punctuality' configuration tab
    When I update the trains list punctuality settings as
      | punctualityColorText | fromTime | toTime | entryValue               | include |
      | #bb44bb              |          | -20    | 20 minutes or more early | on      |
      | #bb44ff              | -20      | -10    | 10 to 19 minutes early   | off     |
      | #ee77ff              | -10      | -5     | 5 to 9 minutes early     | on      |
      | #ffff77              | -5       | -1     | 1 to 4 minutes early     | on      |
      | #ffff00              | -1       | 1      | On Time                  | off     |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      | on      |
      | #aa7700              | 5        | 10     | 5 to 9 minutes late      | on      |
      | #000000              | 10       | 20     | 10 to 19 minutes late    | on      |
      | #000099              | 20       |        | 20 minutes or more late  | off     |
    And I toggle the include or exclude all punctualities to 'off'
    Then the following can be seen on the punctuality table
      | punctualityColorText | fromTime | toTime | entryValue               | include |
      | #bb44bb              |          | -20    | 20 minutes or more early | off     |
      | #bb44ff              | -20      | -10    | 10 to 19 minutes early   | off     |
      | #ee77ff              | -10      | -5     | 5 to 9 minutes early     | off     |
      | #ffff77              | -5       | -1     | 1 to 4 minutes early     | off     |
      | #ffff00              | -1       | 1      | On Time                  | off     |
      | #ffff00              | 1        | 5      | 1 to 4 minutes late      | off     |
      | #aa7700              | 5        | 10     | 5 to 9 minutes late      | off     |
      | #000000              | 10       | 20     | 10 to 19 minutes late    | off     |
      | #000099              | 20       |        | 20 minutes or more late  | off     |
    * I click the Reset punctualities button
