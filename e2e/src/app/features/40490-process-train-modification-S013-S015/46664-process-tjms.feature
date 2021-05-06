Feature: TMV Process LINX Train Modification (S013 & S015)

  As a TMV User
  I want the system process LINX train stepping messages
  So that I can view the train stepping on the schematic

  @bug @bug:56878 @tdd @tdd:53405
  Scenario: 40490-1 Single Change of ID received
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41101   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X01             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    When the following change of ID TJM is received
      | trainUid | newTrainNumber | oldTrainNumber | departureHour | status | indicator | statusIndicator | primaryCode | time     |
      | H41101   | 1X99           | 1X01           | 12            | create | 07        | 07              | 99999       | 12:00:00 |
    And I am on the timetable view for service 'H41101'
    And I switch to the timetable details tab
    Then the headcode in the header row is '1X99 (1X01)'
    And the sent TJMs are in the modifications table
    And the last TJM is correct

  @bug @bug:56878 @tdd @tdd:53405
  Scenario Outline: 40490-2a Single Cancellation at Origin or Cancellation at location received
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
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
      | H41103   | 1X03             | 92   | 19                 | OZ                |

  @bug @bug:61409
  Scenario Outline: Activated service is cancelled
    Given I delete '<trainUid>:today' from hash 'schedule-modifications'
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif    | PADTON      | WTT_dep       | <trainDescription>  | <trainUid>     |
    And I am on the home page
    And I restore to default train list config
    And I am on the trains list page
    And train description '<trainDescription>' is visible on the trains list with schedule type 'LTP'
    And the following berth interpose message is sent from LINX
      | timestamp | toBerth | trainDescriber| trainDescription   |
      | 09:59:00  | A001    | D3            | <trainDescription> |
    And the following train activation message is sent from LINX
      | trainUID   | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <trainUid> | <trainDescription> | now                    | 73000               | PADTON                 | today         | now                 |
    And The trains list table is visible
    And the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColFill             |
      | Origin called             | <trainUid>    | rgba(255, 181, 120, 1) |
    When the following TJM is received
      | trainUid   | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason   | nationalDelayCode   |
      | <trainUid> | <trainDescription> | 12            | create | <type>    | <type>          | 99999       | PADTON         | 12:00:00 | <modificationReason> | <nationalDelayCode> |
    And The trains list table is visible
    Then the service is displayed in the trains list with the following indication
      | rowType                   | trainUID      | rowColFill             | trainDescriptionFill   |
      | Origin called             | <trainUid>    | rgba(255, 255, 255, 1) | rgba(0, 255, 0, 1)     |

    Examples:
      | trainUid | trainDescription | type | modificationReason | nationalDelayCode |
      | H41103   | 1X03             | 92   | 19                 | OZ                |

  @bug @bug:56878 @tdd @tdd:53405
  Scenario: 40490-2b Single Change of Origin at location received
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41104   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X04             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    When the following TJM is received
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | H41104   | 1X04        | 12            | create | 94        | 94              | 99999       | OLDOXRS        | 12:00:00 | 82                 | VA                |
    And I am on the timetable view for service 'H41104'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the last TJM is correct

  @bug @bug:56878 @tdd @tdd:53405
  Scenario Outline: 40490-3 Cancellation received followed by reinstatement at the same location
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
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

  @bug @bug:56878 @tdd @tdd:53405
  Scenario: 40490-4 Multiple changes of Origin
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41107   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X07             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And the following TJM is received
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | H41107   | 1X07        | 12            | create | 94        | 94              | 99999       | ROYAOJN        | 12:00:00 | 82                 | VA                |
      | H41107   | 1X07        | 12            | create | 94        | 94              | 99999       | PRTOBJP        | 12:00:01 | 82                 | VA                |
    When I am on the timetable view for service 'H41107'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the last TJM is correct

  @bug @bug:56878 @tdd @tdd:53405
  Scenario: 40490-5 Multiple changes of ID
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41108   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X01             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    When the following change of ID TJM is received
      | trainUid | newTrainNumber | oldTrainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | H41108   | 1X99           | 1X01           | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
      | H41108   | 1X98           | 1X99           | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And I am on the timetable view for service 'H41108'
    And I switch to the timetable details tab
    Then the headcode in the header row is '1X98 (1X01)'
    And the sent TJMs are in the modifications table
    And the last TJM is correct

  @bug @bug:56878 @tdd @tdd:53405
  Scenario: 40490-6 Multiple out of order changes of Origin
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41109   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X09             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And the following TJM is received
      | trainUid | trainNumber | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | H41109   | 1X09        | 12            | 10:00:00         | create | 94        | 94              | 99999       | ROYAOJN        | 12:00:00 | 82                 | VA                |
      | H41109   | 1X09        | 12            | 09:59:00         | create | 94        | 94              | 99999       | PRTOBJP        | 12:00:00 | 82                 | VA                |
    When I am on the timetable view for service 'H41109'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the sent TJMs in the modifications table are in time order
    And the last TJM is the TJM with the latest time

  @bug @bug:56878 @tdd @tdd:53405
  Scenario: 40490-7 Multiple out of order changes of ID
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41110   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X01             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    When the following change of ID TJM is received
      | trainUid | newTrainNumber | oldTrainNumber | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | H41110   | 1X99           | 1X98           | 12            | 10:00:00         | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
      | H41110   | 1X98           | 1X01           | 12            | 09:59:00         | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And I am on the timetable view for service 'H41110'
    And I switch to the timetable details tab
    Then the headcode in the header row is '1X99 (1X01)'
    And the sent TJMs are in the modifications table
    And the last TJM is the TJM with the latest time

  @bug @bug:56878 @tdd @tdd:53405
  Scenario Outline: 40490-8 Out of order cancel/reinstate display in timetable
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
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

  @bug @bug:56878 @tdd @tdd:53405
  Scenario: 40490-9 Out of order cancel/reinstate display in trains list
  #  Given a TJM with <TJM 1 type> has been received for a schedule followed by <TJM 2 type> with an earlier modification datetime
  #  And the trains list configuration has cancellation indication turned on
  #  And the trains list configuration has reinstatement indication turned on
  #  When a user view the trains list
  #  Then the train is highlighted as reinstated

   # Examples:
   #   | TJM 1 type |Type of Modification 1| Location1          | Time 1                          | TJM 2 type                      | Modification Reason 1          | Type of Modification 2| Location 2   | Time 2             |Modification Reason 2 |
   #   | 96         | Reinstatement        | Location from TJM1 | Modification datetime from TJM1 | Modification Reason from TJM 1 | 91                    | Cancellation | Location from TJM2 | Modification datetime from TJM2| Modification Reason from TJM 2|
   #   | 96         | Reinstatement        | Location from TJM1 | Modification datetime from TJM1 | Modification Reason from TJM 1 | 92                    | Cancellation | Location from TJM2 | Modification datetime from TJM2| Modification Reason from TJM2 |
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41113   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X13             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And the following TJM is received
      | trainUid | trainNumber | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | H41113   | 1X13        | 12            | 10:00:00         | create | 91        | 91              | 99999       | OLDOXRS        | 12:00:00 | 82                 | VA                |
      | H41113   | 1X13        | 12            | 10:01:00         | create | 96        | 96              | 99999       | OLDOXRS        | 12:01:00 | 82                 | VA                |
    And I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update the train list indication config settings as
      | name          | colour | minutes | toggleValue |
      | Cancellation  | #ff7   |         | on          |
      | Reinstatement | #dde   |         | on          |
    When I open 'trains list' page in a new tab
    And The trains list table is visible
    Then I should see the train list row coloured as
      | trainDescriberId | backgroundColour   |
      | 1X13             | rgb(221, 221, 238) |

  @bug @bug:56878 @tdd @tdd:53405
  Scenario: 40490-10 Invalid reinstate followed by cancellation display in trains list
    # Given a TJM with <TJM 1 type> has been received for a schedule followed by <TJM 2 type> with a later modification datetime
    # And the trains list configuration has cancellation indication turned on
    # And the trains list configuration has reinstatement indication turned on
    # When a user view the trains list
    # Then the train is highlighted as cancelled

    # Examples:
    #  | TJM 1 type |Type of Modification 1| Location1| Time 1| TJM 2 type |Modification Reason 1 | Type of Modification 2| Location 2| Time 2|Modification Reason 2 |
    #  | 96 | Reinstatement| Location from TJM1 | Modification datetime from TJM1| Modification Reason from TJM 1 | 91| Cancellation | Location from TJM2 | Modification datetime from TJM2| Modification Reason from TJM 2|
    #  | 96| Reinstatement | Location from TJM1| Modification datetime from TJM1| Modification Reason from TJM 1| 92| Cancellation | Location from TJM2 | Modification datetime from TJM2| Modification Reason from TJM2 |
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41114   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X14             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And the following TJM is received
      | trainUid | trainNumber | departureHour | modificationTime | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | H41114   | 1X14        | 12            | 10:00:00         | create | 96        | 96              | 99999       | OLDOXRS        | 12:00:00 | 82                 | VA                |
      | H41114   | 1X14        | 12            | 10:01:00         | create | 91        | 91              | 99999       | OLDOXRS        | 12:01:00 | 82                 | VA                |
    And I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update the train list indication config settings as
      | name          | colour | minutes | toggleValue |
      | Cancellation  | #dde   |         | on          |
      | Reinstatement | #ff7   |         | on          |
    When I open 'trains list' page in a new tab
    And The trains list table is visible
    Then I should see the train list row coloured as
      | trainDescriberId | backgroundColour   |
      | 1X14             | rgb(221, 221, 238) |
