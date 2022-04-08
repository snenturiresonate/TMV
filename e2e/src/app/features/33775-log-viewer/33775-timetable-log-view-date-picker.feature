@TMVPhase2 @P2.Closeout
Feature: 33775 - TMV Log Viewer - Timetable Log View - Date Picker

  As a TMV User
  I want the ability to access the TMV log viewer
  So that I can interrogate the data stored for business purposes

#  Given that I have the log viewer screen open on a Timetable tab
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

  Scenario: 81035 - 1 Timetable Log View - Date Picker - defaults

    # Default to today's date

    When I am on the log viewer page
    And  I navigate to the Timetable log tab
    Then the date field for Timetable is displayed
    And the value of the date field for Timetable is today
    When I open the date picker for Timetable logs
    Then the date picker for Timetable is displayed
    And the value of the date picker for Timetable is today


  Scenario Outline: 81035 - 2 Timetable Log View - Date Picker - validation through keyboard entry

# restricted to 90 days in the past and today's date
# Can select a date 90 days in the past

    When I am on the log viewer page
    And I navigate to the Timetable log tab
    Then it <isPossible> possible to set the Timetable date field to <date> with the keyboard

    Examples:
      | isPossible | date       |
      | is         | today - 90 |
      | isn't      | today - 91 |
      | isn't      | today + 1  |

  Scenario Outline: 81035 - 3 Timetable Log View - Date Picker - validation through date picker

# restricted to 90 days in the past and today's date
# Can select a date 90 days in the past

    When I am on the log viewer page
    And I navigate to the Timetable log tab
    Then it <isPossible> possible to set the Timetable date field to <date> with the picker

    Examples:
      | isPossible | date       |
      | is         | today - 90 |
      | isn't      | today - 91 |
      | isn't      | today + 1  |

  @bug @bug:92801
  Scenario Outline: 81035 - 4 Timetable Log View - Date Picker - results only show timetables running on date chosen - train <isRunning> running

#  And the results reflects the date

    Given I clear the logged-agreed-schedules Elastic Search index
    And I load a CIF file leaving RDNGSTN now using access-plan/2P77_RDNGSTN_PADTON.cif which <isRunning> running today
    And I wait until today's train 'generated' has loaded
    And I load a CIF file leaving PADTON now using access-plan/1B69_PADTON_SWANSEA.cif which <isRunning> running today
    And I wait until today's train 'generated' has loaded
    And I give the timetables 2 seconds to load and get into elastic search
    And I refresh the Elastic Search indices
    When I am on the log viewer page
    And I navigate to the Timetable log tab
    And I search for Timetable logs for date 'today'
    Then there are <resultsReturned> rows returned in the log results

    Examples:
      | isRunning | resultsReturned |
      | is        | 2               |
      | isn't     | 0               |

