Feature: 33805 TMV Schedule Matching
  As a TMV User
  I want updates to the planned schedule to be considered during schedule matching
  So that the system selects the most appropriate match

  Background:
    * I have cleared out all headcodes
    * I reset redis
    * I remove today's train 'B11111' from the Redis trainlist
    * I remove today's train 'C11111' from the Redis trainlist
    * I remove today's train 'B22222' from the Redis trainlist
    * I remove today's train 'B33333' from the Redis trainlist
    * the access plan located in CIF file 'access-plan/33805-schedules/schedule-matching.cif' is received from LINX
    * I wait until today's train 'B11111' has loaded
    * I wait until today's train 'C11111' has loaded
    * I wait until today's train 'B22222' has loaded
    * I wait until today's train 'B33333' has loaded
    * I am on the home page
    * I restore to default train list config '1'
    * I am on the trains list page 1
    * I have navigated to the 'Train Class & MISC' configuration tab
    * I set 'Include unmatched' to be 'on'
    * I save the trains list config

  Scenario Outline: 1. Interpose - Match old ID after Change of ID - <matchLevel> match
    #    Given there is a valid schedule
    #    And a TJM has been received with the type 07 (change of ID) for that schedule
    #    And a TD update with the type interpose has been received for the old train description
    #    And the berth included  matches the schedule at <match level>
    #    When a user views a map containing the same berth
    #    Then train description from the TD message is displayed in the berth and unexpectedColour reflects punctuality (not no timetable unexpectedColour)
    #    And the timetable contains the Train UID from the schedule
    #
    #    | Match level |
    #    | berth |
    #    | location |
    #    | sub division |
    Given the following change of ID TJM is received
      | trainUid   | newTrainNumber | oldTrainNumber  | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | <trainUid> | <newTrainDesc> | <origTrainDesc> | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><berth> is not lightgrey meaning 'no timetable'
    And I see todays schedule for '<trainUid>' has loaded by looking at the timetable page

    Examples:
      | trainDescriber | berth | origTrainDesc | newTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 1B11          | 1B70         | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 1B11          | 2B70         | B11111   | PADTON   | 401         | location     |
      | D3             | 0106  | 1B11          | 3B70         | B11111   | PRTOBJP  | 401         | sub-division |

  Scenario Outline: 1. Step - Match old ID after Change of ID - <matchLevel> match
    #    Given there is a valid schedule
    #    And a TJM has been received with the type 07 (change of ID) for that schedule
    #    And a TD update with the type Step has been received for the old train description
    #    And the berth included  matches the schedule at <match level>
    #    When a user views a map containing the same berth
    #    Then train description from the TD message is displayed in the berth and unexpectedColour reflects punctuality (not no timetable unexpectedColour)
    #    And the timetable contains the Train UID from the schedule
    #
    #    | Match level |
    #    | berth |
    #    | location |
    #    | sub division |
    Given the following change of ID TJM is received
      | trainUid   | newTrainNumber | oldTrainNumber  | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | <trainUid> | <newTrainDesc> | <origTrainDesc> | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | <secondBerth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    And I see todays schedule for '<trainUid>' has loaded by looking at the timetable page

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | newTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 6003        | 1B11          | 4B70         | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | 1B11          | 5B70         | B11111   | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | 1B11          | 6B70         | B11111   | PRTOBJP  | 401         | sub-division |

  Scenario Outline: 2. Interpose - Match new ID after Change of ID - <matchLevel> match
    #    Given there is a valid schedule
    #    And a TJM has been received with the type 07 (change of ID) for that schedule
    #    And a TD update with the type interpose has been received for the old train description
    #    And the berth included  matches the schedule at <match level>
    #    When a user views a map containing the same berth
    #    Then train description from the TD message is displayed in the berth and unexpectedColour reflects punctuality (not no timetable unexpectedColour)
    #    And the timetable contains the Train UID from the schedule
    #
    #    | Match level |
    #    | berth |
    #    | location |
    #    | sub division |
    Given the following change of ID TJM is received
      | trainUid   | newTrainNumber | oldTrainNumber  | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | <trainUid> | <newTrainDesc> | <origTrainDesc> | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <newTrainDesc>   |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<newTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <newTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <newTrainDesc>
    Then the Matched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><berth> is not lightgrey meaning 'no timetable'
    And I see todays schedule for '<trainUid>' has loaded by looking at the timetable page

    Examples:
      | trainDescriber | berth | origTrainDesc | newTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 1B11          | 7B70         | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 1B11          | 8B70         | B11111   | PADTON   | 401         | location     |
      | D3             | 0106  | 1B11          | 9B70         | B11111   | PRTOBJP  | 401         | sub-division |

  Scenario Outline: 2. Step - Match new ID after Change of ID - <matchLevel> match
    #    Given there is a valid schedule
    #    And a TJM has been received with the type 07 (change of ID) for that schedule
    #    And a TD update with the type Step has been received for the old train description
    #    And the berth included  matches the schedule at <match level>
    #    When a user views a map containing the same berth
    #    Then train description from the TD message is displayed in the berth and unexpectedColour reflects punctuality (not no timetable unexpectedColour)
    #    And the timetable contains the Train UID from the schedule
    #
    #    | Match level |
    #    | berth |
    #    | location |
    #    | sub division |
    Given the following change of ID TJM is received
      | trainUid   | newTrainNumber | oldTrainNumber  | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | <trainUid> | <newTrainDesc> | <origTrainDesc> | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | <secondBerth> | <trainDescriber> | <newTrainDesc>   |
    And I am viewing the map HDGW01paddington.v
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<newTrainDesc>' and is visible
    # When I wait for the Open timetable option for train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <newTrainDesc>
    Then the Matched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><secondBerth> is not lightgrey meaning 'no timetable'
    And I see todays schedule for '<trainUid>' has loaded by looking at the timetable page

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | newTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 6003        | 1B11          | 1B72         | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | 1B11          | 2B72         | B11111   | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | 1B11          | 3B72         | B11111   | PRTOBJP  | 401         | sub-division |

  Scenario Outline: 3a. Interpose - Check if the berth should be schedule matched - <berthType> berth
      #      Given there is a valid schedule
      #      And a TD update with the type <Step Type> has been received for the same train description
      #      And the berth included  matches the schedule at berth
      #      And that berth is an 'Exclude' berth in the configuration data
      #      When a user views a map containing the same berth
      #      Then train description is displayed in the berth in a coloured box (no timetable unexpectedColour from admin for unmatched)
      #
      #        | Step Type |
      #        | Interpose |
      #        | Step |
    Given the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <trainDesc>      |
    And I am viewing the map md09crosscity.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDesc>' and is visible
    When I wait for the <ttOption> timetable option for train description <trainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><berth>'
    Then the Matched or Left behind Matched version of the map context menu <isMatched> displayed
    And the rectangle colour for berth <trainDescriber><berth> <isGrey> lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | trainDesc | trainUid | isGrey | isMatched | ttOption | berthType |
      | BN             | 0181  | 1B12      | B22222   | is not | is        | Open     | NORMAL    |
      | BN             | NCAP  | 1B12      | B22222   | is     | is not    | No       | EXCLUDE   |

  Scenario Outline: 3b. Step - Check if the berth should be schedule matched - <berthType> berth
      #      Given there is a valid schedule
      #      And a TD update with the type <Step Type> has been received for the same train description
      #      And the berth included  matches the schedule at berth
      #      And that berth is an 'Exclude' berth in the configuration data
      #      When a user views a map containing the same berth
      #      Then train description is displayed in the berth in a coloured box (no timetable unexpectedColour from admin for unmatched)
      #
      #        | Step Type |
      #        | Interpose |
      #        | Step |
    Given the following live berth interpose message is sent from LINX
      | toBerth     | trainDescriber   | trainDescription |
      | <fromBerth> | <trainDescriber> | <trainDesc>      |
    And the following live berth step message is sent from LINX
      | fromBerth   | toBerth | trainDescriber   | trainDescription |
      | <fromBerth> | <berth> | <trainDescriber> | <trainDesc>      |
    And I am viewing the map md09crosscity.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDesc>' and is visible
    When I wait for the <ttOption> timetable option for train description <trainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><berth>'
    Then the Matched or Left behind Matched version of the map context menu <isMatched> displayed
    And the rectangle colour for berth <trainDescriber><berth> <isGrey> lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | fromBerth | trainDesc | trainUid | isGrey | isMatched | ttOption | berthType |
      | BN             | 0181  | 0209      | 1B12      | B22222   | is not | is        | Open     | NORMAL    |
      | BN             | NCAP  | 0144      | 1B12      | B22222   | is     | is not    | No       | EXCLUDE   |

  Scenario Outline: 4a. Interpose - Cancelled schedules are not matched - <matchLevel> match
    #    Given there is a valid schedule has a STP indicator of Cancelled  (C or CV)
    #    And a TD update with the type <Step Type> has been received for the same train description
    #    And the berth included would match the schedule at <match level>
    #    When a user views a map containing the same berth
    #    Then train description is displayed in the berth in a coloured box (no timetable colour from admin for unmatched)
    #
    #      | Match level |
    #      | berth |
    #      | location |
    #      | sub division |
    Given the access plan located in CIF file 'access-plan/33805-schedules/schedule-matching-cancelled.cif' is received from LINX
    And I wait until today's train '<trainUid>' has been removed
    And I give the cancellation an extra 2 seconds to be processed
    When the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the option to Match train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><berth>'
    Then the Unmatched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><berth> is lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 1B11          | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 1B11          | B11111   | PADTON   | 401         | location     |
      | D3             | 0106  | 1B11          | B11111   | PRTOBJP  | 401         | sub-division |

  Scenario Outline: 4b. Step - Cancelled schedules are not matched - <matchLevel> match
    #    Given there is a valid schedule has a STP indicator of Cancelled  (C or CV)
    #    And a TD update with the type <Step Type> has been received for the same train description
    #    And the berth included would match the schedule at <match level>
    #    When a user views a map containing the same berth
    #    Then train description is displayed in the berth in a coloured box (no timetable colour from admin for unmatched)
    #
    #      | Match level |
    #      | berth |
    #      | location |
    #      | sub division |
    Given the access plan located in CIF file 'access-plan/33805-schedules/schedule-matching-cancelled.cif' is received from LINX
    And I wait until today's train '<trainUid>' has been removed
    And I give the cancellation an extra 2 seconds to be processed
    And I am on the trains list page 1
    Then train description '<origTrainDesc>' with schedule type 'STP' disappears from the trains list
    When the following live berth step message is sent from LINX
      | fromBerth | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | <secondBerth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the option to Match train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    And I right click on berth with id '<trainDescriber><berth>'
    Then the Unmatched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><berth> is lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 6003        | 1B11          | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | 1B11          | B11111   | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | 1B11          | B11111   | PRTOBJP  | 401         | sub-division |

  @manual
  Scenario Outline: 5a. Interpose - Exclude Terminated Schedules from Matching - <matchLevel> match
    #    Given there a valid schedule
    #    And a Train Running Information message has been received with  the type  01 -Arrival at Termination
    #    And a TD update with the type <Step Type> has been received for the same train description
    #    And the berth included  would match the schedule at <match level>
    #    When a user views a map containing the same berth
    #    Then train description is displayed in the berth in a coloured box (no timetable colour from admin for unmatched)
    #
    #      | Match level |
    #      | berth |
    #      | location |
    #      | sub division |
    Given I wait until today's train '<trainUid>' has loaded
    When the following train running information message is sent from LINX
      | trainUID   | trainNumber     | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType          |
      | <trainUid> | <origTrainDesc> | today              | 73000               | PADTON                 | arrivalattermination |
    And I give the terminated schedule timeout 900 seconds to load
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    And I right click on berth with id '<trainDescriber><berth>'
    Then the Unmatched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><berth> is lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | location | subdivision | matchLevel   | locationPrimaryCode |
      | D3             | A001  | 1B13          | B33333   | PADTON   | 401         | berth        | 73000               |
      | D3             | A011  | 1B13          | B33333   | PADTON   | 401         | location     | 73000               |
      | D3             | 0106  | 1B13          | B33333   | PRTOBJP  | 401         | sub-division | 73106               |

  @manual
  Scenario Outline: 5b. Step - Exclude Terminated Schedules from Matching - <matchLevel> match
    #    Given there a valid schedule
    #    And a Train Running Information message has been received with  the type  01 -Arrival at Termination
    #    And a TD update with the type <Step Type> has been received for the same train description
    #    And the berth included  would match the schedule at <match level>
    #    When a user views a map containing the same berth
    #    Then train description is displayed in the berth in a coloured box (no timetable colour from admin for unmatched)
    #
    #      | Match level |
    #      | berth |
    #      | location |
    #      | sub division |
    Given I wait until today's train '<trainUid>' has loaded
    When the following train running information message are sent from LINX
      | trainUID   | trainNumber     | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType          |
      | <trainUid> | <origTrainDesc> | today              | 73000               | PADTON                 | arrivalattermination |
    And I give the terminated schedule timeout 900 seconds to load
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | <secondBerth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    And I right click on berth with id '<trainDescriber><secondBerth>'
    Then the Unmatched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><secondBerth> is lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 6003        | 1B13          | B33333   | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | 1B13          | B33333   | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | 1B13          | B33333   | PRTOBJP  | 401         | sub-division |

  Scenario Outline: 6. Interpose - activated schedules take precedence - <matchLevel> match
    #    Given there two valid schedule
    #    And a Train Activation message has been received for 1 schedule
    #    And a TD update with the type <Step Type> has been received for the train description in the two schedules
    #    And the berth included  matches both schedule at <match level>
    #    When a user views a map containing the same berth
    #    Then train description is displayed in the berth and colour reflects punctuality (not no timetable colour)
    #    And the timetable contains the Train UID from the activated schedule
    #      | Match level |
    #      | berth |
    #      | location |
    #      | sub division |
    * I generate a new trainUID
    * I generate a new train description
    * I remove today's train '<trainUid>' from the Redis trainlist
    Given I delete '<trainUid>:today' from hash 'schedule-modifications'
    And the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I give the CIF an extra 2 seconds to be processed
    When the following train activation message is sent from LINX
      | trainUID   | trainNumber     | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <origTrainDesc> | now                    | 73000               | PADTON                 | today         | now                 |
    And I give the activation an extra 2 seconds to be processed
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am on the trains list page 1
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    When I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is '<origTrainDesc> TMV Timetable'
    Then the timetable header train UID is '<trainUid>'
    # clean up
    * I remove schedule '<trainUid>' from the trains list

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid  | location | subdivision | matchLevel   |
      | D3             | A001  | generated     | generated | PADTON   | 401         | berth        |
      | D3             | A011  | generated     | generated | PADTON   | 401         | location     |
      | D3             | 0106  | generated     | generated | PRTOBJP  | 401         | sub-division |

  Scenario Outline: 6. Step - activated schedules take precedence - <matchLevel> match
    #    Given there two valid schedule
    #    And a Train Activation message has been received for 1 schedule
    #    And a TD update with the type <Step Type> has been received for the train description in the two schedules
    #    And the berth included  matches both schedule at <match level>
    #    When a user views a map containing the same berth
    #    Then train description is displayed in the berth and colour reflects punctuality (not no timetable colour)
    #    And the timetable contains the Train UID from the activated schedule
    #      | Match level |
    #      | berth |
    #      | location |
    #      | sub division |
    * I generate a new trainUID
    * I generate a new train description
    * I remove today's train '<trainUid>' from the Redis trainlist
    Given I delete '<trainUid>:today' from hash 'schedule-modifications'
    And the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And I give the CIF an extra 2 seconds to be processed
    When the following train activation message is sent from LINX
      | trainUID   | trainNumber     | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <origTrainDesc> | now                    | 73000               | PADTON                 | today         | now                 |
    And I give the activation an extra 2 seconds to be processed
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | <secondBerth> | <trainDescriber> | <origTrainDesc>  |
    And I am on the trains list page 1
    And The trains list table is visible
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And I am viewing the map HDGW01paddington.v
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    When I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is '<origTrainDesc> TMV Timetable'
    Then the timetable header train UID is '<trainUid>'
    # clean up
    * I remove schedule '<trainUid>' from the trains list

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | trainUid  | location | subdivision | matchLevel   |
      | D3             | A007  | 0039        | generated     | generated | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | generated     | generated | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | generated     | generated | PRTOBJP  | 401         | sub-division |
