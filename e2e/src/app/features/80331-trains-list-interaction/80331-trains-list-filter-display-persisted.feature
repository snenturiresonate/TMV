@TMVPhase2 @P2.S3
Feature: 80331 - TMV Trains List Interaction - Filter Display Persisted

  As a TMV User
  I want the ability to interact with the trains list
  So that I can access additional functions or information

  Background:
    * I have not already authenticated
    * I access the homepage as standard user
    * I restore all train list configs for current user to the default

  Scenario: 80342 - 1 Trains List Interaction - Filter Display Persisted on subsequent login for each list

#    Given the user is authenticated to use TMV
#    And the user is viewing a trains list
#    When the user expands or collapses the filters
#    Then the system will retain this filter display preference between sessions for each named trains list

#  Each trains list will retain its own filter display preference

    # Set up filter to be collapsed for list 1
    Given I select the trains list 1 button from the home page
    And I switch to the new tab
    And I save the following config changes
      | tab     | dataItem | type   | parameter | newSetting |
      | Columns | All      | remove |           |            |
      | Columns | TRUST ID | add    |           | 2nd        |
    And the trains list filter is visible
    And I set the trains list filter display to be collapsed
    And the trains list filter isn't visible

    # Set up filter to be expanded for list 2
    And I click on the Network Rail Home logo
    And I select the trains list 2 button from the home page
    And I switch to the new tab
    And I save the following config changes
      | tab         | dataItem | type | parameter | newSetting |
      | Punctuality | Band4    | edit | colour    | #82e       |
      | Punctuality | Band7    | edit | toTime    | +2         |
      | Punctuality | Band8    | edit | fromTime  | +2         |
    And the trains list filter is visible
    And I set the trains list filter display to be collapsed
    And I set the trains list filter display to be expanded
    And the trains list filter is visible
    And I logout

    When I access the homepage as standard user
    And I select the trains list 1 button from the home page
    And I switch to the new tab
    Then The trains list table is visible
    And the trains list filter isn't visible
    When I click on the Network Rail Home logo
    And I select the trains list 2 button from the home page
    And I switch to the new tab
    Then The trains list table is visible
    Then the trains list filter is visible


  Scenario: 80342 - 2 Trains List Interaction - Filter Display Persisted on refresh

#    Given the user is authenticated to use TMV
#    And the user is viewing a trains list
#    When the user expands or collapses the filters
#    Then the system will retain this filter display preference between sessions for each named trains list

#  Each trains list will retain its own filter display preference

    # Set up filter to be collapsed for list 1
    Given I select the trains list 1 button from the home page
    And I switch to the new tab
    And I save the following config changes
      | tab     | dataItem                   | type | parameter | newSetting |
      | TOC/FOC | GREAT WESTERN RAILWAY (EF) | add  |           |            |
    And the trains list filter is visible
    And I set the trains list filter display to be collapsed
    And the trains list filter isn't visible
    And I refresh the browser
    And I give the UI 2 seconds to fully refresh
    And the trains list filter isn't visible


    # Set up filter to be expanded for list 2
    And I click on the Network Rail Home logo
    And I select the trains list 2 button from the home page
    And I switch to the new tab
    And I save the following config changes
      | tab              | dataItem   | type | parameter | newSetting |
      | Train Indication | Indicator2 | edit | toggle    | off        |
      | Train Indication | Indicator6 | edit | value     | -3         |
      | Train Indication | Indicator7 | edit | colour    | #82e       |
      | Train Indication | Indicator8 | edit | value     | +3         |
    And the trains list filter is visible
    And I set the trains list filter display to be collapsed
    And I set the trains list filter display to be expanded
    And the trains list filter is visible
    When I refresh the browser
    And I give the UI 2 seconds to fully refresh
    Then the trains list filter is visible

