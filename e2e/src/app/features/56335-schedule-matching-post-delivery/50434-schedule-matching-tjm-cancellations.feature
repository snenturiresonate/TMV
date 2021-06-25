@bug @bug:64399
Feature: 56335 - Schedule Matching - TJM Cancellations
  As TMV user
  I want  schedules that cancelled at origin or scheduled location to be lower in preference over those that aren't
  So that the risk of an incorrect match is reduced

  Background:
    * I am viewing the map HDGW01paddington.v
    * I have cleared out all headcodes
    * The admin setting defaults are as originally shipped

  Scenario Outline: 50434-1 Schedule match without TJM Cancellation - baseline
    # Given a TD update with the type interpose has been received
    # And the berth included matches a single schedule
    # And the user is viewing the map that contains that berth
    # When the user opens the context menu for the train description
    # Then the matched version of the context menu is displayed
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And I am on the trains list page
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A007  | 3B41          | B54341   | PADTON   | 401         | berth        |

  # A/C 2a
  @bug @bug:63216
  Scenario Outline: 50434-2 Not schedule matched if TJM cancel at origin for today is received
    # Given a schedule has been received for a service
    # And a TJM cancellation at origin is received
    # When a TD update with the type interpose has been received
    # And the berth included matches a single schedule
    # And the user is viewing the map that contains that berth
    # And the user opens the context menu for the train description
    # Then the unmatched version of the context menu is displayed
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And I delete '<trainDescriber>:<berth>' from hash '{schedule-matching}-matched-schedules'
    And I am on the trains list page
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour | asm |
      | <trainUid> | <origTrainDesc>    | now                    | 73000               | PADTON                 | today         | now                 | 1   |
    And I give the train activation 1 second to load
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason   | nationalDelayCode   |
      | <trainUid> | <origTrainDesc>    | now           | create | <type>    | <type>          | 99999       | PADTON         | now  | <modificationReason> | <nationalDelayCode> |
    And I give the TJM 1 second to load
    And I am on the timetable view for service '<trainUid>'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the following live berth interpose message is sent from LINX (will not be matched, as cancelled)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Unmatched version of the map context menu is displayed

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | type | modificationReason | nationalDelayCode | significance |
      | D3             | 0105  | 3B42          | B54342   | 91   | 12                 | PD                | after origin |
      | D3             | A007  | 3B21          | B54321   | 91   | 12                 | PD                | at origin    |

  # A/C 2b
  Scenario Outline: 50434-2 Not schedule matched if TJM cancel at origin for today and tomorrow's schedules is received
    # Given a schedule has been received for a service
    # And a TJM cancellation at origin is received
    # When a TD update with the type interpose has been received
    # And the berth included matches a single schedule
    # And the user is viewing the map that contains that berth
    # And the user opens the context menu for the train description
    # Then the unmatched version of the context menu is displayed
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And I delete '<trainDescriber>:<berth>' from hash '{schedule-matching}-matched-schedules'
    And I am on the trains list page
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour | asm |
      | <trainUid> | <origTrainDesc>    | now                    | 73000               | PADTON                 | today         | now                 | 1   |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour | asm |
      | <trainUid> | <origTrainDesc>    | now                    | 73000               | PADTON                 | tomorrow      | now                 | 1   |
    And I give the train activations 1 second to load
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason   | nationalDelayCode   | runDate |
      | <trainUid> | <origTrainDesc>    | now           | create | <type>    | <type>          | 99999       | PADTON         | now  | <modificationReason> | <nationalDelayCode> | today   |
    And the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason   | nationalDelayCode   | runDate  |
      | <trainUid> | <origTrainDesc>    | now           | create | <type>    | <type>          | 99999       | PADTON         | now      | <modificationReason> | <nationalDelayCode> | tomorrow |
    And I give the TJMs 1 second to load
    And I am on the timetable view for service '<trainUid>'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the following live berth interpose message is sent from LINX (will not be matched, as cancelled)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    And I invoke the context menu on the map for train <origTrainDesc>
