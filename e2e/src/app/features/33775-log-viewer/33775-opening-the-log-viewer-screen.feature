@TMVPhase2 @P2.Closeout
Feature: 33775 - Opening the log viewer screen

  As a TMV User
  I want the ability to access the TMV log viewer
  So that I can interrogate the data stored for business purposes

#  Given that I am on the home page
#  When I select the log viewer option
#  Then the log viewer opened in a new tab with the Timetable view displayed as default

  Scenario: 81033 - Opening the log viewer screen
    Given I am on the home page
    When I click the app 'logs'
    And I switch to the new tab
    Then the Timetable view is visible



