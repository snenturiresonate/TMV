@TMVPhase2 @P2.S3
Feature: 80183 - TMV Trains List Filtering - Trains List Specific Config

  As a TMV User
  I want the ability to config separate trains list filtering with enhanced functions
  So that I can set up different trains list for specific operational needs

  Background:
    * I have not already authenticated
    * I am on the admin page
    * The admin setting defaults are as originally shipped

  Scenario: 80346 - 1 Trains List Specific Config - saving a trains list config does not impact other trains lists for that user in the same session

#    Given the user is authenticated to use TMV
#    And the user is viewing the homepage
#    When the user selects a named trains list
#    And the user configures the trains list
#    And saves the configuration
#    Then the specific trains list config is saved without affecting the other trains lists

#  The user can select trains list 1, 2 or 3 with each having its own configuration

    Given I have not already authenticated
    And I access the homepage as standard user
    And I restore all train list configs for current user to the default
    When I select the trains list 2 button from the home page
    Then the number of tabs open is 2
    When I switch to the new tab
    Then I am on the trains list config 2 page
    When I save the following config changes
      | tab     | dataItem | type   | parameter | newSetting |
      | Columns | All      | remove |           |            |
      | Columns | TRUST ID | add    |           | 2nd        |
    Then I should see the trains list columns as
      | header   |
      | SERVICE  |
      | TRUST ID |
      | TIME     |
      | PUNCT.   |
    When I click on the Network Rail Home logo
    And I select the trains list 1 button from the home page
    And I switch to the new tab
    Then I am on the trains list config 1 page
    When I click on the Network Rail Home logo
    And I select the trains list 3 button from the home page
    And I switch to the new tab
    Then I am on the trains list config 3 page
    When I save the following config changes
      | tab                | dataItem | type | parameter         | newSetting |
      | Train Class & MISC | class    | edit | Class 5           | off        |
      | Train Class & MISC | class    | edit | Class 3           | off        |
    And the trains list filter is visible
    And the trains list filter display contains
      | section | type      | expectedValue          |
      | misc    | classes   | 0, 1, 2, 4, 6, 7, 8, 9 |
    When I click on the Network Rail Home logo
    And I select the trains list 2 button from the home page
    And I switch to the new tab
    Then The trains list table is visible
    And I should see the trains list columns as
      | header   |
      | SERVICE  |
      | TRUST ID |
      | TIME     |
      | PUNCT.   |
    When I click on the Network Rail Home logo
    And I select the trains list 1 button from the home page
    And I switch to the new tab
    Then I am on the trains list config 1 page

#    close down
    * I restore all train list configs for current user to the default


  Scenario: 80346 - 2 Trains List Specific Config - saved trains list config changes persist across sessions

#    Given the user is authenticated to use TMV
#    And the user is viewing the homepage
#    When the user selects a named trains list
#    And the user configures the trains list
#    And saves the configuration
#    Then the specific trains list config is saved without affecting the other trains lists

#  The system will store the config for each trains list beyond the session

    Given I have not already authenticated
    And I access the homepage as standard user
    And I restore all train list configs for current user to the default
    When I select the trains list 2 button from the home page
    Then the number of tabs open is 2
    When I switch to the new tab
    Then I am on the trains list config 2 page
    When I save the following config changes
      | tab     | dataItem | type   | parameter | newSetting |
      | Columns | All      | remove |           |            |
      | Columns | TRUST ID | add    |           | 2nd        |
    Then I should see the trains list columns as
      | header   |
      | SERVICE  |
      | TRUST ID |
      | TIME     |
      | PUNCT.   |
    When I have not already authenticated
    And I access the homepage as standard user
    And I select the trains list 1 button from the home page
    And I switch to the new tab
    Then I am on the trains list config 1 page
    When I click on the Network Rail Home logo
    And I select the trains list 2 button from the home page
    And I switch to the new tab
    Then The trains list table is visible
    And I should see the trains list columns as
      | header   |
      | SERVICE  |
      | TRUST ID |
      | TIME     |
      | PUNCT.   |

    #    close down
    * I restore all train list configs for current user to the default

  Scenario: 80346 - 3 Trains List Specific Config - saving a trains list config does not impact other trains lists for other users

#    Given the user is authenticated to use TMV
#    And the user is viewing the homepage
#    When the user selects a named trains list
#    And the user configures the trains list
#    And saves the configuration
#    Then the specific trains list config is saved without affecting the other trains lists

    Given I have not already authenticated
    And I access the homepage as restriction user
    And I restore all train list configs for current user to the default
    And I have not already authenticated
    And I access the homepage as standard user
    And I restore all train list configs for current user to the default
    When I select the trains list 2 button from the home page
    Then the number of tabs open is 2
    When I switch to the new tab
    Then I am on the trains list config 2 page
    When I save the following config changes
      | tab     | dataItem | type   | parameter | newSetting |
      | Columns | All      | remove |           |            |
      | Columns | TRUST ID | add    |           | 2nd        |
    Then I should see the trains list columns as
      | header   |
      | SERVICE  |
      | TRUST ID |
      | TIME     |
      | PUNCT.   |
    When I have not already authenticated
    And I access the homepage as restriction user
    And I select the trains list 3 button from the home page
    And I switch to the new tab
    Then I am on the trains list config 3 page
    When I click on the Network Rail Home logo
    And I select the trains list 2 button from the home page
    And I switch to the new tab
    Then I am on the trains list config 2 page
    When I save the following config changes
      | tab       | dataItem | type | parameter | newSetting |
      | Locations | PADTON   | add  | All       | unchecked  |
      | Locations | PADTON   | edit | Originate | checked    |
    Then the trains list filter is visible
    And the trains list filter display contains
      | section   | type     | expectedValue |
      | selection | LOCATION | PADTON        |
    When I click on the Network Rail Home logo
    And I select the trains list 3 button from the home page
    And I switch to the new tab
    Then I am on the trains list config 3 page
    When I save the following config changes
      | tab     | dataItem             | type   | parameter | newSetting |
      | Columns | All                  | remove |           |            |
      | Columns | Origin (TIPLOC)      | add    |           | 4th        |
      | Columns | Destination (TIPLOC) | add    |           | 5th        |
    Then I should see the trains list columns as
      | header       |
      | SERVICE      |
      | TIME         |
      | PUNCT.       |
      | ORIGIN (TPL) |
      | DEST. (TPL)  |
    When I have not already authenticated
    And I access the homepage as standard user
    And I select the trains list 1 button from the home page
    And I switch to the new tab
    Then I am on the trains list config 1 page
    When I click on the Network Rail Home logo
    And I select the trains list 2 button from the home page
    And I switch to the new tab
    Then The trains list table is visible
    And I should see the trains list columns as
      | header   |
      | SERVICE  |
      | TRUST ID |
      | TIME     |
      | PUNCT.   |
    When I click on the Network Rail Home logo
    And I select the trains list 3 button from the home page
    And I switch to the new tab
    Then I am on the trains list config 3 page

    #  Close down
    * I restore all train list configs for current user to the default
    * I have not already authenticated
    * I access the homepage as restriction user
    * I restore all train list configs for current user to the default
