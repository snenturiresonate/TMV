Feature: 40656 - Schedule Manipulation - Path To Line

  As a TMV user
  I want schedules which have been imported to be manipulated such that passing locations are inserted
  So, that the schedule has a full set of locations that the service will stop or pass

  @tdd
  Scenario: 40656-3 Schedule with propagated line code
    Given the access plan is received from LINX
      | path                                                                     |
      | access-plan/schedule-manipulation/schedule-with-propagated-line-code.cif |
    When I am on the timetable view for service '1F03'
    Then the locations line code matches the path code
      | location        | pathCode |
      | Oxford North Jn | PAT      |

  @tdd
  Scenario: 40656-4 Schedule with location with existing line code
    Given the access plan is received from LINX
      | path                                                                                 |
      | access-plan/schedule-manipulation/schedule-with-location-with-existing-line-code.cif |
    When I am on the timetable view for service '1F04'
    Then the locations line code matches the original line code
      | location        | lineCode |
      | Oxford North Jn | LIN      |

  @tdd
  Scenario: 40656-5 Schedule with location without matching path to line code rules
    Given the access plan is received from LINX
      | path                                                                                    |
      | access-plan/schedule-manipulation/schedule-not-path-to-line-line-code-not-populated.cif |
    When I am on the timetable view for service '1F05'
    Then no line code is displayed for location 'Oxford'
