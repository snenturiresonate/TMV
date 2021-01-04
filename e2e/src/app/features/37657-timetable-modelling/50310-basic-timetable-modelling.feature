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

  @tdd
  Scenario Outline: 37657-4 Base Schedule is displayed
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule has a Date Run to of '<dateRunsTo>'
    And the schedule has a Days Run of all Days
    And the schedule is received from LINX
    When I search Timetable for '<trainUid>'
    Then results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | dateRunsTo | stpIndicator | displayType |DaytoRun|
      | 4F07             | A12345   | 2020-01-01   | 2050-01-01 | P            | LTP         |1111111|
      | 4F08             | A22345   | 2020-01-01   | 2050-01-01 | N            | STP         |1111111|

  @tdd
  Scenario Outline: 37657-5 Schedule Cancellation is displayed
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    When I search Timetable for '<trainUid>'
    Then results are returned with that planning UID '<trainUid>'
    Examples:
      | fileName                                          | trainUid | dateRunsFrom | dateRunsTo | daysToRun| stpIndicator | displayType |
      | access-plan/schedules_BS_type_C.cif               | A32345   | 2020-01-01   | 2050-01-01 | 1111111  | C            | LTP         |
      | access-plan/schedules_BS_type_P_C.cif             | A42345   | 2020-01-01   | 2050-01-01 | 1111111  | P,C          | LTP         |
      | access-plan/schedules_BS_type_P_O_C.cif           | A52345   | 2020-01-01   | 2050-01-01 | 1111111  | P,O,C        | LTP         |
      | access-plan/schedules_BS_type_N_C.cif             | A62345   | 2020-01-01   | 2050-01-01 | 1111111  | N,C          | LTP         |
      | access-plan/schedules_BS_type_N_O_C.cif           | A72345   | 2020-01-01   | 2050-01-01 | 1111111  | N,O,C        | LTP         |

  @tdd
  Scenario Outline: 37657-6 Schedule Overlay is displayed
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    When I search Timetable for '<trainUid>'
    Then results are returned with that planning UID '<trainUid>'
    Examples:
      | fileName                                          | trainUid | dateRunsFrom | dateRunsTo | daysToRun| stpIndicator | displayType |
      | access-plan/schedules_BS_type_O.cif               | A82345   | 2020-01-01   | 2050-01-01 | 1111111  | O            | LTP         |
      | access-plan/schedules_BS_type_P_O.cif             | A92345   | 2020-01-01   | 2050-01-01 | 1111111  | P,O          | LTP         |
      | access-plan/schedules_BS_type_N_O.cif             | A13345   | 2020-01-01   | 2050-01-01 | 1111111  | N,O          | LTP         |
