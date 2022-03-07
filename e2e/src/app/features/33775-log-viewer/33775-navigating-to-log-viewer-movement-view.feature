@TMVPhase2 @P2.Closeout
Feature: 33775 - Navigating to Log Viewer Movement view

  As a TMV User
  I want the ability to access the TMV log viewer
  So that I can interrogate the data stored for business purposes

#  Given that I have the log viewer screen open on a tab other than the Movement view
#  When I select the Movement option
#  Then the Movement tab is highlighted
#  And the Movement log view is displayed

  Scenario: 81039- Navigating to Log Viewer Movement view
    And I am on the log viewer page
    And I navigate to the Timetable log tab
    And the Timetable tab is highlighted
    And the Timetable view is visible
    And I navigate to the Movement log tab
    And the Movement tab is highlighted
    And the Movement view is visible
