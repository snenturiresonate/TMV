Feature: 51586 - Path Extrapolation - Current Punctuality

  As a TMV user
  I want predicted timings and punctuality to be calculated
  So that I can see how the train is expected to progress compared to its timetable

  Background:
    Given I reset redis

  @flaky @manual
  Scenario Outline: 51586 - 26 Actual path and line code displayed
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    When I am on the timetable view for service '<trainUid>'
    And the Inserted toggle is 'on'
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                 | now                    | 99999               | PADTON                 | today         |
    And the following live berth step message is sent from LINX (to move train)
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    Then the actual/predicted path code is correct
      | location   | instance | pathCode   |
      | <location> | 1        | <pathCode> |
    And the actual/predicted line code is correct
      | location   | instance | lineCode   |
      | <location> | 1        | <lineCode> |

    Examples:
      | trainDescription | trainUid | fromBerth | toBerth | trainDescriber | location           | pathCode | lineCode |
      | 1A26             | A51586   | R007      | 0037    | D3             | Royal Oak Junction | 1        | 1        |
      | 1B26             | B51586   | 0173      | 0179    | D3             | [Acton Main Line]  | ML       | ML       |

  @bug @bug:65574
  Scenario Outline: 51586 - 27 Actual platform code displayed
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>    | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                 | now                    | 99999               | PADTON                 | today         |
    And the following live berth step message is sent from LINX (to move train)
      | fromBerth   | toBerth      | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth>    | <trainDescriber> | <trainDescription> |
      | <toBerth>   | <thirdBerth> | <trainDescriber> | <trainDescription> |
    And I give the System 5 seconds to load
    When I am on the timetable view for service '<trainUid>'
    And the Inserted toggle is 'on'
    Then the actual/predicted platform is correct
      | location   | instance | platform   |
      | <location> | 1        | <platform> |

    Examples:
      | cif                                              | trainDescription | trainUid | fromBerth | toBerth | thirdBerth | trainDescriber | location | platform |
      | access-plan/1D46_PADTON_OXFD.cif                 | 1A27             | C51586   | 1685      | 1686    | 1733       | D1             | Reading  | 9        |
      | access-plan/1D46_PADTON_OXFD.cif                 | 1B27             | D51586   | 1685      | 1684    | 1733       | D1             | Reading  | 8        |
      | access-plan/1D46_PADTON_OXFD-RDNGSTN_PASSING.cif | 1C27             | E51586   | 1685      | 1686    | 1733       | D1             | Reading  | 9        |
      | access-plan/1D46_PADTON_OXFD-RDNGSTN_PASSING.cif | 1D27             | F51586   | 1685      | 1684    | 1733       | D1             | Reading  | 8        |

  @flaky @manual
  Scenario Outline: 51586 - 28 Predicted path and line code displayed
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    When I am on the timetable view for service '<trainUid>'
    And the Inserted toggle is 'on'
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                 | now                    | 99999               | PADTON                 | today         |
    Then the actual/predicted path code is correct
      | location   | instance | pathCode   |
      | <location> | 1        | <pathCode> |
    And the actual/predicted line code is correct
      | location   | instance | lineCode   |
      | <location> | 1        | <lineCode> |

    Examples:
      | trainDescription | trainUid | location           | pathCode | lineCode |
      | 1A28             | G51586   | Royal Oak Junction | 1        | 1        |
      | 1B28             | H51586   | [Acton Main Line]  | ML       | ML       |

  @flaky @manual
  Scenario Outline: 51586 - 29 Predicted platform code displayed
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>    | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    When I am on the timetable view for service '<trainUid>'
    And the Inserted toggle is 'on'
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | actualDepartureHour | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                 | now                    | 99999               | PADTON                 | today         |
    Then the actual/predicted platform is correct
      | location   | instance | platform   |
      | <location> | 1        | <platform> |

    Examples:
      | cif                                              | trainDescription | trainUid | location | platform |
      | access-plan/1D46_PADTON_OXFD.cif                 | 1A29             | I51586   | Reading  | 9        |
      | access-plan/1D46_PADTON_OXFD-RDNGSTN_PASSING.cif | 1B29             | J51586   | Reading  | 9        |

