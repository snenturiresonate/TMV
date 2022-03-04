Feature: TMV Process LINX Train Modification (S013 & S015)

  As a TMV User
  I want the system process LINX train stepping messages
  So that I can view the train stepping on the schematic

  Background:
    * I remove all trains from the trains list
    * I am on the home page
    * I restore to default train list config '1'

  Scenario: 40490-1 Single Change of ID received
    * I remove today's train 'H41101' from the trainlist
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41101   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X01             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I wait until today's train 'H41101' has loaded
    When the following change of ID TJM is received
      | trainUid | newTrainNumber | oldTrainNumber | departureHour | status | indicator | statusIndicator | primaryCode | time     |
      | H41101   | 1X99           | 1X01           | 12            | create | 07        | 07              | 99999       | 12:00:00 |
    And I am on the timetable view for service 'H41101'
    And I switch to the timetable details tab
    Then the timetable header train description is '1X99 (1X01)'
    And the sent TJMs are in the modifications table
    And the last TJM is correct

  Scenario Outline: 40490-2a Single Cancellation at Origin or Cancellation at location received
    * I remove today's train '<trainUid>' from the trainlist
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I wait until today's train '<trainUid>' has loaded
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason   | nationalDelayCode   |
      | <trainUid> | <trainDescription> | 12            | create | <type>    | <type>          | 99999       | PADTON         | 12:00:00 | <modificationReason> | <nationalDelayCode> |
    And I am on the timetable view for service '<trainUid>'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the last TJM is correct

    Examples:
      | trainUid | trainDescription | type | modificationReason | nationalDelayCode |
      | H41102   | 1X02             | 91   | 12                 | PD                |
      | H41122   | 1X03             | 92   | 19                 | OZ                |

  Scenario Outline: 40490-2a2 Activated service is cancelled
    * I am on the trains list page 1
    * I save the following config changes
      | tab                | dataItem   | type | parameter         | newSetting | notes                    |
      | Train Indication   | Indicator8 | edit | colour            | #ffffff    | Origin Departure Overdue |
      | Train Indication   | Indicator3 | edit | colour            | #eba1a1    | Cancellation             |
      | Train Indication   | Indicator4 | edit | colour            | #edaaed    | Reinstatement            |
    * I generate a new trainUID
    * I generate a new train description
    * I remove today's train '<trainUid>' from the trainlist
    Given I delete '<trainUid>:today' from hash 'schedule-modifications'
    And the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I wait until today's train '<trainUid>' has loaded
    And the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber | trainDescription   |
      | A001    | D3             | <trainDescription> |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 73000               | PADTON                 | today         | now                 |
    And I give the Train Activation 5 seconds to fully process
    And I am on the trains list page 1
    And The trains list table is visible
    And the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              |
      | Origin called | <trainUid> | rgba(255, 181, 120, 1) |
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason   | nationalDelayCode   |
      | <trainUid> | <trainDescription> | now           | create | <type>    | <type>          | 99999       | PADTON         | now  | <modificationReason> | <nationalDelayCode> |
    And I give the TJMs 2 seconds to load
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType       | trainUID   | rowColour              | meaning   |
      | Origin called | <trainUid> | rgba(238, 187, 170, 1) | cancelled |

    Examples:
      | trainUid  | trainDescription | type | modificationReason | nationalDelayCode |
      | generated | generated        | 92   | 19                 | OZ                |

  Scenario: 40490-2b Single Change of Origin at location received
    * I remove today's train 'H41104' from the trainlist
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41104   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X04             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I wait until today's train 'H41104' has loaded
    When the following TJM is received
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | H41104   | 1X04        | 12            | create | 94        | 94              | 99999       | OLDOXRS        | 12:00:00 | 82                 | VA                |
    And I am on the timetable view for service 'H41104'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the last TJM is correct

  Scenario Outline: 40490-3 Cancellation received followed by reinstatement at the same location
    * I remove today's train '<trainUid>' from the trainlist
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I wait until today's train '<trainUid>' has loaded
    When the following TJMs are received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason   | nationalDelayCode   |
      | <trainUid> | <trainDescription> | 12            | create | <type>    | <type>          | 99999       | PADTON         | 12:00:00 | <modificationReason> | <nationalDelayCode> |
      | <trainUid> | <trainDescription> | 12            | create | 96        | 96              | 99999       | PADTON         | 12:01:00 | <modificationReason> | <nationalDelayCode> |
    And I am on the timetable view for service '<trainUid>'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the last TJM is correct

    Examples:
      | trainUid | trainDescription | type | modificationReason | nationalDelayCode |
      | H41105   | 1X05             | 91   | 12                 | PD                |
      | H41106   | 1X06             | 92   | 19                 | OZ                |


  Scenario: 40490-4 Multiple changes of Origin
    * I remove today's train 'H41107' from the trainlist
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41107   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X07             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I wait until today's train 'H41107' has loaded
    And the following TJM is received
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | H41107   | 1X07        | 12            | create | 94        | 94              | 99999       | ROYAOJN        | 12:00:00 | 82                 | VA                |
      | H41107   | 1X07        | 12            | create | 94        | 94              | 99999       | PRTOBJP        | 12:00:01 | 82                 | VA                |
    When I am on the timetable view for service 'H41107'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the last TJM is correct

  Scenario: 40490-5 Multiple changes of ID
    #
    * I remove today's train 'H41108' from the trainlist
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41108   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X01             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I wait until today's train 'H41108' has loaded
    When the following change of ID TJM is received
      | trainUid | newTrainNumber | oldTrainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | H41108   | 1X99           | 1X01           | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
      | H41108   | 1X98           | 1X99           | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And I give the TJMs 1 second to load
    And I am on the timetable view for service 'H41108'
    And I switch to the timetable details tab
    Then the timetable header train description is '1X98 (1X01)'
    And the sent TJMs are in the modifications table
    And the last TJM is correct

  Scenario: 40490-6 Multiple out of order changes of Origin
    * I remove today's train 'H41109' from the trainlist
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41109   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X09             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I wait until today's train 'H41109' has loaded
    And the following TJM is received
      | trainUid | trainNumber | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | H41109   | 1X09        | 12            | 10:00:00         | create | 94        | 94              | 99999       | ROYAOJN        | 12:00:00 | 82                 | VA                |
      | H41109   | 1X09        | 12            | 09:59:00         | create | 94        | 94              | 99999       | PRTOBJP        | 12:00:00 | 82                 | VA                |
    When I am on the timetable view for service 'H41109'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the sent TJMs in the modifications table are in time order
    And the last TJM is the TJM with the latest time

  Scenario: 40490-7 Multiple out of order changes of ID
    * I remove today's train 'H41110' from the trainlist
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41110   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X01             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I wait until today's train 'H41110' has loaded
    When the following change of ID TJM is received
      | trainUid | newTrainNumber | oldTrainNumber | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | H41110   | 1X99           | 1X98           | 12            | 10:00:00         | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
      | H41110   | 1X98           | 1X01           | 12            | 09:59:00         | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And I am on the timetable view for service 'H41110'
    And I switch to the timetable details tab
    Then the timetable header train description is '1X99 (1X01)'
    And the sent TJMs are in the modifications table
    And the last TJM is the TJM with the latest time

  Scenario Outline: 40490-8 Out of order cancel/reinstate display in timetable
    * I remove today's train '<trainUid>' from the trainlist
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I wait until today's train '<trainUid>' has loaded
    When the following TJMs are received
      | trainUid   | trainNumber        | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason   | nationalDelayCode   |
      | <trainUid> | <trainDescription> | 12            | 10:00:00         | create | <type>    | <type>          | 99999       | PADTON         | 12:00:00 | <modificationReason> | <nationalDelayCode> |
      | <trainUid> | <trainDescription> | 12            | 09:59:00         | create | 96        | 96              | 99999       | PADTON         | 12:01:00 | <modificationReason> | <nationalDelayCode> |
    And I am on the timetable view for service '<trainUid>'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the last TJM is the TJM with the latest time

    Examples:
      | trainUid | trainDescription | type | modificationReason | nationalDelayCode |
      | H41111   | 1X11             | 91   | 12                 | PD                |
      | H41112   | 1X12             | 92   | 19                 | OZ                |

  Scenario: 40490-9 Out of order cancel/reinstate display in trains list
    * I am on the trains list page 1
    * I save the following config changes
      | tab                | dataItem   | type | parameter         | newSetting | notes                    |
      | Train Indication   | Indicator8 | edit | colour            | #ffffff    | Origin Departure Overdue |
      | Train Indication   | Indicator3 | edit | colour            | #eba1a1    | Cancellation             |
      | Train Indication   | Indicator4 | edit | colour            | #edaaed    | Reinstatement            |
    * I remove today's train 'H41113' from the trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1X13                | H41113         |
    And I wait until today's train 'H41113' has loaded
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | H41113   | 1X13        | now                    | 99999               | PADTON                 | today         | now                 |
    And the following TJMs are received
      | trainUid | trainNumber | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode | meaning    |
      | H41113   | 1X13        | now           | 10:01:00         | create | 96        | 96              | 99999       | OLDOXRS        | now  | 82                 | VA                | reinstated |
      | H41113   | 1X13        | now           | 10:00:00         | create | 91        | 91              | 99999       | OLDOXRS        | now  | 82                 | VA                | cancelled  |
    And I give the TJMs 2 seconds to load
    And I am on the trains list page 1
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType       | trainUID | rowColour              | meaning    |
      | Origin called | H41113   | rgba(238, 221, 170, 1) | reinstated |

  Scenario: 40490-10 Invalid reinstate followed by cancellation display in trains list
    * I am on the trains list page 1
    * I save the following config changes
      | tab                | dataItem   | type | parameter         | newSetting | notes                    |
      | Train Indication   | Indicator8 | edit | colour            | #ffffff    | Origin Departure Overdue |
      | Train Indication   | Indicator3 | edit | colour            | #eba1a1    | Cancellation             |
      | Train Indication   | Indicator4 | edit | colour            | #edaaed    | Reinstatement            |
      | Train Class & MISC | other      | edit | Include Unmatched | off        |                          |
    * I remove today's train 'H41114' from the trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1X14                | H41114         |
    And I wait until today's train 'H41114' has loaded
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | H41114   | 1X14        | now                    | 99999               | PADTON                 | today         | now                 |
    And the following TJMs are received
      | trainUid | trainNumber | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode | meaning    |
      | H41114   | 1X14        | now           | 10:00:00         | create | 96        | 96              | 99999       | OLDOXRS        | now  | 82                 | VA                | reinstated |
      | H41114   | 1X14        | now           | 10:01:00         | create | 91        | 91              | 99999       | OLDOXRS        | now  | 82                 | VA                | cancelled  |
    When I am on the trains list page 1
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType       | trainUID | rowColour              | meaning   |
      | Origin called | H41114   | rgba(238, 187, 170, 1) | cancelled |