#    @tdd @tdd:60684
#    Then the Unmatched version of the map context menu is displayed

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | type | modificationReason | nationalDelayCode | significance |
      | D3             | 0105  | 3B42          | B54342   | 91   | 12                 | PD                | after origin |
      | D3             | A007  | 3B21          | B54321   | 91   | 12                 | PD                | at origin    |

  # A/C 3a
  Scenario Outline: 50434-4 Non-cancelled schedule is matched if TJM cancel at origin is received for one of two services
    # Given a schedule that starts at PADTON has been received for service B54344, 3B44
    # And a second different schedule that starts at PADTON has been received for service B54345, 3B44
    # And a TJM cancellation at origin is received for service A
    # When a TD update with the type interpose has been received
    # And the berth included could match service A or service B
    # And the user is viewing the map that contains that berth
    # And the user views the timetable for the matched service
    # Then service B has been matched
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid   |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <secondTrainUid> |
    And I am on the trains list page
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And train '<origTrainDesc>' with schedule id '<secondTrainUid>' for today is visible on the trains list
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour | asm |
      | <trainUid> | <origTrainDesc>    | now                    | 73000               | PADTON                 | today         | now                 | 1   |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour | asm |
      | <trainUid> | <origTrainDesc>    | now                    | 73000               | PADTON                 | tomorrow      | now                 | 1   |
    And I give the train activations 1 second to load
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason   | nationalDelayCode   | runDate |
      | <trainUid> | <origTrainDesc>    | now           | create | <type>    | <type>          | 99999       | PADTON         | now  | <modificationReason> | <nationalDelayCode> | today   |
    And the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason   | nationalDelayCode   | runDate |
      | <trainUid> | <origTrainDesc>    | now           | create | <type>    | <type>          | 99999       | PADTON         | now  | <modificationReason> | <nationalDelayCode> | tomorrow|
    And I give the TJMs 1 second to load
    And I am on the timetable view for service '<trainUid>'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the following live berth interpose message is sent from LINX (will be matched to the second service)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    When I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Then the timetable header train UID is '<secondTrainUid>'

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | type | modificationReason | nationalDelayCode | secondTrainUid |
      | D3             | 0105  | 3B43          | B54351   | 91   | 12                 | PD                | B54352         |

  # A/C 3b
  Scenario Outline: 50434-4 Non-cancelled schedule is matched if TJM cancel at location is received for one of two services
    # Given a schedule that starts at PADTON has been received for service B54346, 3B46
    # And a second different schedule that starts at PADTON has been received for service B54347, 3B46
    # And a TJM cancellation at a location is received for service A
    # When a TD update with the type interpose has been received
    # And the berth included could match service A or service B
    # And the user is viewing the map that contains that berth
    # And the user views the timetable for the matched service
    # Then service B has been matched
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid   |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <secondTrainUid> |
    And I am on the trains list page
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And train '<origTrainDesc>' with schedule id '<secondTrainUid>' for today is visible on the trains list
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour | asm |
      | <trainUid> | <origTrainDesc>    | now                    | 73000               | PADTON                 | today         | now                 | 1   |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour | asm |
      | <trainUid> | <origTrainDesc>    | now                    | 73000               | PADTON                 | tomorrow      | now                 | 1   |
    And the following train activation message is sent from LINX
      | trainUID         | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour | asm |
      | <secondTrainUid> | <origTrainDesc>    | now                    | 73000               | PADTON                 | today         | now                 | 1   |
    And I give the train activations 1 second to load
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode      | time | modificationReason   | nationalDelayCode   | runDate |
      | <trainUid> | <origTrainDesc>    | now           | create | <type>    | <type>          | 99999       | <cancelledLocation> | now  | <modificationReason> | <nationalDelayCode> | today   |
    And the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode      | time | modificationReason   | nationalDelayCode   | runDate |
      | <trainUid> | <origTrainDesc>    | now           | create | <type>    | <type>          | 99999       | <cancelledLocation> | now  | <modificationReason> | <nationalDelayCode> | tomorrow|
    And I give the TJMs 1 second to load
    And I am on the timetable view for service '<trainUid>'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the following live berth interpose message is sent from LINX (will be matched to the second service)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    When I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Then the timetable header train UID is '<secondTrainUid>'

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | cancelledLocation | type | modificationReason | nationalDelayCode | secondTrainUid |
      | D3             | 0105  | 3B44          | B54344   | ROYAOJN           | 92   | 19                 | OZ                | B54345         |

  # A/C 6
  Scenario Outline: 50434-4 Cancellation at location has no effect if location is not in the schedule
    # Given a schedule that starts at PADTON has been received for service B54361, 3B61
    # And a TJM cancellation at a non existent location is received for service A
    # When a TD update with the type interpose has been received
    # And the berth included matches service A
    # And the user is viewing the map that contains that berth
    # And the user views the timetable for the matched service
    # Then service A has been matched
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And I am on the trains list page
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode      | time | modificationReason   | nationalDelayCode   |
      | <trainUid> | <origTrainDesc>    | now           | create | <type>    | <type>          | 99999       | <cancelledLocation> | now  | <modificationReason> | <nationalDelayCode> |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    When I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Then the timetable header train UID is '<trainUid>'

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | cancelledLocation | type | modificationReason | nationalDelayCode |
      | D3             | 0105  | 3B61          | B54361   | NONEXIS           | 92   | 19                 | OZ                |

  # A/C 7
  Scenario Outline: 50434-4 Cancellation at location has no effect if schedule does not exist
    # Given a TJM cancellation at a location is received for service A
    # When a TD update with the type interpose has been received
    # And the user is viewing the map that contains that berth
    # Then service A has not been matched
    Given the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode      | time | modificationReason   | nationalDelayCode   |
      | <trainUid> | <origTrainDesc>    | now           | create | <type>    | <type>          | 99999       | <cancelledLocation> | now  | <modificationReason> | <nationalDelayCode> |
    And the following live berth interpose message is sent from LINX (not creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
#    @tdd @tdd:60684
#    When I invoke the context menu on the map for train <origTrainDesc>
#    Then the Unmatched version of the map context menu is displayed

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | cancelledLocation | type | modificationReason | nationalDelayCode |
      | D3             | 0105  | 3B71          | B54371   | ROYAOJN           | 92   | 19                 | OZ                |

  # A/C 9
  Scenario Outline: 50434-6 TJM Cancellation at location has no impact upon consistent stepping
    # Given a schedule has been received for a service
    # When a TD update with the type interpose has been received
    # Then the service is schedule matched
    # When a TJM cancellation at location is received
    # And a TD update with the type step has been received
    # Then the service is schedule matched
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And I am on the trains list page
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode      | time | modificationReason   | nationalDelayCode   |
      | <trainUid> | <origTrainDesc>    | now           | create | <type>    | <type>          | 99999       | <cancelledLocation> | now  | <modificationReason> | <nationalDelayCode> |
    And I am on the timetable view for service '<trainUid>'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    When the following berth step message is sent from LINX (creating a consistent step)
      | timestamp | fromBerth   | toBerth   | trainDescriber     | trainDescription |
      | 12:00:00  | <berth>     | <toBerth> | <trainDescriber>   | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<toBerth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <toBerth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | cancelledLocation | type | modificationReason | nationalDelayCode | toBerth |
      | D3             | 0057  | 3B47          | B54347   | ROYAOJN           | 92   | 19                 | OZ                | 0081    |
