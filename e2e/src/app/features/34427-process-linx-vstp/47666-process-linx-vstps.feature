Feature: 34427 - TMV Process LINX VSTP (S002)
  As a TMV User
  I want the system process LINX VSTP messages
  So that I can view a train's VSTP timetable and respective on the day updates

  @tdd
  Scenario Outline: 34427-1 Old Schedules are not displayed
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has schedule identifier characteristics
      | trainUid |  stpIndicator  | dateRunsFrom        |
      | <trainUid> |  <stpIndicator> |  <dateRunsFrom>  |
    And the schedule has a Date Run to of '<dateRunsTo>'
    And the schedule is received from LINX
    When I search Timetable for '<trainUid>'
    Then no results are returned with that planning UID '<trainUid>'
      Examples:
        | trainDescription | trainUid | dateRunsFrom | dateRunsTo | stpIndicator | displayType |
        | 3F01             | A137657  | 2020-01-01   | yesterday  | NV            | VSTP       |

  @tdd
  Scenario Outline: 34427-2 Future Schedules are not displayed
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule is received from LINX
    When I search Timetable for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | stpIndicator | displayType |
      | 3F04             | A437657  | tomorrow     | NV           | VSTP        |

  @tdd
  Scenario Outline: 34427-3 Days run outside current time period are not displayed
    Given I am on the home page
    And there is a Schedule for '<trainDescription>'
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator   | dateRunsFrom   |
      | <trainUid> | <stpIndicator> | <dateRunsFrom> |
    And the schedule does not run on a day that is today
    And the schedule is received from LINX
    When I search Timetable for '<trainDescription>'
    Then no results are returned with that planning UID '<trainUid>'

    Examples:
      | trainDescription | trainUid | dateRunsFrom | dateRunsTo | stpIndicator | displayType |
      | 3F06             | A637657  | 2020-01-01   | 2050-12-01 | NV           | VSTP        |

  @tdd
  Scenario Outline: 34427-4 Base Schedule is displayed
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    When I search Timetable for '<trainUid>'
    Then results are returned with that planning UID '<trainUid>'

    Examples:
      | fileName                                           | trainUid | dateRunsFrom | dateRunsTo | daysToRun| stpIndicator | displayType|
      | access-plan/schedules_BS_type_NV.cif               | A32345   | 2020-01-01   | 2050-01-01 | 1111111  | NV           | VSTP CAN   |
      | access-plan/schedules_BS_type_P_NV.cif             | A42345   | 2020-01-01   | 2050-01-01 | 1111111  | P,NV         | VSTP CAN   |

  @tdd
  Scenario Outline: 34427-5 Schedule Cancellation is displayed
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    When I search Timetable for '<trainUid>'
    Then results are returned with that planning UID '<trainUid>'
    Examples:
      | fileName                                           | trainUid | dateRunsFrom | dateRunsTo | daysToRun| stpIndicator  | displayType |
      | access-plan/schedules_BS_type_CV.cif               | A32345   | 2020-01-01   | 2050-01-01 | 1111111  | C,V           | VSTP CAN    |
      | access-plan/schedules_BS_type_P_CV.cif             | A42345   | 2020-01-01   | 2050-01-01 | 1111111  | P,CV          | VSTP CAN    |
      | access-plan/schedules_BS_type_P_O_CV.cif           | A52345   | 2020-01-01   | 2050-01-01 | 1111111  | P,O,CV        | VSTP CAN    |
      | access-plan/schedules_BS_type_N_CV.cif             | A62345   | 2020-01-01   | 2050-01-01 | 1111111  | N,CV          | VSTP CAN    |
      | access-plan/schedules_BS_type_N_O_CV.cif           | A72345   | 2020-01-01   | 2050-01-01 | 1111111  | N,O,CV        | VSTP CAN    |

  @tdd
  Scenario Outline: 34427-6 Schedule Overlay is displayed
    Given I am on the home page
    And the access plan located in CIF file '<fileName>' is received from LINX
    When I search Timetable for '<trainUid>'
    Then results are returned with that planning UID '<trainUid>'
    Examples:
      | fileName                                           | trainUid | dateRunsFrom | dateRunsTo | daysToRun| stpIndicator | displayType |
      | access-plan/schedules_BS_type_OV.cif               | A82345   | 2020-01-01   | 2050-01-01 | 1111111  | O,V          | VSTP VAR    |
      | access-plan/schedules_BS_type_P_OV.cif             | A92345   | 2020-01-01   | 2050-01-01 | 1111111  | P,OV         | VSTP VAR    |
      | access-plan/schedules_BS_type_N_OV.cif             | A13345   | 2020-01-01   | 2050-01-01 | 1111111  | N,OV         | VSTP VAR    |
      | access-plan/schedules_BS_type_N_OV.cif             | A14345   | 2020-01-01   | 2050-01-01 | 1111111  | N,O,OV       | VSTP VAR    |
      | access-plan/schedules_BS_type_N_OV.cif             | A15345   | 2020-01-01   | 2050-01-01 | 1111111  | P,O,OV       | VSTP VAR    |
