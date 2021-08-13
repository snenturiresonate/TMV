Feature: 34138 - TMV Process LINX Train Running Information

  As a TMV User
  I want the Train Running Information (AKA TRUST movement) messages to be processed
  So that I can update train position

  Background:
    Given I remove all trains from the trains list

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
    * I remove today's train '<trainUid>' from the Redis trainlist
    Given there is a Schedule for '<trainDescription>'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 12:00              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 12:05            | 12:06              |      |      |
    And it has Intermediate Details
      | tiploc | scheduledArrival | scheduledDeparture | path | line |
      | LDBRKJ |                  | 12:12              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 12:30            |      |
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator | dateRunsFrom |
      | <trainUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode   | messageType   | delay   |
      | <trainUid> | <trainDescription> | today              | <locationPrimaryCode> | <locationSubsidiaryCode> | <messageType> | <delay> |
    And I am on the timetable view for service '<trainUid>'
    Then the actual '<actualTimeType>' time displayed for that location '<location>' matches that provided in the TRI message
    Examples:
      | trainUid | trainDescription | messageType            | actualTimeType | locationPrimaryCode | location           | locationSubsidiaryCode | delay |
      | H51100   | 5X00             | Departure from Origin  | Departure      | 73000               | London Paddington  | PADTON                 | 00:01 |
      | H51101   | 5X01             | Arrival at termination | Arrival        | 73216               | Old Oak Depot      | OLDOXRS                | 00:01 |
      | H51102   | 5X02             | Arrival at station     | Arrival        | 73108               | Royal Oak Junction | ROYAOJN                | 00:01 |
      | H51103   | 5X03             | Departure from station | Departure      | 73108               | Royal Oak Junction | ROYAOJN                | 00:01 |
      | H51104   | 5X04             | Passing Location       | Departure      | 73111               | Ladbroke Grove     | LDBRKJ                 | 00:01 |

  Scenario Outline: 34138 -2 Display actual punctuality from TRI
    # Given a TRI message with the <TRI type> is received for a valid schedule
    # When a user views the timetable for that schedule
    # Then the actual punctuality displayed for that location matches that provided in the TRI message

    # Examples:
      # | TRI type |
      # | 01 -Arrival at Termination |
      # | 02 -Departure from Origin |
      # | 03 -Arrival at Station| - note this was deemed to be not in scope: punctuality shown will be predicted departure in this particular case
      # | 04 -Departure from Station|
      # | 05- Passing Location| |
    * I remove today's train '<trainUid>' from the Redis trainlist
    Given there is a Schedule for '<trainDescription>'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 12:00              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 12:05            | 12:06              |      |      |
    And it has Intermediate Details
      | tiploc | scheduledArrival | scheduledDeparture | path | line |
      | LDBRKJ |                  | 12:12              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 12:30            |      |
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator | dateRunsFrom |
      | <trainUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode   | messageType   | delay   |
      | <trainUid> | <trainDescription> | today              | <locationPrimaryCode> | <locationSubsidiaryCode> | <messageType> | <delay> |
    And I am on the timetable view for service '<trainUid>'
    Then the punctuality for 'planned' location '<location>' is displayed as '<punctualityString>'
    Examples:
      | trainUid | trainDescription | messageType            | locationPrimaryCode | location           | locationSubsidiaryCode | delay  | punctualityString |
      | H51105   | 5X05             | Departure from Origin  | 73000               | London Paddington  | PADTON                 | 00:00  | +0m               |
      | H51106   | 5X06             | Arrival at termination | 73216               | Old Oak Depot      | OLDOXRS                | 00:01  | +1m               |
