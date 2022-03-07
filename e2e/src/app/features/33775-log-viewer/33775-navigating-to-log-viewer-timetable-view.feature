@TMVPhase2 @P2.Closeout
Feature: 33775 - Navigating to Log Viewer Timetable view

  As a TMV User
  I want the ability to access the TMV log viewer
  So that I can interrogate the data stored for business purposes

#  Given that I have the log viewer screen open on a tab other than the Timetable view
#  When I select the Timetable option
#  Then the Timetable tab is highlighted
#  And the timetable log view is displayed

  Scenario: 81034 - Navigating to Log Viewer Timetable view
    And I am on the log viewer page
    And I navigate to the Signalling log tab
    And the Signalling tab is highlighted
    And the Signalling view is visible
    And I navigate to the Timetable log tab
    And the Timetable tab is highlighted
    And the Timetable view is visible
