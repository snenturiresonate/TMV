Feature: 33768-2: TMV User Management
  As a TMV user
  I want to be able to log into the TMV application
  so that I can access functionality that the is appropriate for my role

  Background:
    Given I have not already authenticated

  Scenario Outline: 6. Displaying generic icons available for all users - <role>
    #    Given I am on the sign in screen
    #    And I have a valid TMV role of <Role Type>
    #    When I enter a valid username and password combination
    #    Then I am presented with the 'Home' Icon, 'New Tab' icon, 'User Profile' icon, 'Help' icon and Time
    #
    #    Examples:
    #      | Role Type |
    #      | Standard|
    #      | Admin|
    #      | Restrictions |
    #      | Schedule Matching|
    When I access the homepage as <role>
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    * the home icon is displayed
    * the new tab icon is displayed
    * the user profile icon is displayed
    * the help icon is displayed
    * the time is displayed
    # clean up
    * I have not already authenticated

    Examples:
      | role             |
      | adminOnly        |
      | restriction      |
      | standard         |
      | schedulematching |

  Scenario: 7. Displaying icons for  Admin role
    #    Given I am on the sign in screen
    #    And I have a valid TMV admin role
    #    When I enter a valid username and password combination
    #    Then I am presented with the apps section with the admin icon available
    When I access the homepage as adminOnly
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    Then the app list contains the following apps
    | app          |
    | Admin        |
    # clean up
    * I have not already authenticated

  Scenario Outline: 8. Hiding icons for user without Admin role
    #    Given I am on the sign in screen
    #    And I have a valid TMV role of <Role Type>
    #    When I enter a valid username and password combination
    #    Then I am presented with the apps section without the admin icon available
    #
    #    Examples:
    #      | Role Type |
    #      | Standard|
    #      | Restrictions |
    #      | Schedule Matching|
    When I access the homepage as <role>
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    Then the app list does not contain the following apps
      | app          |
      | Admin        |
    # clean up
    * I have not already authenticated

    Examples:
      | role             |
      | standard         |
      | restriction      |
      | schedulematching |

  Scenario: 9. Displaying map sections for user with Standard Role
    #    Given I am on the sign in screen
    #    And I have a valid TMV role of Standard
    #    When I enter a valid username and password combination
    #    Then I the following are displayed 'Find your map', 'Recent Map', 'All Maps'
    When I access the homepage as standard
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    * the map search box is displayed
    * the recent maps section is displayed
    * the all maps section is displayed
    # clean up
    * I have not already authenticated

  Scenario: 10. Displaying icons for user with Standard Role
    #    Given I am on the sign in screen
    #    And I have a valid TMV role of Standard
    #    When I enter a valid username and password combination
    #    Then I the following are  displayed Trains List, Enquiries, Replay, Log viewer
    When I access the homepage as standard
    Then I am authenticated and see the welcome message
    When I dismiss the welcome message
    Then the app list contains the following apps
      | app          |
      | Trains List  |
      | Enquiries    |
      | Replay       |
      | Logs         |
    # clean up
    * I have not already authenticated
