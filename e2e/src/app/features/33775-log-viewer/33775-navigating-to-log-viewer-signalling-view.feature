@TMVPhase2 @P2.Closeout
Feature: 33775 - Navigating to Log Viewer Signalling view

  As a TMV User
  I want the ability to access the TMV log viewer
  So that I can interrogate the data stored for business purposes

#  Given that I have the log viewer screen open on a tab other than the Signalling view
#  When I select the Signalling option
#  Then the Signalling tab is highlighted
#  And the Signalling log view is displayed

  Scenario: 81042 - Navigating to Log Viewer Timetable view
    And I am on the log viewer page
    And I navigate to the Movement log tab
    And the Movement tab is highlighted
    And the Movement view is visible
    And I navigate to the Signalling log tab
    And the Signalling tab is highlighted
    And the Signalling view is visible
