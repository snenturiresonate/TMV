@TMVPhase2 @P2.Closeout
Feature: 33775 - TMV Log Viewer - Signalling Log View - Time Selector

  As a TMV User
  I want the ability to access the TMV log viewer
  So that I can interrogate the data stored for business purposes

#  Given that I have the log viewer screen open on a Signalling log View tab
#  When I select the set timeframe option
#  Then the start and end time are displayed
#  And are defaulted to an hour in the past with a duration of an hour
#  And the start time must be before the end time
#  And the results reflects the time range

#  Comments
#  Timeframe is optional
#  Timeframe bounded by the date i.e. not crossing midnight boundary

  Background:
    Given I have not already authenticated
    And I am on the home page

  Scenario: 81044 - 1 Signalling Log View - Time Selector - defaults

#  Then the start and end time are displayed
#  And are defaulted to an hour in the past with a duration of an hour

    When I am on the log viewer page
    And I navigate to the Signalling log tab
    And I set the Timeframe checkbox for Signalling as checked
    Then the startTime field for Signalling is displayed
    And the endTime field for Signalling is displayed
    And the value of the startTime field for Signalling is now - 60
    And the value of the endTime field for Signalling is now


  Scenario Outline: 81044 - 2 Signalling Log View - Time Selector - validation through keyboard entry

#  And the start time must be before the end time

    When I am on the log viewer page
    And I navigate to the Signalling log tab
    And I set the Timeframe checkbox for Signalling as checked
    Then it <isPossible> possible to set the Signalling startTime to <startTime> and endTime to <endTime> with the keyboard

    Examples:
      | isPossible | startTime | endTime  |
      | is         | now       | now + 1  |
      | isn't      | now       | now      |
      | is         | 01:00:00  | 23:00:00 |
      | isn't      | 23:00:00  | 01:00:00 |


  Scenario Outline: 81044 - 3 Signalling Log View - Time Selector - validation through time spinners

#  And the start time must be before the end time

    When I am on the log viewer page
    And I navigate to the Signalling log tab
    And I set the Timeframe checkbox for Signalling as checked
    Then it <isPossible> possible to set the Signalling startTime to <startTime> and endTime to <endTime> with the spinners

    Examples:
      | isPossible | startTime | endTime  |
      | is         | now       | now + 1  |
      | isn't      | now       | now      |
      | is         | 01:00:00  | 23:00:00 |
      | isn't      | 23:00:00  | 01:00:00 |


  Scenario Outline: 81044 - 4 Signalling Log View - Time Selector - results only show signalling messages for the time range chosen

#  And the results reflects the time range

    Given I clear the logged-signal-states Elastic Search index
    Given I clear the logged-latch-states Elastic Search index
    Given I clear the logged-s-class Elastic Search index
    Given the following live signalling update messages are sent from LINX
      | trainDescriber | address | data |
      | D1             | 31      | 00   |
      | D1             | 31      | FF   |
      | D3             | 50      | 04   |
      | D3             | 50      | 00   |
    And I give the messages 2 seconds to get into elastic search
    And I refresh the Elastic Search indices
    When I am on the log viewer page
    And I navigate to the Signalling log tab
    And I search for Signalling logs with
      | startTime   | endTime   |
      | <startTime> | <endTime> |
    Then there are <resultsReturned> rows returned in the log results

    Examples:
      | startTime | endTime   | resultsReturned |
      | now - 5   | now + 5   | 14              |
      | now - 60  | now - 1   | 0               |
      | now + 5   | now + 180 | 0               |