#      | H51107   | 5X07             | Arrival at station     | 73108               | Royal Oak Junction | ROYAOJN                | -00:03 | -3m               |
      | H51108   | 5X08             | Departure from station | 73108               | Royal Oak Junction | ROYAOJN                | 01:20  | +1h 20m           |
      | H51109   | 5X09             | Passing Location       | 73111               | Ladbroke Grove     | LDBRKJ                 | -00:17 | -17m              |

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
    * I remove today's train '<trainUid>' from the Redis trainlist
    Given there is a Schedule for '<trainDescription>'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 12:00              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 12:05            | 12:06              |      |      |
    And it has Intermediate Details
      | tiploc | scheduledArrival | scheduledDeparture | path | line |
      | LDBRKJ |                  | 12:12              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 12:30            |      |
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator | dateRunsFrom |
      | <trainUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode   | messageType   |
      | <trainUid> | <trainDescription> | today              | <locationPrimaryCode> | <locationSubsidiaryCode> | <messageType> |
    And I am on the timetable view for service '<trainUid>'
    Then the last reported information reflects the TRI message '<message>' for '<locationName>'
    Examples:
      | trainUid | trainDescription | messageType            | locationPrimaryCode | locationSubsidiaryCode | message                           | locationName       |
      | H51110   | 5X10             | Departure from Origin  | 73000               | PADTON                 | Departure from London Paddington  | London Paddington  |
      | H51111   | 5X11             | Arrival at termination | 73216               | OLDOXRS                | Arrival at Old Oak Depot          | Old Oak Depot      |
      | H51112   | 5X12             | Arrival at station     | 73108               | ROYAOJN                | Arrival at Royal Oak Junction     | Royal Oak Junction |
      | H51113   | 5X13             | Departure from station | 73108               | ROYAOJN                | Departure from Royal Oak Junction | Royal Oak Junction |
      | H51114   | 5X14             | Passing Location       | 73111               | LDBRKJ                 | Departure from Ladbroke Grove     | Ladbroke Grove     |

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
    * I remove today's train '<trainUid>' from the Redis trainlist
    Given there is a Schedule for '<trainDescription>'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 12:00              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 12:05            | 12:06              |      |      |
    And it has Intermediate Details
      | tiploc | scheduledArrival | scheduledDeparture | path | line |
      | LDBRKJ |                  | 12:12              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 12:30            |      |
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator | dateRunsFrom |
      | <trainUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode   | messageType   |
      | <trainUid> | <trainDescription> | today              | <locationPrimaryCode> | <locationSubsidiaryCode> | <messageType> |
    And the following train running information message with delay against booked time is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode   | messageType   | delay            |
      | <trainUid> | <trainDescription> | today              | <locationPrimaryCode> | <locationSubsidiaryCode> | <messageType> | <secondTRIdelay> |
    And I am on the timetable view for service '<trainUid>'
    Then the actual '<actualTimeType>' time displayed for that location '<location>' matches that provided in the TRI message
    Examples:
      | trainUid | trainDescription | messageType            | actualTimeType | locationPrimaryCode | location           | locationSubsidiaryCode | secondTRIdelay |
      | H51115   | 5X15             | Departure from Origin  | Departure      | 73000               | London Paddington  | PADTON                 | 00:05          |
      | H51116   | 5X16             | Arrival at termination | Arrival        | 73216               | Old Oak Depot      | OLDOXRS                | -00:25         |
      | H51117   | 5X17             | Arrival at station     | Arrival        | 73108               | Royal Oak Junction | ROYAOJN                | 01:03          |
      | H51118   | 5X18             | Departure from station | Departure      | 73108               | Royal Oak Junction | ROYAOJN                | -00:12         |
      | H51119   | 5X19             | Passing Location       | Departure      | 73111               | Ladbroke Grove     | LDBRKJ                 | 02:30          |


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
    * I remove today's train '<trainUid>' from the Redis trainlist
    Given there is a Schedule for '<trainDescription>'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 12:00              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 12:05            | 12:06              |      |      |
    And it has Intermediate Details
      | tiploc | scheduledArrival | scheduledDeparture | path | line |
      | LDBRKJ |                  | 12:12              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 12:30            |      |
    And the schedule has schedule identifier characteristics
      | trainUid   | stpIndicator | dateRunsFrom |
      | <trainUid> | P            | 2020-01-01   |
    And the schedule is received from LINX
    And I wait until today's train '<trainUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID   | trainNumber        | scheduledStartDate | locationPrimaryCode   | locationSubsidiaryCode   | messageType   |
      | <trainUid> | <trainDescription> | today              | <locationPrimaryCode> | <locationSubsidiaryCode> | <messageType> |
    And the following live berth step message is sent from LINX (to move train)
      | fromBerth   | toBerth   | trainDescriber   | trainDescription   |
      | <fromBerth> | <toBerth> | <trainDescriber> | <trainDescription> |
    And I am on the timetable view for service '<trainUid>'
    Then the actual '<actualTimeType>' time displayed for that location '<location>' matches that provided in the TRI message
    Examples:
      | trainUid | trainDescription | trainDescriber | messageType            | actualTimeType | locationPrimaryCode | location           | locationSubsidiaryCode | fromBerth | toBerth | timestamp |
      | H51120   | 5X20             | D3             | Departure from Origin  | Departure      | 73000               | London Paddington  | PADTON                 | A009      | 0039    | 10:02:06  |
      | H51121   | 5X21             | D3             | Arrival at termination | Arrival        | 73216               | Old Oak Depot      | OLDOXRS                | 0101      | 0119    | 10:04:06  |
      | H51122   | 5X22             | D3             | Arrival at station     | Arrival        | 73108               | Royal Oak Junction | ROYAOJN                | A009      | 0039    | 10:06:06  |
      | H51123   | 5X23             | D3             | Departure from station | Departure      | 73108               | Royal Oak Junction | ROYAOJN                | 0039      | 0057    | 10:08:06  |
      | H51124   | 5X24             | D3             | Passing Location       | Departure      | 73111               | Ladbroke Grove     | LDBRKJ                 | 0081      | 0105    | 10:10:06  |
