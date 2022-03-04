@TMVPhase2 @P2.S2
Feature: 79593 - TMV Timetable Log Viewer - Partial Search

  As a TMV User
  I want to search & view timetables in user-readable format from the timetable log viewer
  So that I have familiar representation of the timetable that makes it easier for me to understand and search for

  Background:
    Given I clear the logged-berth-states Elastic Search index
    And I clear the logged-signal-states Elastic Search index
    And I clear the logged-latch-states Elastic Search index
    And I clear the logged-s-class Elastic Search index
    And I clear the logged-agreed-schedules Elastic Search index

  #  TMV User shall be able to filter a timetable log search by using a data string including partial searches entered by the user.
  #  Partial text search used in the text fields presented for the logs:
  #     Train ID (any 2 consecutive characters, min of 2 characters)
  #     Planning UID (min 5 characters, if provided)
  #  If both fields have values then the query performs an AND search
  #  A validation error to be displayed if the minimum characters are not met.

  Scenario Outline: 80300 - Timetable Log - Partial Search - valid train ID and planningUid searches
    Given I generate a new trainUID
    And I remove all trains from the trains list
    And I remove today's train '<planningUid>' from the trainlist
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription1> | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And I give the train 2 seconds to get into elastic search
    And I refresh the Elastic Search indices
    When I am on the log viewer page
    * I navigate to the Timetable log tab
    * I search for Timetable logs with
      | trainDescription | planningUid |
      | 2d               | b1234       |
    Then the first timetable log results are
      | trainId             | scheduleType | planningUid   |
      | <trainDescription1> | LTP          | <planningUid> |
    When I am on the log viewer page
    * I navigate to the Timetable log tab
    * I search for Timetable logs with
      | trainDescription | planningUid |
      | 2f               | b1234       |
    Then there are 0 rows returned in the log results
    When I am on the log viewer page
    * I navigate to the Timetable log tab
    * I search for Timetable logs with
      | trainDescription | planningUid |
      |                  | 12345       |
    Then the first timetable log results are
      | trainId             | scheduleType | planningUid   |
      | <trainDescription1> | LTP          | <planningUid> |
    When I am on the log viewer page
    * I navigate to the Timetable log tab
    * I search for Timetable logs with
      | trainDescription | planningUid |
      | 20               | Z1234       |
    Then there are 0 rows returned in the log results
    When I am on the log viewer page
    * I navigate to the Timetable log tab
    * I search for Timetable logs with
      | trainDescription | planningUid |
      | D20               |             |
    Then the first timetable log results are
      | trainId             | scheduleType | planningUid   |
      | <trainDescription1> | LTP          | <planningUid> |

    Examples:
      | trainDescription1 | planningUid |
      | 2D20              | B12345      |

  #  TMV User shall be able to filter a movement log search by using a data string including partial searches entered by the user.
  #  A validation error to be displayed if the minimum characters are not met.

  Scenario: 80299 - Timetable Log - Partial Search - invalid searches
    Given I am on the log viewer page
    And I navigate to the Timetable log tab
    When I am on the log viewer page
    * I navigate to the Timetable log tab
    * I search for Timetable logs with
      | trainDescription | planningUid |
      | 1                |             |
    Then the movement logs timetable tab search error message is shown * The Train ID must contain at least 2 characters
    When I am on the log viewer page
    * I navigate to the Timetable log tab
    * I search for Timetable logs with
      | trainDescription | planningUid |
      |                  | 1234        |
    Then the movement logs timetable tab search error message is shown * The Planning UID must contain at least 5 characters
