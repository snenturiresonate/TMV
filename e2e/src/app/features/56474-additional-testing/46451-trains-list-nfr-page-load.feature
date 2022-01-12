Feature: 46451 - Trains List - NFR testing (Page load)
  As a TMV dev team member
  I want performance tests for trains list page load
  So that I can have early sight of any performance issues

  Background:
    * I am on the home page
    * The admin setting defaults are as originally shipped
    * I reset the stopwatch
    * I am on the trains list page 1
    * I restore to default train list config '1'
    * I refresh the browser
    * I save the trains list config

  Scenario: 33764-6. Access Trains List (Response time)
    #  33764-6 Access Trains List (Response time)
    #    Given the user is authenticated to use TMV
    #    And the user is viewing the home page
    #    And the user has not opened the trains list before
    #    When the user selects the trains list
    #    Then the trains list opened in a new browser tab within 1 second
    Given I start the stopwatch
    And I am on the trains list page 1
    And The trains list table is visible
    When I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '1000' milliseconds

  Scenario: 33764-7. Refresh Trains List (Response time)
    #  33764 - 7 Refresh Trains List (Response time)
    #    Given the user is authenticated to use TMV
    #    And has opened the trains list
    #    When the user refreshes the trains list
    #    Then the trains list information is displayed within 1 second
    Given I am on the trains list page 1
    And The trains list table is visible
    When I start the stopwatch
    And I refresh the browser
    And The trains list table is visible
    And I stop the stopwatch
    Then the stopwatch reads less than '1000' milliseconds, within a tolerance of '1000' milliseconds
