@TMVPhase2 @P2.S3
Feature: 80331 - TMV Trains List Interaction - Filter Display First Time

  As a TMV User
  I want the ability to interact with the trains list
  So that I can access additional functions or information

  Background:
    * I have not already authenticated
    * I access the homepage as standard user
    * I restore all train list configs for current user to the default

  Scenario: 80341 - Trains List Interaction - Filter Display First Time

#    Given the user is authenticated to use TMV
#    When the user selects a named trains list for the first time
#    And has configured the trains list
#    Then the system will display a trains list with the filters expanded

    Given I select the trains list 1 button from the home page
    And I switch to the new tab
    When I save the following config changes
      | tab     | dataItem | type   | parameter | newSetting |
      | Columns | All      | remove |           |            |
      | Columns | TRUST ID | add    |           | 2nd        |
    Then The trains list table is visible
    And the trains list filter is visible

