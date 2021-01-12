Feature: 33806 - TMV User Preferences - full end to end testing

  As a tester
  I want to verify the train list page
  So, that I can identify if the build meets the end to end requirements

  #33806 -1 Trains List Config View
  #Given the user is viewing the trains list
  #When the user selects the trains list config icon
  #Then the trains list config is opened in a new browser tab (default: columns tab)

  Background:
    Given I am on the home page

  Scenario: Trains List page - Tab title
    When I click the app 'trains-list'
    And I switch to the new tab
    Then the tab title is 'TMV Trains List'

  Scenario: Trains List page - Trains list Table
    When I click the app 'trains-list'
    And I switch to the new tab
    Then The trains list table is visible

  Scenario: Trains list table - Default columns
    When I click the app 'trains-list'
    And I switch to the new tab
    Then I should see the trains list columns as
      | header           |
      | SCHED.           |
      | SERVICE          |
      | TIME             |
      | REPORT           |
      | PUNCT.           |
      | ORIGIN           |
      | PLANNED          |
      | ACTUAL / PREDICT |
      | DEST.            |
      | PLANNED          |
      | ACTUAL / PREDICT |
      | NEXTLOC.         |
      | TOC/FOC          |

  Scenario: Trains list config - Tab title
    When I click the app 'trains-list'
    And I switch to the new tab
    And I navigate to train list configuration
    And I switch to the new tab
    Then the tab title is 'TMV Trains List Config'

  Scenario: Trains list config - Config Tabs
    When I click the app 'trains-list'
    And I switch to the new tab
    And I navigate to train list configuration
    And I switch to the new tab
    Then I should see the trains list configuration tabs as
      | tabs             |
      | Columns          |
      | Punctuality      |
      | TOC/FOC          |
      | Locations        |
      | Train Indication |
      | Misc             |
      | TRUST IDs        |
      | Region/Route     |