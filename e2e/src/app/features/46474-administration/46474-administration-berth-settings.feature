Feature: 46474 - Administration Display Settings - full end to end testing - berth settings

  As a tester
  I want to verify the administration page - Display Settings
  So, that I can identify if the build meet the end to end requirements

  Background:
    Given I have not already authenticated
    And I am on the admin page
    And The admin setting defaults are as originally shipped

  Scenario: Berth settings header
    Then the berth settings header is displayed as 'Berth Colours'

  Scenario: Berth colour settings default color and entries
    Then the following can be seen on the berth color settings table
      | name           | colour  |
      | Attention      | #0000ff |
      | Left Behind    | #969696 |
      | No Timetable   | #e1e1e1 |
      | Last Berth     | #ffffff |
      | Unknown Delay  | #ffffff |

  Scenario: Berth colour settings - Update and Save
    When I update the Berth settings table as
      | name           | colour  |
      | Attention      | #bb1    |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the berth color settings table
      | name           | colour  |
      | Attention      | #bbbb11 |
      | Left Behind    | #969696 |
      | No Timetable   | #e1e1e1 |
      | Last Berth     | #ffffff |
      | Unknown Delay  | #ffffff |
    And The admin setting defaults are as originally shipped
