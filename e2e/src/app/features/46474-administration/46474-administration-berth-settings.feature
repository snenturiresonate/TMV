Feature: 46474 - Administration Display Settings - full end to end testing - berth settings

  As a tester
  I want to verify the administration page - Display Settings
  So, that I can identify if the build meet the end to end requirements

  Background:
    Given I am on the admin page

  Scenario: Berth settings header
    Then the berth settings header is displayed as 'Berth Colours'

  @bug @bug_54385
  Scenario: Berth colour settings default color and entries
    Then the following can be seen on the berth color settings table
      | name           | colour  | toggleState |
      | Attention      | #0000ff | Off         |
      | Left Behind    | #969696 | On          |
      | No Timetable   | #e1e1e1 | On          |
      | Last Berth     | #ffffff | On          |
      | Unknown Delay  | #ffffff | On          |

  @bug @bug_54385
  Scenario: Berth colour settings - Update and Save
    When I update the Berth settings table as
      | name           | colour  | toggleState |
      | Attention      | #969696 | Off         |
      | Left Behind    | #e1e1e1 | On          |
      | No Timetable   | #ffffff | On          |
      | Last Berth     | #ffffff | On          |
      | Unknown Delay  | #e1e1e1 | On          |
    And I save the punctuality settings
    And I navigate to the 'Login Message' admin tab
    And I navigate to the 'Display Settings' admin tab
    Then the following can be seen on the berth color settings table
      | name           | colour  | toggleState |
      | Attention      | #969696 | On          |
      | Left Behind    | #e1e1e1 | Off         |
      | No Timetable   | #ffffff | On          |
      | Last Berth     | #ffffff | On          |
      | Unknown Delay  | #e1e1e1 | On          |
