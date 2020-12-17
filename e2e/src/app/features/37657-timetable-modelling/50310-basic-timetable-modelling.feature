Feature: 37657 - Basic Timetable Modelling

  As a TMV user
  I want the schedules received in a CIF format to be transformed and loaded into TMV as agreed and current timetables
  So that the data is available for the system to use schedule match and display purposes

  @tdd
  Scenario Outline: 37657-1 Old Schedules are not displayed
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule has a Date Run to of '<dateRunsTo>'
    And the schedule is received from LINX
    When I search Train for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | dateRunsTo | stpIndicator | displayType |
      | 4F01             | A137657  | 2020-01-01   | yesterday  | P            | LTP         |
      | 4F02             | A237657  | 2020-01-01   | yesterday  | N            | STP         |

  @tdd
  Scenario Outline: 37657-2 Future Schedules are not displayed
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule is received from LINX
    When I search Train for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | stpIndicator | displayType |
      | 4F03             | A337657  | tomorrow     | P            | LTP         |
      | 4F04             | A437657  | tomorrow     | N            | STP         |

  @tdd
  Scenario Outline: 37657-3 Days run outside current time period are not displayed
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has a basic timetable
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule does not run on a day that is today
    And the schedule is received from LINX
    When I search Train for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | dateRunsTo | stpIndicator | displayType |
      | 4F05             | A537657  | 2020-01-01   | 2050-12-01 | P            | LTP         |
      | 4F06             | A637657  | 2020-01-01   | 2050-12-01 | N            | STP         |
