Feature: 34138 - TMV Process LINX Train Running Information

  As a TMV User
  I want the Train Running Information (AKA TRUST movement) messages to be processed
  So that I can update train position

  @tdd
  Scenario Outline: 34138 -1 Display actual times from  TRI
  # Given a TRI message with the <TRI type> is received for a valid schedule
  # When a user views the timetable for that schedule
  # Then the actual time displayed for that location matches that provided in the TRI message

  # Examples:
  # | TRI type |
  # | 01 -Arrival at Termination |
  # | 02 -Departure from Origin |
  # | 03 -Arrival at Station|
  # | 04 -Departure from Station|
  # | 05- Passing Location| |
    #Given I am on the home page
    And the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType   | delay  |
      | <trainUid>   | <trainDescription> | today              | <locationPrimaryCode>| <locationSubsidiaryCode>| <messageType> | <delay>|
    And I am on the timetable view for service '<trainUid>'
    Then the actual '<actualTimeType>' time displayed for that location '<locationSubsidiaryCode>' matches that provided in the TRI message
    Examples:
      | trainUid | trainDescription | messageType            | actualTimeType |locationPrimaryCode  |locationSubsidiaryCode | delay  |
      | H51100   | 5X00             | Departure from Origin  | Departure      | 99999               | PADTON                | 00:01  |
      | H51101   | 5X01             | Arrival at termination | Arrival        | 30870               | OLDOXRS               | 00:01  |
      | H51102   | 5X02             | Arrival at station     | Arrival        | 30870               | OLDOXRS               | 00:01  |
      | H51103   | 5X03             | Departure from station | Departure      | 99999               | PADTON                | 00:01  |
      | H51104   | 5X04             | Passing Location       | Departure      | 30870               | OLDOXRS               | 00:01  |

  @tdd
  Scenario Outline: 34138 -2 Display actual punctuality from TRI
    # Given a TRI message with the <TRI type> is received for a valid schedule
    # When a user views the timetable for that schedule
    # Then the actual punctuality displayed for that location matches that provided in the TRI message

    # Examples:
      # | TRI type |
      # | 01 -Arrival at Termination |
      # | 02 -Departure from Origin |
      # | 03 -Arrival at Station|
      # | 04 -Departure from Station|
      # | 05- Passing Location| |
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And the following train running information message is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType   |
      | <trainUid>   | <trainDescription> | today              | <locationPrimaryCode>| <locationSubsidiaryCode>| <messageType> |
    And I am on the timetable view for service '<trainUid>'
    Then the punctuality is displayed as 'On Time'
    Examples:
      | trainUid | trainDescription | messageType            | locationPrimaryCode  |locationSubsidiaryCode |
      | H51105   | 5X05             | Departure from Origin  |  99999               | PADTON                |
      | H51106   | 5X06             | Arrival at termination |  30870               | OLDOXRS               |
      | H51107   | 5X07             | Arrival at station     |  30870               | OLDOXRS               |
      | H51108   | 5X08             | Departure from station |  99999               | PADTON                |
      | H51109   | 5X09             | Passing Location       |  30870               | OLDOXRS               |

  @tdd
  Scenario Outline: 34138 -3 Display last reported from TRI
    # Given a TRI message with the <TRI type> is received for a valid schedule
    # When a user views the timetable for that schedule
    # Then the last reported information displayed for that schedule matches that provided in the TRI message

    # Examples:
      # | TRI type |
      # | 01 -Arrival at Termination |
      # | 02 -Departure from Origin |
      # | 03 -Arrival at Station|
      # | 04 -Departure from Station|
      # | 05- Passing Location| |
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And the following train running information message is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType   |
      | <trainUid>   | <trainDescription> | today              | <locationPrimaryCode>| <locationSubsidiaryCode>| <messageType> |
    And I am on the timetable view for service '<trainUid>'
    Then the last reported information displayed matches that provided in the TRI message
    Examples:
      | trainUid | trainDescription | messageType            | locationPrimaryCode  |locationSubsidiaryCode |
      | H51110   | 5X10             | Departure from Origin  |  99999               | PADTON                |
      | H51111   | 5X11             | Arrival at termination |  30870               | OLDOXRS               |
      | H51112   | 5X12             | Arrival at station     |  30870               | OLDOXRS               |
      | H51113   | 5X13             | Departure from station |  99999               | PADTON                |
      | H51114   | 5X14             | Passing Location       |  30870               | OLDOXRS               |

  @tdd
  Scenario Outline: 34138 -4 Update existing TRI time with replacement TRI
    # Given a TRI message with the <TRI type> is received for a valid schedule
    # And a TRI with different times for the same location has already been received
    # When a user views the timetable for that schedule
    # Then the time displayed for that schedule matches that provided in the last TRI message

    # Examples:
      # | TRI type |
      # | 01 -Arrival at Termination |
      # | 02 -Departure from Origin |
      # | 03 -Arrival at Station|
      # | 04 -Departure from Station|
      # | 05- Passing Location| |
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And the following train running information message is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType   |
      | <trainUid>   | <trainDescription> | today              | <locationPrimaryCode>| <locationSubsidiaryCode>| <messageType> |
    And the following train running information message is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType   |
      | <trainUid>   | <trainDescription> | today              | <locationPrimaryCode>| <locationSubsidiaryCode>| <messageType> |
    And I am on the timetable view for service '<trainUid>'
    Then the actual '<actualTimeType>' time displayed for that location '<locationSubsidiaryCode>' matches that provided in the TRI message
    Examples:
      | trainUid | trainDescription | messageType            |  actualTimeType |locationPrimaryCode  |locationSubsidiaryCode |
      | H51115   | 5X15             | Departure from Origin  |  Departure      | 99999               | PADTON                |
      | H51116   | 5X16             | Arrival at termination |  Arrival        | 30870               | OLDOXRS               |
      | H51117   | 5X17             | Arrival at station     |  Arrival        | 30870               | OLDOXRS               |
      | H51118   | 5X18             | Departure from station |  Departure      | 99999               | PADTON                |
      | H51119   | 5X19             | Passing Location       |  Departure      | 30870               | OLDOXRS               |

  @tdd
  Scenario Outline: 34138 -5 Update existing time calculated time with TRI
   # Given a TRI message with the <TRI type> is received for a valid schedule
   # And stepping has been received for the same location with a different time (used for calculated timing)
   # When a user views the timetable for that schedule
   # Then the time displayed for that schedule matches that provided in the TRI message

    # Examples:
      # | TRI type |
      # | 01 -Arrival at Termination |
      # | 02 -Departure from Origin |
      # | 03 -Arrival at Station|
      # | 04 -Departure from Station|
      # | 05- Passing Location| |
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And the following train running information message is sent from LINX
      | trainUID     | trainNumber        | scheduledStartDate | locationPrimaryCode  | locationSubsidiaryCode  | messageType   |
      | <trainUid>   | <trainDescription> | today              | <locationPrimaryCode>| <locationSubsidiaryCode>| <messageType> |
    And the following berth step message is sent from LINX (to move train)
      | fromBerth   | timestamp  | toBerth  | trainDescriber  | trainDescription   |
      | <fromBerth> | <timestamp>| <toBerth>| <trainDescriber>| <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    Then the actual '<actualTimeType>' time displayed for that location '<locationSubsidiaryCode>' matches that provided in the TRI message
    Examples:
      | trainUid | trainDescription | trainDescriber  | messageType            |  actualTimeType |locationPrimaryCode  |locationSubsidiaryCode | fromBerth | toBerth | timestamp |
      | H51120   | 5X20             | D3              | Departure from Origin  |  Departure      | 99999               | PADTON                | 0092      | 0092    | 10:02:06  |
      | H51121   | 5X21             | D3              | Arrival at termination |  Arrival        | 30870               | OLDOXRS               | 0244      | 0246    | 10:04:06  |
      | H51122   | 5X22             | D3              | Arrival at station     |  Arrival        | 30870               | OLDOXRS               | 0246      | 0249    | 10:06:06  |
      | H51123   | 5X23             | D3              | Departure from station |  Departure      | 99999               | PADTON                | 0914      | 0920    | 10:08:06  |
      | H51124   | 5X24             | D3              | Passing Location       |  Departure      | 30870               | OLDOXRS               | 0920      | 0945    | 10:10:06  |
