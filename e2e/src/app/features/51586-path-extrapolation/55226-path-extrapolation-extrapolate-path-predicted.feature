@bug @60608
Feature: 51586 - TMV - Extrapolate path with predicted path information

  As a TMV user
  I want predicted timings and punctuality to be calculated
  So that I can see how the train is expected to progress compared to its timetable

  Background:
    Given I remove all trains from the trains list

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
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Arrival time for location "<location>" instance 1 is empty
    Examples:
      | cif                                     | trainUid | trainDescription | location |
      | access-plan/55226-schedules/55226-1.cif | C55226   | 1U31             | CREWE    |

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
      | <trainUid>| <trainDescription>  | 13:00                  | 99999               | CREWE                  |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | <trainUid>    | rgba(255, 181, 120, 1) |
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location2>" instance 2 is correctly calculated based on "<timestamp2>"
    Examples:
      | cif                                     | trainUid | trainDescription | location | location2 |timestamp | timestamp2 |
      | access-plan/55226-schedules/55226-2.cif | C55227   | 1U32             | CREWE    | CREWBHJ   | 13:33:00 | 13:36:00   |

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
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location2>" instance 2 is correctly calculated based on "<timestamp2>"
    Examples:
      | cif                                     | trainUid | trainDescription | location | location2 | timestamp | timestamp2 |
      | access-plan/55226-schedules/55226-3.cif | C55228   | 1U33             | CREWBHJ  | MADELEY   | 13:33:00  | 13:36:00   |

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
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location2>" instance 2 is correctly calculated based on "<timestamp2>"
    Examples:
      | cif                                     | trainUid | trainDescription |location | location2 | timestamp | timestamp2 |
      | access-plan/55226-schedules/55226-4.cif | C55229   | 1U34             | CREWE   | CREWBHJ   | 13:33:00  | 13:36:00   |

  Scenario Outline: 51586 -5  Start predicting from new origin
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the type 94 has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed from the new origin
    # And there are no predicted times for the locations prior to the new origin
    Given I am on the trains list page
    And The trains list table is visible
    And the following basic schedule is received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | O            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> |        |           |             |         |
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber         | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid>| <trainDescription>  | 13:33                  | 99999               | CREWE                  |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | <trainUid>    | rgba(255, 181, 120, 1) |
    And the following change of ID TJM is received
      | trainUid     | trainNumber        | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid>   | <trainDescription> | 12            | 13:00:00         | create | 94        | 94              | 99999       | CREWBHJ        | 13:00:00 | 82                 | VA                |
    And I invoke the context menu from train '<trainDescription>' on the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location2>" instance 2 is correctly calculated based on "<timestamp2>"
    Examples:
      | cif                                     | trainUid | trainDescription | location | location2  | timestamp | timestamp2 |
      #stopping #STAFFRD
      | access-plan/55226-schedules/55226-5.cif | C55230   | 1U35             | CREWE    | CREWBHJ    |           | 13:00:00   |

  Scenario Outline: 51586 -6  Stop predicting to new destination (cancelled at origin)
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the type 91 has been received for that schedule
    # When the user views the timetable
    # Then no predicted times and punctuality are displayed for any location
    Given I am on the trains list page
    And The trains list table is visible
    And the following basic schedule is received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | O            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> |        |           |             |         |
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber         | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid>| <trainDescription>  | 13:33                  | 99999               | CREWE                  |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | <trainUid>    | rgba(255, 181, 120, 1) |
    And the following change of ID TJM is received
      | trainUid     | trainNumber        | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid>   | <trainDescription> | 12            | 13:00:00         | create | 91        | 91              | 99999       | CREWE          | 13:00:00 | 82                 | VA                |
    And I invoke the context menu from train '<trainDescription>' on the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location2>" instance 2 is correctly calculated based on "<timestamp2>"
    Examples:
      | cif                                     | trainUid | trainDescription | location | location2 | timestamp | timestamp2 |
      | access-plan/55226-schedules/55226-6.cif | C55231   | 1U36             | CREWE    | CREWBHJ   |           |            |

  Scenario Outline: 51586 -7  Stop predicting to new destination (cancelled at Scheduled Location)
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the type 92 has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality are displayed up to the cancelled location
    # And cancelled location only has a predicted arrival time
    # And there are no predicted times for all locations after the new destination
    Given I am on the trains list page
    And The trains list table is visible
    And the following basic schedule is received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | O            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> |        |           |             |         |
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber         | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid>| <trainDescription>  | 10:15                  | 99999               | CREWE                  |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | <trainUid>    | rgba(255, 181, 120, 1) |
    And the following change of ID TJM is received
      | trainUid     | trainNumber        | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid>   | <trainDescription> | 12            | 13:00:00         | create | 92        | 92              | 99999       | MADELEY        | 13:00:00 | 82                 | VA                |
    And I invoke the context menu from train '<trainDescription>' on the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location2>" instance 2 is correctly calculated based on "<timestamp2>"
    And the actual/predicted Departure time for location "<location3>" instance 2 is correctly calculated based on "<timestamp3>"
    Examples:
      | cif                                     | trainUid | trainDescription | location | location2 | location3 | timestamp | timestamp2 |timestamp3 |
      | access-plan/55226-schedules/55226-7.cif | C55232   | 1U37             | CREWE    |  CREWBHJ  | MADELEY   | 13:33:00  | 13:35:00   |           |

  Scenario Outline: 51586 -8  Continue to predict to original destination after a reinstatement
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the <TJM type> has been received for that schedule
    # And a Train Journey Modification with the type 96 has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality are displayed to the original destination

     # | TJM type |
     # | 91|
     # | 92|
    Given I am on the trains list page
    And The trains list table is visible
    And the following basic schedule is received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | O            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> |        |           |             |         |
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber         | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid>| <trainDescription>  | 10:15                  | 99999               | CREWE                  |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | <trainUid>    | rgba(255, 181, 120, 1) |
    And the following change of ID TJM is received
      | trainUid     | trainNumber        | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid>   | <trainDescription> | 12            | 13:00:00         | create | 92        | 91              | 99999       | CREWE          | 13:00:00 | 82                 | VA                |
      | <trainUid>   | <trainDescription> | 12            | 13:00:00         | create | 92        | 92              | 99999       | CREWE          | 13:00:00 | 82                 | VA                |
    And I invoke the context menu from train '<trainDescription>' on the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on "<timestamp>"
    And the actual/predicted Departure time for location "<location2>" instance 2 is correctly calculated based on "<timestamp2>"
    And the actual/predicted Departure time for location "<location3>" instance 2 is correctly calculated based on "<timestamp3>"
    Examples:
      | cif                                     | trainUid | trainDescription | location | location2 | location3 | timestamp | timestamp2 |timestamp3 |
      | access-plan/55226-schedules/55226-8.cif | C55233   | 1U38             | CREWE    |  CREWBHJ  | MADELEY   | 13:33:00  | 13:35:00   |13:38:00   |
