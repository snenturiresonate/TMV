Feature: 33805 TMV Schedule Matching
  As a TMV User
  I want updates to the planned schedule to be considered during schedule matching
  So that the system selects the most appropriate match

  Background:
    Given the access plan located in CIF file 'access-plan/33805-schedules/schedule-matching.cif' is received from LINX
    And I am on the home page
    And I restore to default train list config

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
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<origTrainDesc>' is visible on the trains list with schedule type 'STP'
    When the following change of ID TJM is received
      | trainUid   | newTrainNumber | oldTrainNumber  | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | <trainUid> | <newTrainDesc> | <origTrainDesc> | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    # @tdd:ref_60199  When I wait for the option to Unmatch train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    # @tdd:33606 And the rectangle colour for berth <trainDescriber><berth> is not lightgrey meaning 'no timetable'
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
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<origTrainDesc>' is visible on the trains list with schedule type 'STP'
    When the following change of ID TJM is received
      | trainUid   | newTrainNumber | oldTrainNumber  | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | <trainUid> | <newTrainDesc> | <origTrainDesc> | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And the following berth step message is sent from LINX (creating a match)
      | fromBerth | timestamp | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | 12:00:00  | <secondBerth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    # @tdd:ref_60199  When I wait for the option to Unmatch train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    # @tdd:33606 And the rectangle colour for berth <trainDescriber><berth> is not lightgrey meaning 'no timetable'
    And I see todays schedule for '<trainUid>' has loaded by looking at the timetable page

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | newTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 6003        | 1B11          | 4B70         | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | 1B11          | 5B70         | B11111   | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | 1B11          | 6B70         | B11111   | PRTOBJP  | 401         | sub-division |

  @bug @bug:58051
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
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<origTrainDesc>' is visible on the trains list with schedule type 'STP'
    When the following change of ID TJM is received
      | trainUid   | newTrainNumber | oldTrainNumber  | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | <trainUid> | <newTrainDesc> | <origTrainDesc> | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <newTrainDesc>   |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<newTrainDesc>' and is visible
    # @tdd:ref_60199  When I wait for the option to Unmatch train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <newTrainDesc>
    Then the Matched version of the map context menu is displayed
    # @tdd:33606 And the rectangle colour for berth <trainDescriber><berth> is not lightgrey meaning 'no timetable'
    And I see todays schedule for '<trainUid>' has loaded by looking at the timetable page

    Examples:
      | trainDescriber | berth | origTrainDesc | newTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 1B11          | 7B70         | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 1B11          | 8B70         | B11111   | PADTON   | 401         | location     |
      | D3             | 0106  | 1B11          | 9B70         | B11111   | PRTOBJP  | 401         | sub-division |

  @bug @bug:58051
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
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<origTrainDesc>' is visible on the trains list with schedule type 'STP'
    When the following change of ID TJM is received
      | trainUid   | newTrainNumber | oldTrainNumber  | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | <trainUid> | <newTrainDesc> | <origTrainDesc> | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And the following berth step message is sent from LINX (creating a match)
      | fromBerth | timestamp | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | 12:00:00  | <secondBerth> | <trainDescriber> | <newTrainDesc>   |
    And I am viewing the map HDGW01paddington.v
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<newTrainDesc>' and is visible
    # @tdd:ref_60199  When I wait for the option to Unmatch train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <newTrainDesc>
    Then the Matched version of the map context menu is displayed
    # @tdd:33606 And the rectangle colour for berth <trainDescriber><berth> is not lightgrey meaning 'no timetable'
    And I see todays schedule for '<trainUid>' has loaded by looking at the timetable page

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | newTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 6003        | 1B11          | 1B72         | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | 1B11          | 2B72         | B11111   | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | 1B11          | 3B72         | B11111   | PRTOBJP  | 401         | sub-division |

  @tdd @tdd:60684
  Scenario Outline: 3. Interpose - Check if the berth should be schedule matched - <berthType> berth
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
    Given I am viewing the map md09crosscity.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<trainDesc>' is visible on the trains list with schedule type 'STP'
    When the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <trainDesc>      |
    And I am viewing the map md09crosscity.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDesc>' and is visible
    # @tdd:ref_60199  When I wait for the option to <matchAction> train description <trainDesc> in berth <berth>, describer <trainDescriber> to be available
    When I wait for the <ttOption> timetable option for train description <trainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <trainDesc>
    Then the <matchedState> version of the map context menu is displayed
    # @tdd:33606 And the rectangle colour for berth <trainDescriber><berth> is not lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | trainDesc | trainUid | matchedState | matchAction | ttOption | berthType |
      | BN             | 0181  | 1B12      | B22222   | Matched      | Unmatch     | Open     | NORMAL    |
      | BN             | NCAP  | 1B12      | B22222   | Unmatched    | Match       | No       | EXCLUDE   |

  @tdd @tdd:60684
  Scenario Outline: 3. Step - Check if the berth should be schedule matched - <berthType> berth
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
    Given I am viewing the map md09crosscity.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<trainDesc>' is visible on the trains list with schedule type 'STP'
    When the following live berth interpose message is sent from LINX
      | toBerth     | trainDescriber   | trainDescription |
      | <fromBerth> | <trainDescriber> | <trainDesc>      |
    And the following berth step message is sent from LINX
      | fromBerth   | timestamp | toBerth | trainDescriber   | trainDescription |
      | <fromBerth> | 12:00:00  | <berth> | <trainDescriber> | <trainDesc>      |
    And I am viewing the map md09crosscity.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<trainDesc>' and is visible
    # @tdd:ref_60199  When I wait for the option to <matchAction> train description <trainDesc> in berth <berth>, describer <trainDescriber> to be available
    When I wait for the <ttOption> timetable option for train description <trainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <trainDesc>
    Then the <matchedState> version of the map context menu is displayed
    # @tdd:33606 And the rectangle colour for berth <trainDescriber><berth> is not lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | fromBerth | trainDesc | trainUid | matchedState | matchAction | ttOption | berthType |
      | BN             | 0181  | 0209      | 1B12      | B22222   | Matched      | Unmatch     | Open     | NORMAL    |
      | BN             | NCAP  | 0144      | 1B12      | B22222   | Unmatched    | Match       | No       | EXCLUDE   |

  @tdd @tdd:60684
  Scenario Outline: 4. Interpose - Cancelled schedules are not matched - <matchLevel> match
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
    And I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    Then train description '<origTrainDesc>' with schedule type 'STP' disappears from the trains list
    When the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the option to Match train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Unmatched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><berth> is lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 1B11          | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 1B11          | B11111   | PADTON   | 401         | location     |
      | D3             | 0106  | 1B11          | B11111   | PRTOBJP  | 401         | sub-division |

  @bug @bug_58519
  Scenario Outline: 4. Step - Cancelled schedules are not matched - <matchLevel> match
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
    And I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    Then train description '<origTrainDesc>' with schedule type 'STP' disappears from the trains list
    When the following berth step message is sent from LINX
      | fromBerth | timestamp | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | 12:00:00  | <secondBerth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the option to Match train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Unmatched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><berth> is lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 6003        | 1B11          | B11111   | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | 1B11          | B11111   | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | 1B11          | B11111   | PRTOBJP  | 401         | sub-division |

  @bug @bug:58384
  Scenario Outline: 5. Interpose - Exclude Terminated Schedules from Matching - <matchLevel> match
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
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<origTrainDesc>' is visible on the trains list with schedule type 'STP'
    When the following train running information message is sent from LINX
      | trainUID   | trainNumber     | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType          |
      | <trainUid> | <origTrainDesc> | today              | 73000               | PADTON                 | arrivalattermination |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the option to Match train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Unmatched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><berth> is lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | location | subdivision | matchLevel   | locationPrimaryCode |
      | D3             | A001  | 1B13          | A33333   | PADTON   | 401         | berth        | 73000               |
      | D3             | A011  | 1B13          | A33333   | PADTON   | 401         | location     | 73000               |
      | D3             | 0106  | 1B13          | A33333   | PRTOBJP  | 401         | sub-division | 73106               |

  @bug @bug:58384
  Scenario Outline: 5. Step - Exclude Terminated Schedules from Matching - <matchLevel> match
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
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<origTrainDesc>' is visible on the trains list with schedule type 'STP'
    When the following train running information message are sent from LINX
      | trainUID   | trainNumber     | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType          |
      | <trainUid> | <origTrainDesc> | today              | 73000               | PADTON                 | arrivalattermination |
    And the following berth step message is sent from LINX (creating a match)
      | fromBerth | timestamp | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | 12:00:00  | <secondBerth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the option to Match train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Unmatched version of the map context menu is displayed
    And the rectangle colour for berth <trainDescriber><berth> is lightgrey meaning 'no timetable'

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | trainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 6003        | 1B13          | B33333   | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | 1B13          | B33333   | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | 1B13          | B33333   | PRTOBJP  | 401         | sub-division |

  @bug @bug:60104
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
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<origTrainDesc>' is visible on the trains list with schedule type 'STP'
    When the following train activation message is sent from LINX
      | trainUID   | trainNumber     | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid> | <origTrainDesc> | 12:00                  | 73000               | PADTON                 |
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    # @tdd:ref_60199  When I wait for the option to Unmatch train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    When I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Then the timetable header train UID is '<trainUid>'

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | secondTrainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 1B11          | B11111   | C11111         | PADTON   | 401         | berth        |
      | D3             | A011  | 1B11          | B11111   | C11111         | PADTON   | 401         | location     |
      | D3             | 0106  | 1B11          | B11111   | C11111         | PRTOBJP  | 401         | sub-division |

  @bug @bug:60104
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
    Given I am viewing the map HDGW01paddington.v
    And I have cleared out all headcodes
    And I am on the trains list page
    And train description '<origTrainDesc>' is visible on the trains list with schedule type 'STP'
    When the following train activation message is sent from LINX
      | trainUID   | trainNumber     | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | <trainUid> | <origTrainDesc> | 12:00                  | 73000               | PADTON                 |
    And the following berth step message is sent from LINX (creating a match)
      | fromBerth | timestamp | toBerth       | trainDescriber   | trainDescription |
      | <berth>   | 12:00:00  | <secondBerth> | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<secondBerth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    # @tdd:ref_60199  When I wait for the option to Unmatch train description <origTrainDesc> in berth <secondBerth>, describer <trainDescriber> to be available
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    When I open timetable from the map context menu
    And I switch to the new tab
    And the tab title is 'TMV Timetable'
    Then the timetable header train UID is '<trainUid>'

    Examples:
      | trainDescriber | berth | secondBerth | origTrainDesc | trainUid | secondTrainUid | location | subdivision | matchLevel   |
      | D3             | A001  | 6003        | 1B11          | B11111   | C11111         | PADTON   | 401         | berth        |
      | D3             | A011  | 0041        | 1B11          | B11111   | C11111         | PADTON   | 401         | location     |
      | D3             | 0107  | 0125        | 1B11          | B11111   | C11111         | PRTOBJP  | 401         | sub-division |
