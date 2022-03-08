@TMVPhase2 @P2.Closeout
Feature: 33775 - TMV Log Viewer - Signalling Log View - Date Picker

  As a TMV User
  I want the ability to access the TMV log viewer
  So that I can interrogate the data stored for business purposes

#  Given that I have the log viewer screen open on a Signalling log View tab
#  When I select the date entry
#  Then the date selector is displayed
#  And defaulted to today's date
#  And restricted to 90 days in the past and today's date
#  And the results reflects the date

#  Comments
#  Default to today's date
#  Can select a date 90 days in the past

  Background:
    Given I have not already authenticated
    And I am on the home page

  Scenario: 81043 - 1 Signalling Log View - Date Picker - defaults

# Default to today's date

    When I am on the log viewer page
    And  I navigate to the Signalling log tab
    Then the date field for Signalling is displayed
    And the value of the date field for Signalling is today
    When I open the date picker for Signalling logs
    Then the date picker for Signalling is displayed
    And the value of the date picker for Signalling is today


  Scenario Outline: 81043 - 2 Signalling Log View - Date Picker - validation through keyboard entry

# restricted to 90 days in the past and today's date
# Can select a date 90 days in the past

    When I am on the log viewer page
    And I navigate to the Signalling log tab
    Then it <isPossible> possible to set the Signalling date field to <date> with the keyboard

    Examples:
      | isPossible | date       |
      | is         | today - 90 |
      | isn't      | today - 91 |
      | isn't      | today + 1  |

  Scenario Outline: 81043 - 3 Signalling Log View - Date Picker - validation through date picker

# restricted to 90 days in the past and today's date
# Can select a date 90 days in the past

    When I am on the log viewer page
    And I navigate to the Signalling log tab
    Then it <isPossible> possible to set the Signalling date field to <date> with the picker

    Examples:
      | isPossible | date       |
      | is         | today - 90 |
      | isn't      | today - 91 |
      | isn't      | today + 1  |

  Scenario: 81043 - 4 Signalling Log View - Date Picker - results only show signalling running on date chosen

#  And the results reflects the date

    Given I clear the logged-signal-states Elastic Search index
    Given I clear the logged-latch-states Elastic Search index
    Given I clear the logged-s-class Elastic Search index
    Given the following signalling update message is sent from LINX
      | trainDescriber | address | data | timestamp |
      | D1             | 31      | 00   | 17:45:00  |
      | D1             | 31      | FF   | 17:46:00  |
      | D3             | 50      | 04   | 17:47:00  |
      | D3             | 50      | 00   | 17:48:00  |
    And I give the messages 2 seconds to get into elastic search
    And I refresh the Elastic Search indices
    When I am on the log viewer page
    And I navigate to the Signalling log tab
    And I search for Signalling logs for date 'today'
    Then there are 14 rows returned in the log results
    And I search for Signalling logs for date 'yesterday'
    Then there are 0 rows returned in the log results
