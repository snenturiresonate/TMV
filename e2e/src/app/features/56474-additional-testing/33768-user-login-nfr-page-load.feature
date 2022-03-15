@TMVPhase3 @P3.S4
Feature: 33768 - TMV User Management - User Login NFR Testing (Page Load)

  As a TMV dev team member
  I want to have automated test to monitor the performance of user login
  So that I can have early sight of any performance issues

# Given I am on the sign in screen
# And I have a valid TMV role
# When I enter a valid username and password combination
# Then I am presented with the welcome message within 1 second

  Background:
    * I reset the stopwatch

  @nn
  Scenario Outline: 33768 - 23 - Authenticated user accesses TMV Homepage (Response Time)
    Given I have not already authenticated
    And I access the home page without being signed in
    And I am presented with the sign in screen
    And I start the stopwatch
    And I access the homepage as <roleType> user
    When I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '100' milliseconds

    Examples:
      | roleType         |
      | standard         |
      | adminOnly        |
      | admin            |
      | restriction      |
      | standardonly     |
      | schedulematching |

