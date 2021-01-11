Feature: 33806 - TMV User Preferences - full end to end testing

  As a tester
  I want to verify the train list config tab - punctuality
  So, that I can identify if the build meets the end to end requirements

  #33806 -5 Trains List Config (Punctuality Settings View)
  #Given the user is viewing the trains list config
  #When the user selects the punctuality view
  #Then the user is presented with the punctuality settings view (defaulted to system settings)

  Background:
    Given I am on the trains list Config page
    And I have navigated to the 'Punctuality' configuration tab

  Scenario: Trains list punctuality config header
    Then the punctuality header is displayed as 'Punctuality'

  Scenario: Trains list punctuality config default color and entries
    Then the following can be seen on the punctuality table
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
