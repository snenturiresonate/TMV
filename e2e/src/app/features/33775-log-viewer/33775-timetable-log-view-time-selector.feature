@TMVPhase2 @P2.Closeout
Feature: 33775 - TMV Log Viewer - Timetable Log View - Time Selector

  As a TMV User
  I want the ability to access the TMV log viewer
  So that I can interrogate the data stored for business purposes

#  Given that I have the log viewer screen open on a Timetable tab
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

  @bug @bug:92441
  Scenario: 81035 - 1 Timetable Log View - Time Selector - defaults

#  Then the start and end time are displayed
#  And are defaulted to an hour in the past with a duration of an hour

    When I am on the log viewer page
    And I navigate to the Timetable log tab
    And I set the Timeframe checkbox for Timetable as checked
    Then the startTime field for Timetable is displayed
    And the endTime field for Timetable is displayed
    And the value of the startTime field for Timetable is now - 60
    And the value of the endTime field for Timetable is now


  Scenario Outline: 81035 - 2 Timetable Log View - Time Selector - validation through keyboard entry - <startTime> - <endTime>

#  And the start time must be before the end time

    When I am on the log viewer page
    And I navigate to the Timetable log tab
    And I set the Timeframe checkbox for Timetable as checked
    Then it <isPossible> possible to set the Timetable startTime to <startTime> and endTime to <endTime> with the keyboard

    Examples:
      | isPossible | startTime | endTime  |
      | is         | now       | now + 1  |
      | isn't      | now       | now      |
      | is         | 01:00:00  | 23:00:00 |
      | isn't      | 23:00:00  | 01:00:00 |


  Scenario Outline: 81035 - 3 Timetable Log View - Time Selector - validation through time spinners - <startTime> - <endTime>

#  And the start time must be before the end time

    When I am on the log viewer page
    And I navigate to the Timetable log tab
    And I set the Timeframe checkbox for Timetable as checked
    Then it <isPossible> possible to set the Timetable startTime to <startTime> and endTime to <endTime> with the spinners

    Examples:
      | isPossible | startTime | endTime  |
      | is         | now       | now + 1  |
      | isn't      | now       | now      |
      | is         | 01:00:00  | 23:00:00 |
      | isn't      | 23:00:00  | 01:00:00 |

  Scenario Outline: 81035 - 4 Timetable Log View - Time Selector - results only show timetables running during the time range chosen - <startTime> - <endTime>

    #  And the results reflects the time range

    Given I clear the logged-agreed-schedules Elastic Search index
    And I load a CIF file leaving RDNGSTN now using access-plan/2P77_RDNGSTN_PADTON.cif which is running today
    And I load a CIF file leaving PADTON now using access-plan/1B69_PADTON_SWANSEA.cif which is running today
    And I give the trains 3 seconds to load and get into elastic search
    When I am on the log viewer page
    And I navigate to the Timetable log tab
    And I search for Timetable logs with
      | startTime   | endTime   |
      | <startTime> | <endTime> |
    Then there are <resultsReturned> rows returned in the log results

    Examples:
      | startTime | endTime   | resultsReturned |
      | now - 5   | now + 5   | 2               |
      | now - 60  | now - 1   | 0               |
      | now + 55  | now + 180 | 1               |
