@bug @60608
Feature: 51586 - TMV - Extrapolate path with predicted path information

  As a TMV user
  I want predicted timings and punctuality to be calculated
  So that I can see how the train is expected to progress compared to its timetable

  Scenario Outline: 51586 -1 No prediction prior to activation
    # Given a valid schedule exists
    # And no train activation has been received for that schedule
    # And no TRI or berth stepping has been received for that schedule
    # When the user views the timetable
    # Then there are no predicted times or punctuality displayed for the locations in the schedule
    Given I am on the trains list page
    And the following basic schedule is received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | O            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> |        |           |             |         |
    And the access plan located in CIF file '<cif>' is received from LINX
    And Train description '<trainDescription>' is visible on the trains list
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Arrival time for location "<location>" instance 1 is empty
    Examples:
      | cif                                     | trainUid | trainDescription | location      |
      #stopping #STAFFRD
      | access-plan/55226-schedules/55226-1.cif | C55226   | 1U32             | Stafford      |

  Scenario Outline: 51586 -2 Start predicting following activation
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed for all locations in the schedule
    Given I am on the trains list page
    And the following basic schedule is received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | O            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> |        |           |             |         |
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber         | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid>| <trainDescription>  | 10:15                  | 99999               | Stafford                 |
    And Train description '<trainDescription>' is visible on the trains list
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location>" instance 2 is correctly calculated based on "<timestamp2>"
    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | timestamp2 |
      #stopping #STAFFRD
      | access-plan/55226-schedules/55226-2.cif | C55227   | 1U32             | Stafford      | 13:33:00  | 13:56:00    |

  Scenario Outline: 51586 -3 Start predicting following TRI
    # Given a valid schedule exists
    # And train has not been activated
    # And a Train running information message has been received for the origin for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed for all locations in the schedule after the TRI location
    Given I am on the trains list page
    And the following basic schedule is received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | O            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> |        |           |             |         |
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train running information message are sent from LINX
      | trainUID     | trainNumber          | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType            |
      | <trainUid>   | <trainDescription>   | today              | 99999               | CREWE                  | Departure from Origin  |
    And Train description '<trainDescription>' is visible on the trains list
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location>" instance 2 is correctly calculated based on "<timestamp2>"
    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | timestamp2 |
      #stopping #STAFFRD
      | access-plan/55226-schedules/55226-3.cif | C55228   | 1U32             | Stafford      | 13:33:00  | 13:56:00   |

  Scenario Outline: 51586 -4 Start predicting following TD update
    # Given a valid schedule exists
    # And train has not been activated
    # And a TD update has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed for all locations in the schedule
    Given I am on the trains list page
    And the following basic schedule is received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | O            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> |        |           |             |         |
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber   | trainDescription    |
      | 240     | D3               | <trainDescription>  |
    And Train description '<trainDescription>' is visible on the trains list
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location>" instance 2 is correctly calculated based on "<timestamp2>"
    Examples:
      | cif                                     | trainUid | trainDescription | location      | timestamp | timestamp2 |
      #stopping #STAFFRD
      | access-plan/55226-schedules/55226-4.cif | C55229   | 1U32             | Stafford      | 13:33:00  | 13:56:00   |
