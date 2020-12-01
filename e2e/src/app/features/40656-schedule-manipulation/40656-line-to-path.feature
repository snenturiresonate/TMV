Feature: 40656 - Schedule Manipulation - Line To Path

  As a TMV user
  I want schedules which have been imported to be manipulated such that passing locations are inserted
  So, that the schedule has a full set of locations that the service will stop or pass

  @tdd
  Scenario: 40656-6 Schedule with locations matching line code to path code rules
    Given the access plan is received from LINX
      | path                                                        |
      | access-plan/schedule-manipulation/matching-line-to-path.cif |
    When I am on the timetable view for service '1F06'
    Then the path code for the To Location matches the line code for the From Location
      | index | fromLocation | lineCode | toLocation      |
      | K0056 | Oxford       | LIN      | Oxford North Jn |

  @tdd
  Scenario: 40656-7 Schedule with locations with existing path code
    Given the access plan is received from LINX
      | path                                                                                   |
      | access-plan/schedule-manipulation/matching-line-to-path-to-location-path-populated.cif |
    When I am on the timetable view for service '1F07'
    Then the locations path code matches the original path code
      | index | location        | pathCode |
      | K0056 | Oxford North Jn | PAT      |

  @tdd
  Scenario: 40656-7b From Locations line is not back filled from To Locations Path with matching rule
    Given the access plan is received from LINX
      | path                                                                                   |
      | access-plan/schedule-manipulation/matching-line-to-path-to-location-path-populated.cif |
    When I am on the timetable view for service '1F07'
    Then the locations line code matches the original line code
      | index | location | lineCode |
      | K0056 | Oxford   | LIN      |

  @tdd
  Scenario: 40656-8 Schedule with locations without matching line code to path code rules
    Given the access plan is received from LINX
      | path                                                           |
      | access-plan/schedule-manipulation/no-matching-line-to-path.cif |
    When I am on the timetable view for service '1F08'
    Then no path code is displayed for location 'Oxford North Jn'


