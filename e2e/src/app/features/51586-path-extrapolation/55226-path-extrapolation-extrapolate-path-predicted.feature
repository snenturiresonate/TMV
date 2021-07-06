@bug @bug:64527
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
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    When I am on the timetable view for service '<trainUid>'
    Then the Departure time for location "Crewe" instance 1 is ""
    Examples:
      | cif                                     | trainUid | trainDescription |
      | access-plan/55226-schedules/55226-1.cif | C55001   | 3U01             |

  Scenario Outline: 51586 -2 Start predicting following activation
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed for all locations in the schedule
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | 13:00                  | 99999               | CREWE                  | today         |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    When I am on the timetable view for service '<trainUid>'
    Then the Departure time for location "Crewe" instance 1 is "(13:33:00)"
    And the Departure time for location "Crewe Basford Hall Jn" instance 1 is "(13:36:00)"
    Examples:
      | cif                                     | trainUid | trainDescription |
      | access-plan/55226-schedules/55226-2.cif | C55002   | 3U02             |

  Scenario Outline: 51586 -3 Start predicting following TRI
    # Given a valid schedule exists
    # And train has not been activated
    # And a Train running information message has been received for the origin for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed for all locations in the schedule after the TRI location
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train running information message are sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <trainUid> | <trainDescription> | today              | 99999               | CREWE                  | Departure from Origin |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "Crewe" instance 1 is correctly calculated based on External timing "13:33:00"
    And the Departure time for location "Crewe Basford Hall Jn" instance 1 is "(13:36:00)"
    Examples:
      | cif                                     | trainUid | trainDescription |
      | access-plan/55226-schedules/55226-3.cif | C55003   | 3U03             |

  Scenario Outline: 51586 -4 Start predicting following TD update
    # Given a valid schedule exists
    # And train has not been activated
    # And a TD update has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed for all locations in the schedule
    Given I am on the trains list page
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following berth step messages is sent from LINX
      | timestamp | fromBerth | toBerth | trainDescriber | trainDescription   |
      | 13:33:00  | A120      | 0104    | CE             | <trainDescription> |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "Crewe" instance 1 is correctly calculated based on Internal timing "13:33:00"
    And the Departure time for location "Crewe Basford Hall Jn" instance 1 is "(13:36:00)"
    Examples:
      | cif                                     | trainUid | trainDescription |
      | access-plan/55226-schedules/55226-4.cif | C55004   | 3U04             |

  Scenario Outline: 51586 -5  Start predicting from new origin
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the type 94 has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed from the new origin
    # And there are no predicted times for the locations prior to the new origin
    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid> | <trainDescription> | 13:33                  | 99999               | CREWE                  |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | 94        | 94              | 99999       | CREWBHJ        | 12:00:00 | 94                 | PL                |
    And I am on the timetable view for service '<trainUid>'
    Then the Departure time for location "Crewe" instance 1 is ""
    And the Departure time for location "Crewe Basford Hall Jn" instance 1 is "(13:36:00)"
    Examples:
      | cif                                     | trainUid | trainDescription |
      | access-plan/55226-schedules/55226-5.cif | C55005   | 3U05             |

  Scenario Outline: 51586 -6  Stop predicting to new destination (cancelled at origin)
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the type 91 has been received for that schedule
    # When the user views the timetable
    # Then no predicted times and punctuality are displayed for any location
    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid> | <trainDescription> | 13:33                  | 99999               | CREWE                  |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | 91        | 91              | 99999       | CREWBHJ        | 12:00:00 | 82                 | VA                |
    And I am on the timetable view for service '<trainUid>'
    Then the Departure time for location "Crewe" instance 1 is ""
    And the Departure time for location "Crewe Basford Hall Jn" instance 1 is ""
    Examples:
      | cif                                     | trainUid | trainDescription |
      | access-plan/55226-schedules/55226-6.cif | C55006   | 3U06             |

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
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid> | <trainDescription> | 10:15                  | 99999               | CREWE                  |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | 92        | 92              | 99999       | STAFFRD        | 12:00:00 | 82                 | VA                |
    And I am on the timetable view for service '<trainUid>'
    Then the Arrival time for location "Stafford" instance 1 is "(13:51:00)"
    And the Departure time for location "Stafford" instance 1 is ""
    Examples:
      | cif                                     | trainUid | trainDescription |
      | access-plan/55226-schedules/55226-7.cif | C55007   | 3U07             |

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
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid> | <trainDescription> | 10:15                  | 99999               | CREWE                  |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | <type>    | <type>          | 99999       | <location>     | 12:00:00 | 82                 | VA                |
    And the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | 96        | 96              | 99999       | CREWE          | 12:00:00 | 82                 | VA                |
    And I am on the timetable view for service '<trainUid>'
    Then the Arrival time for location "London Euston" instance 1 is "(15:52:00)"
    Examples:
      | cif                                     | trainUid | trainDescription | type | location |
      | access-plan/55226-schedules/55226-8.cif | C55008   | 3U08             | 91   | CREWE    |
      | access-plan/55226-schedules/55226-8.cif | C55008   | 3U08             | 92   | STAFFRD  |

  Scenario Outline: 51586-9  Display predicted departure time for an Origin
    # Given a valid schedule exists
    # And a train activation has been received
    # And no actual timing has been received for the origin location
    # And the planned origin departure time is in the <time>
    # When a user views the timetable
    # Then < predicted time> is displayed in the timetable for the origin
    # And the predicted punctuality is displayed for the origin

      # | Time | Predicted Time|
      # | Future | Planned origin departure|
      # | Past | current time |

    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And I am on the timetable view for service '<trainUid>'
    Then the predicted Departure punctuality for location "Crewe" instance 1 is correctly calculated based on the planned time of '13:33:00' or the current time
    Examples:
      | cif                                     | trainUid | trainDescription |
      | access-plan/55226-schedules/55226-9.cif | C55009   | 3U09             |

  Scenario Outline: 51586-10 Display predicted arrival time
    # Given a valid schedule exists
    # And a train activation has been received
    # And there is location in that schedule with the <Location Type>
    # And no actual timing has been received for that location or the location prior
    # When a user views the timetable
    # Then predicted timing is displayed is predicted punctuality at previous location + planned location arrival time
    # And predicted punctuality is displayed

      # | Location type |
      # | Stopping|
      # | Destination |

    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And I am on the timetable view for service '<trainUid>'
    Then the predicted Departure punctuality for location "Stafford" instance 1 is correctly calculated based on the planned time of '13:52:00' or the current time
    Then the predicted Departure punctuality for location "London Euston" instance 1 is correctly calculated based on the planned time of '15:52:00' or the current time

    Examples:
      | cif                                      | trainUid | trainDescription |
      | access-plan/55226-schedules/55226-10.cif | C55010   | 3U10             |

  Scenario Outline: 51586 - 11  Display predicted departure time
    # Given a valid schedule exists
    # And a train activation has been received
    # And there is location in that schedule with the <Location Type>
    # And no actual timing has been received for that location or the location prior
    # When a user views the timetable
    # Then predicted timing is displayed is predicted punctuality at previous location + planned location departure time
    # And predicted punctuality is displayed

      # | Location type |
      # | Passing  Planned|
      # | Passing  Inserted|
      # | Stopping |

    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Departure time for location "<location>" instance 4 is correctly calculated based on Internal timing "<timestamp>"
    And the actual/predicted Departure time for location "<location2>" instance 6 is correctly calculated based on Internal timing "<timestamp2>"
    And the actual/predicted Departure time for location "<location3>" instance 8 is correctly calculated based on Internal timing "<timestamp3>"
    And the Departure punctuality for location "<location>" instance 4 is correctly calculated based on expected time "<plannedTime>" & actual time "<timestamp>"
    And the Departure punctuality for location "<location>" instance 6 is correctly calculated based on expected time "<plannedTime2>" & actual time "<timestamp2>"
    And the Departure punctuality for location "<location>" instance 8 is correctly calculated based on expected time "<plannedTime3>" & actual time "<timestamp3>"

    Examples:
      | cif                                      | trainUid | trainDescription | location | location2 | location3 | timestamp | timestamp2 | timestamp3 | plannedTime | plannedTime2 | plannedTime3 |
      | access-plan/55226-schedules/55226-11.cif | C55011   | 3U11             | NTNB     | COLWICH   | RUGL      | 13:45:00  | 14:01:00   | 15:01:00   | 13:39:00    | 14:01:00     | 14:03:00     |

  Scenario Outline: 51586 - 12  Predicted arrival time not displayed for origin or passing locations
    # Given a valid schedule exists
    # And a train activation has been received
    # And there is location in that schedule with the <Location Type>
    # And no actual timing has been received for that location
    # When a user views the timetable
    # Then no predicted timing is displayed in the timetable for the arrival time at that location

      # | Location type |
      # | Origin|
      # | Passing |
    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    And the actual/predicted Departure time for location "<location2>" instance 1 is correctly calculated based on Internal timing "<timestamp2>"

    Examples:
      | cif                                      | trainUid | trainDescription | location | location2 | timestamp | timestamp2 |
      | access-plan/55226-schedules/55226-12.cif | C55012   | 3U12             | CREWE    | RUGL      |           |            |

  Scenario Outline: 51586 - 13  Adjusting punctuality for an early train at a stopping location
    # Given a valid schedule exists
    # And a train activation has been received
    # And there is a stopping location in that schedule
    # And no actual departure timing has been received for that location
    # And the train <Time Type> early
    # When a user views the timetable
    # Then the predicted departure time displayed is the same as the plan
    # And the punctuality for that location is shown as on time

      # | Time type |
      # | is Predicted to arrive|
      # | has Actually arrived |
    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | B136      | 13:35:06  | A136    | CE             | <trainDescription> |
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    And the punctuality is displayed as 'On Time'
    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp |
      | access-plan/55226-schedules/55226-13.cif | C55013   | 3U13             | RUGL     | 14:04:00  |

  Scenario Outline: 51586 - 14 Adjusting punctuality with minimum dwell for a late train at a stopping location
    # Given a valid schedule exists
    # And a train activation has been received
    # And there is a stopping location in that schedule
    # And no actual departure timing has been received for that location
    # And the train <Time Type> late
    # When a user views the timetable
    # Then the predicted departure time displayed is the arrival time + minimum dwell
    # And the punctuality for that location is shown as late

      # | Time type |
      # | is Predicted to arrive|
      # | has Actually arrived |
    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | B136      | 13:35:06  | A136    | CE             | <trainDescription> |
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    And the punctuality is displayed as 'Late'
    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp |
      | access-plan/55226-schedules/55226-14.cif | C55014   | 3U14             | RUGL     | 14:07:00  |

  Scenario Outline: 51586 -15  Predicted arrival time after an actual
    # Given a valid schedule exists
    # And a train activation has been received
    # And there is location in that schedule with the <Location Type>
    # And an actual departure timing has been received for the location prior
    # When a user views the timetable
    # Then predicted timing is displayed is current punctuality+ planned location arrival time
    # And predicted punctuality is displayed

      # | Location type |
      # | Stopping|
      # | Destination |
    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | 5474      | 14:25:06  | 5470    | R2             | <trainDescription> |
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | 3190      | 15:48:06  | 3188    | R1             | <trainDescription> |
    And the actual/predicted Arrival time for location "<location2>" instance 1 is correctly calculated based on Internal timing "<timestamp2>"
    And the punctuality is displayed as 'On Time'
    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp | location2 | timestamp2 |
      | access-plan/55226-schedules/55226-15.cif | C55015   | 3U15             | RUGL     | 14:05:00  | EUSTON    | 15:52:00   |

  Scenario Outline: 51586 - 16  Predicted passing location departure time after an actual
    # Given a valid schedule exists
    # And a train activation has been received
    # And there is a passing location in that schedule
    # And an actual departure timing has been received for the location prior
    # When a user views the timetable
    # Then predicted timing is displayed is current punctuality+ planned location departure time
    # And predicted punctuality is displayed
    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | 3620      | 13:39:06  | 3618    | R3             | <trainDescription> |
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    And the punctuality is displayed as 'On Time'
    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp |
      | access-plan/55226-schedules/55226-16.cif | C55016   | 3U16             | NTNB     | 13:39:00  |

  Scenario Outline: 51586 - 17 Predicted stopping location departure time after an actual arrival time
    # Given there is a valid schedule
    # And a train activation has been received
    # And the train has arrived at a stopping location
    # And no actual departure timing has been received for that location
    # And the trains <Arrival Time>
    # When a user views the timetable
    # Then the predicted departure time is <Predicted departure time>
    # And the predicted punctuality is <Punctuality>

      # | Arrival time                                                                        | Punctuality | Predicted Departure Time|
      # | actual arrival time + minimum dwell time is less than the  planned departure time  |  On time    | planned departure time |
      # | actual arrival time + minimum dwell time is more than the planned departure time  | Late        | arrival time + minimum dwell time |
    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | 0110      | 13:35:06  | 0112    | WY             | <trainDescription> |
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    And the punctuality is displayed as 'On Time'
    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp |
      | access-plan/55226-schedules/55226-17.cif | C55017   | 3U17             | RUGL     | 14:05:00  |

  Scenario Outline: 51586 - 18 Actuals received before new origin
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the type 94 has been received for that schedule
    # And a TD update is received for a location before the new origin
    # When the user views the timetable
    # Then predicted times and punctuality from the last actual
    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | A120      | 13:33:06  | B120    | CE             | <trainDescription> |
    And the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | 94        | 94              | 99999       | COLWICH        | 14:02:00 | 82                 | VA                |
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp |
      | access-plan/55226-schedules/55226-18.cif | C55018   | 3U18             | RUGLYNJ  | 14:03:00  |

  Scenario Outline: 51586 - 19  Actuals after a new destination
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the <TJM type> has been received for that schedule
    # And a TD update has been received for a location after the new destination
    # When the user views the timetable
    # Then predicted times and punctuality are only present to the new destination

      # | TJM type |
      # | 91|
      # | 92|
    Given I am on the trains list page
    And The trains list table is visible
    And the access plan located in CIF file '<cif>' is received from LINX
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 99999               | CREWE                  | today         | now                 |
    And the following service is displayed on the trains list
      | trainId            | trainUId   |
      | <trainDescription> | <trainUid> |
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And the following change of ID TJM is received
      | trainUid   | trainNumber        | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | 13:00:00         | create | 92        | 91              | 99999       | CREWE          | 13:00:00 | 82                 | VA                |
      | <trainUid> | <trainDescription> | 12            | 13:00:00         | create | 92        | 92              | 99999       | CREWE          | 13:00:00 | 82                 | VA                |
    And the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth | trainDescriber | trainDescription   |
      | A120      | 13:33:06  | B120    | CE             | <trainDescription> |
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<trainUid>' from the trains list
    And I wait for the trains list context menu to display
    And the trains list context menu is displayed
    When I open timetable from the context menu
    And I switch to the new tab
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    Examples:
      | cif                                      | trainUid | trainDescription | location | timestamp |
      | access-plan/55226-schedules/55226-19.cif | C55019   | 3U19             | CREWE    | 13:00:00  |
