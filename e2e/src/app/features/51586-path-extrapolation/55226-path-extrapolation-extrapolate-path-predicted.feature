Feature: 51586 - TMV - Extrapolate path with predicted path information

  As a TMV user
  I want predicted timings and punctuality to be calculated
  So that I can see how the train is expected to progress compared to its timetable

  Background:
    * I remove all trains from the trains list
    * I reset redis

  Scenario Outline: 51586 -1 No prediction prior to activation
    # Given a valid schedule exists
    # And no train activation has been received for that schedule
    # And no TRI or berth stepping has been received for that schedule
    # When the user views the timetable
    # Then there are no predicted times or punctuality displayed for the locations in the schedule
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    Given the access plan located in CIF file '<cif>' is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    When I am on the timetable view for service '<trainUid>'
    Then the Departure time for location "Crewe" instance 1 is ""
    Examples:
      | cif                                     | trainUid  | trainDescription |
      | access-plan/55226-schedules/55226.cif   | generated | 3U01             |

  Scenario Outline: 51586 -2 Start predicting following activation
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed for all locations in the schedule
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    When I am on the timetable view for service '<trainUid>'
    Then the Departure time for location "Crewe" instance 1 is "now"
    And the Departure time for location "Crewe Basford Hall Jn" instance 1 is "now + 3"
    Examples:
      | cif                                     | trainUid  | trainDescription |
      | access-plan/55226-schedules/55226-2.cif | generated | 3U02             |

  Scenario Outline: 51586 -3 Start predicting following TRI
    # Given a valid schedule exists
    # And train has not been activated
    # And a Train running information message has been received for the origin for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed for all locations in the schedule after the TRI location
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode  | messageType           | delay | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 42140                 | CREWE                   | Departure from Origin | 00:01 | now                  |
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "Crewe" instance 1 is correctly calculated based on External timing "now"
    And the Departure time for location "Crewe Basford Hall Jn" instance 1 is "now + 3"
    Examples:
      | cif                                     | trainUid  | trainDescription |
      | access-plan/55226-schedules/55226.cif   | generated | 3U03             |

  Scenario Outline: 51586 -4 Start predicting following TD update
    # Given a valid schedule exists
    # And train has not been activated
    # And a TD update has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed for all locations in the schedule
    * I generate a new trainUID
    * I generate a new train description
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth step messages is sent from LINX
      | fromBerth | toBerth | trainDescriber | trainDescription   |
      | A120      | 0104    | CE             | <trainDescription> |
    And I give the TD Message 2 seconds to be processed
    When I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "Crewe" instance 1 is correctly calculated based on Internal timing "now"
    And the Departure time for location "Crewe Basford Hall Jn" instance 1 is "now + 3"
    Examples:
      | cif                                     | trainUid  | trainDescription |
      | access-plan/55226-schedules/55226-4.cif | generated | generated        |

  @bug @bug:80955
  Scenario Outline: 51586 -5  Start predicting from new origin
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the type 94 has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality is displayed from the new origin
    # And there are no predicted times for the locations prior to the new origin
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | 94        | 94              | 99999       | CREWBHJ        | now      | 94                 | PL                |
    And I am on the timetable view for service '<trainUid>'
    Then the Departure time for location "Crewe" instance 1 is ""
    And the Departure time for location "Crewe Basford Hall Jn" instance 1 is "now + 3"
    Examples:
      | cif                                     | trainUid  | trainDescription |
      | access-plan/55226-schedules/55226-5.cif | generated | 3U05             |

  @bug @bug:80955
  Scenario Outline: 51586 -6  Stop predicting to new destination (cancelled at origin)
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the type 91 has been received for that schedule
    # When the user views the timetable
    # Then no predicted times and punctuality are displayed for any location
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | 91        | 91              | 99999       | CREWE          | now      | 82                 | VA                |
    And I am on the timetable view for service '<trainUid>'
    Then the Departure time for location "Crewe" instance 1 is ""
    And the Departure time for location "Crewe Basford Hall Jn" instance 1 is ""
    Examples:
      | cif                                     | trainUid  | trainDescription |
      | access-plan/55226-schedules/55226-6.cif | generated | 3U06             |

  @bug @bug:80955
  Scenario Outline: 51586 -7  Stop predicting to new destination (cancelled at Scheduled Location)
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the type 92 has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality are displayed up to the cancelled location
    # And cancelled location only has a predicted arrival time
    # And there are no predicted times for all locations after the new destination
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | 92        | 92              | 99999       | STAFFRD        | now      | 82                 | VA                |
    And I am on the timetable view for service '<trainUid>'
    Then the Arrival time for location "Stafford" instance 1 is "now + 18"
    And the Departure time for location "Stafford" instance 1 is ""
    Examples:
      | cif                                     | trainUid  | trainDescription |
      | access-plan/55226-schedules/55226-7.cif | generated | 3U07             |

  Scenario Outline: 51586 -8  Continue to predict to original destination after a reinstatement - <type>, <location>
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the <TJM type> has been received for that schedule
    # And a Train Journey Modification with the type 96 has been received for that schedule
    # When the user views the timetable
    # Then predicted times and punctuality are displayed to the original destination

     # | TJM type |
     # | 91|
     # | 92|
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | <type>    | <type>          | 99999       | <location>     | now      | 82                 | VA                |
    And the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | 12            | create | 96        | 96              | 99999       | CREWE          | now      | 82                 | VA                |
    And I am on the timetable view for service '<trainUid>'
    Then the Arrival time for location "London Euston" instance 1 is "now + 138"
    Examples:
      | cif                                     | trainUid  | trainDescription | type | location |
      | access-plan/55226-schedules/55226-8.cif | generated | 3U08             | 91   | CREWE    |
      | access-plan/55226-schedules/55226-8.cif | generated | 3U08             | 92   | STAFFRD  |

  Scenario Outline: 51586-9  Display predicted departure time for an Origin - <rationale>
    # Given a valid schedule exists
    # And a train activation has been received
    # And no actual timing has been received for the origin location
    # And the planned origin departure time is in the <time>
    # When a user views the timetable
    # Then < predicted time> is displayed in the timetable for the origin
    # And the predicted punctuality is displayed for the origin
    # | Time   | Predicted Time           |
    # | Future | Planned origin departure |
    # | Past   | current time             |
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now <operator> '<minutes>' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I am on the timetable view for service '<trainUid>'
    Then the Departure time for location "Crewe" instance 1 is "<expectedDeparture>"
    And the Departure punctuality for location "Crewe" instance 1 is "<punctuality>"
    Examples:
      | cif                                     | trainUid  | trainDescription | operator | minutes | expectedDeparture | punctuality          | rationale                    |
      | access-plan/55226-schedules/55226-9.cif | generated | 3U91             | +        | 10      | now + 10          | +0m                  | Departure time in the future |
      | access-plan/55226-schedules/55226-9.cif | generated | 3U92             | -        | 10      | now               | +10m or +11m or +12m | Departure time in the past   |

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
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I am on the timetable view for service '<trainUid>'
    Then the Arrival time for location "Stafford" instance 1 is "now + 18"
    And the Arrival punctuality for location "Stafford" instance 1 is "+0m or +1m"
    And the Arrival time for location "London Euston" instance 1 is "now + 139"
    And the Arrival punctuality for location "London Euston" instance 1 is "+0m or +1m"

    Examples:
      | cif                                      | trainUid  | trainDescription |
      | access-plan/55226-schedules/55226-10.cif | generated | 3U10             |

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

    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I give the activation 2 seconds to process
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Departure time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    And the actual/predicted Departure time for location "<location2>" instance 1 is correctly calculated based on Internal timing "<timestamp2>"
    And the actual/predicted Departure time for location "<location3>" instance 1 is correctly calculated based on Internal timing "<timestamp3>"
    And the Departure punctuality for location "<location>" instance 1 is "+0m or +1m or +2m"
    And the Departure punctuality for location "<location2>" instance 1 is "+0m or +1m or +2m"
    And the Departure punctuality for location "<location3>" instance 1 is "+0m or +1m or +2m"

    Examples:
      | cif                                      | trainUid  | trainDescription | location      | location2 | location3            | timestamp | timestamp2 | timestamp3 |
      | access-plan/55226-schedules/55226.cif    | generated | 3U11             | Norton Bridge | Colwich   | Rugeley Trent Valley | now + 12  | now + 26   | now + 30   |

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
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I give the activation 2 seconds to process
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And I am on the timetable view for service '<trainUid>'
    Then the actual/predicted Arrival time for location "<location>" instance 1 is correctly calculated based on Internal timing "<timestamp>"
    And the actual/predicted Arrival time for location "<location2>" instance 1 is correctly calculated based on Internal timing "<timestamp2>"

    Examples:
      | cif                                      | trainUid  | trainDescription | location | location2        | timestamp | timestamp2 |
      | access-plan/55226-schedules/55226-12.cif | generated | 3U12             | Crewe    | Rugeley North Jn |           |            |

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
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now <operator> '<minutes>' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I give the activation 2 seconds to process
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And I am on the timetable view for service '<trainUid>'
    Then the actual/predicted departure time for location "<location>" instance 1 matches the planned departure time
    And the Departure punctuality for location "<location>" instance 1 is "+0m"
    Examples:
      | cif                                      | trainUid  | trainDescription | location  | operator | minutes |
      | access-plan/55226-schedules/55226-13.cif | generated | 3U13             | Stafford  | +        | 2       |

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
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now <operator> '<minutes>' minutes, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I give the activation 2 seconds to process
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And I am on the timetable view for service '<trainUid>'
    Then the actual/predicted departure time for location "<location>" instance 1 is + 2 mins after the actual/predicted arrival time
    And the Departure punctuality for location "<location>" instance 1 is "+1m or +2m"
    Examples:
      | cif                                   | trainUid  | trainDescription | location | operator | minutes |
      | access-plan/55226-schedules/55226.cif | generated | 3U14             | Stafford | -        | 4       |

  Scenario Outline: 51586 -15  Predicted arrival time after an actual
    # Given a valid schedule exists
    # And a train activation has been received
    # And there is location in that schedule with the <Location Type>
    # And an actual departure timing has been received for the location prior
    # When a user views the timetable
    # Then predicted timing displayed is the current punctuality + the planned location arrival time
    # And predicted punctuality is displayed

      # | Location type |
      # | Stopping|
      # | Destination |
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I give the activation 2 seconds to process
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode  | messageType           | delay | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 42140                 | CREWE                   | Departure from Origin | 00:01 | now                  |
    And I give the TRI 2 seconds to process
    And I am on the timetable view for service '<trainUid>'
    Then the predicted arrival time displayed for location "<location>" instance 1 is the current punctuality + the planned location arrival time
    And the Departure punctuality for location "<location>" instance 1 is "-0m or +0m or +1m"
    Then the predicted arrival time displayed for location "<location2>" instance 1 is the current punctuality + the planned location arrival time
    And the Departure punctuality for location "<location2>" instance 1 is "-0m or +0m or +1m"

    Examples:
      | cif                                   | trainUid  | trainDescription | location  | location2     |
      | access-plan/55226-schedules/55226.cif | generated | 3U15             | Stafford  | London Euston |

  Scenario Outline: 51586 - 16  Predicted passing location departure time after an actual
    # Given a valid schedule exists
    # And a train activation has been received
    # And there is a passing location in that schedule
    # And an actual departure timing has been received for the location prior
    # When a user views the timetable
    # Then predicted timing is displayed is current punctuality+ planned location departure time
    # And predicted punctuality is displayed
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I give the activation 2 seconds to process
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode  | messageType           | delay | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 42140                 | CREWE                   | Departure from Origin | 00:01 | now                  |
    And I give the TRI 2 seconds to process
    And I am on the timetable view for service '<trainUid>'
    Then the predicted departure time displayed for location "<location>" instance 1 is the current punctuality + the planned location departure time
    And the Departure punctuality for location "<location>" instance 1 is "-1m or -0m or +0m or +1m"

    Examples:
      | cif                                   | trainUid  | trainDescription | location      |
      | access-plan/55226-schedules/55226.cif | generated | 3U16             | Norton Bridge |

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
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I give the activation 2 seconds to process
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode  | messageType        | delay | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 43314                 | STAFFRD                 | Arrival at Station | 00:01 | now                  |
    And I am on the timetable view for service '<trainUid>'
    Then the predicted departure time displayed for location "<location>" instance 1 is the current punctuality + the planned location departure time
    And the Departure punctuality for location "<location>" instance 1 is "-0m or +0m"

    Examples:
      | cif                                   | trainUid  | trainDescription | location      |
      | access-plan/55226-schedules/55226.cif | generated | 3U17             | Stafford      |

  Scenario Outline: 51586 - 18 Actuals received before new origin
    # Given a valid schedule exists
    # And a train activation has been received for that schedule
    # And a Train Journey Modification with the type 94 has been received for that schedule
    # And a TD update is received for a location before the new origin
    # When the user views the timetable
    # Then predicted times and punctuality from the last actual
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I give the activation 2 seconds to process
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | <trainUid> | <trainDescription> | now           | create | 94        | 94              | 43331       | RUGL           | now  | 82                 | VA                |
    And I give the tjm 2 seconds to process
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode  | messageType        | delay | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 43314                 | STAFFRD                 | Arrival at Station | 00:01 | now                  |
    And I am on the timetable view for service '<trainUid>'
    Then the predicted departure time displayed for location "<location>" instance 1 is the current punctuality + the planned location departure time
    And the Departure punctuality for location "<location>" instance 1 is "-0m or +0m"

    Examples:
      | cif                                   | trainUid  | trainDescription | location      |
      | access-plan/55226-schedules/55226.cif | generated | 3U18             | Stafford      |

  @bug @bug:80955
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
    * I generate a new trainUID
    * I delete '<trainUid>:today' from hash 'schedule-modifications'
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath  | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <cif>     | CREWE       | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate |
      | <trainUid> | <trainDescription> | now                    | 42140               | CREWE                  | today         |
    And I give the activation 2 seconds to process
    And I log the berth & locations from the berth level schedule for '<trainUid>'
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode   | subsidiaryCode         | time | modificationReason   | nationalDelayCode   |
      | <trainUid> | <trainDescription> | now           | create | <tjmType> | <tjmType>       | <primaryCode> | <cancellationLocation> | now  | <modificationReason> | <nationalDelayCode> |
    And I give the tjm 2 seconds to process
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode  | messageType        | delay | hourDepartFromOrigin |
      | <trainUid> | <trainDescription> | today              | 69021                 | NNTN                    | Arrival at Station | 00:01 | now                  |
    And I am on the timetable view for service '<trainUid>'
    Then the predicted departure time displayed for location "<location>" instance 1 is the current punctuality + the planned location departure time
    And the Departure punctuality for location "<location>" instance 1 is "-0m or +0m"
    And the actual/predicted Arrival time for location "Milton Keynes Central" instance 1 is correctly calculated based on External timing ""
    And the actual/predicted Arrival time for location "London Euston" instance 1 is correctly calculated based on External timing ""

    Examples:
      | cif                                   | trainUid  | trainDescription | location | tjmType | modificationReason | nationalDelayCode | primaryCode | cancellationLocation |
      | access-plan/55226-schedules/55226.cif | generated | 3U19             | Nuneaton | 91      | 12                 | PD                | 42140       | CREWE                |
      | access-plan/55226-schedules/55226.cif | generated | 3U29             | Nuneaton | 92      | 19                 | OZ                | 43331       | RUGL                 |
