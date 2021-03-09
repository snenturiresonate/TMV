Feature: TMV Process LINX Train Modification (S013 & S015)

  As a TMV User
  I want the system process LINX train stepping messages
  So that I can view the train stepping on the schematic

  @bug @bug:57008 @bug:56878 @tdd @tdd:53405
  Scenario: 40490-1 Single Change of ID received
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41101   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X01             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    When the following change of ID TJM is received
      | trainUid | newTrainNumber | oldTrainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     |
      | H41101   | 1X99           | 1X01           | 12            | create | 07        | 07              | 99999       | PADTON         | 12:00:00 |
    And I am on the timetable view for service 'H41101'
    And I switch to the timetable details tab
    Then the headcode in the header row is '1X99 (1X01)'
    And the sent TJMs are in the modifications table
    And the last TJM is correct

  @bug @bug:57008 @bug:56878 @tdd @tdd:53405
  Scenario Outline: 40490-2a Single Cancellation at Origin or Cancellation at location received
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I do nothing
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

  @bug @bug:57008 @bug:56878 @tdd @tdd:53405
  Scenario: 40490-2b Single Change of Origin at location received
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41104   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X04             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I do nothing
    When the following TJM is received
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | H41104   | 1X04        | 12            | create | 94        | 94              | 99999       | OLDOXRS        | 12:00:00 | 82                 | VA                |
    And I am on the timetable view for service 'H41104'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the last TJM is correct

  @bug @bug:57008 @bug:56878 @tdd @tdd:53405
  Scenario Outline: 40490-3 Cancellation received followed by reinstatement at the same location
    Given the following basic schedules are received from LINX
      | trainUid   | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription   | origin | departure | termination | arrival |
      | <trainUid> | N            | 2020-01-01   | 2030-01-01 | 1111111 | <trainDescription> | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I do nothing
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

  @bug @bug:57008 @bug:56878 @tdd @tdd:53405
  Scenario: 40490-4 Multiple changes of Origin
    Given the following basic schedules are received from LINX
      | trainUid | stpIndicator | dateRunsFrom | dateRunsTo | daysRun | trainDescription | origin | departure | termination | arrival |
      | H41107   | N            | 2020-01-01   | 2030-01-01 | 1111111 | 1X07             | PADTON | 12:00     | OLDOXRS     | 12:30   |
    And I do nothing
    And the following TJM is received
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | H41107   | 1X07        | 12            | create | 94        | 94              | 99999       | ROYAOJN        | 12:00:00 | 82                 | VA                |
      | H41107   | 1X07        | 12            | create | 94        | 94              | 99999       | PRTOBJP        | 12:00:01 | 82                 | VA                |
    When I am on the timetable view for service 'H41107'
    And I switch to the timetable details tab
    Then the sent TJMs are in the modifications table
    And the last TJM is correct

  @bug @bug:57008 @bug:56878 @tdd @tdd:53405
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
    Then the headcode in the header row is '1X99 (1X01)'
    And the sent TJMs are in the modifications table
    And the last TJM is correct
