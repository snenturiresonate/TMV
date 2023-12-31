Feature: 33761-2 Train activation for a valid service
  As a TMV User
  I want the system process LINX train stepping messages
  So that I can view the train stepping on the schematic

  Background:
    Given I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I wait for the indication config data to be retrieved
    And the following can be seen on the trains list indication table
      | name                      | colour  | minutes | toggleValue |
      | Change of Origin          | #cccc00 |         | on          |
      | Change of Identity        | #ccff66 |         | off         |
      | Cancellation              | #00ff00 |         | on          |
      | Reinstatement             | #00ffff |         | off         |
      | Off-route                 | #cc6600 |         | on          |
      | Next report overdue       | #ffff00 | 10      | off         |
      | Origin Called             | #9999ff | 50      | on          |
      | Origin Departure Overdue  | #339966 | 20      | on          |

  @tdd
  Scenario: 33761-2 Train Activation for a valid service
    Given I am on the trains list page
    And the service '0A00' is not active
    And there is a Schedule for '0A00'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 10:00            | 10:01              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And that service has the cancellation status 'F'
    When the schedule is received from LINX
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0A00        | 09:58                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Origin called             | 0A00       | rgba(153, 153, 255, 1)| rgba(0, 255, 0, 1)     |

  @tdd
  Scenario: 33761-3 Train Activation for a cancelled service
    Given I am on the trains list page
    And the service '0B00' is not active
    And there is a Schedule for '0B00'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:59              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 10:01            | 10:02              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:14            |      |
    And that service has the cancellation status 'T'
    When the schedule is received from LINX
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0A00        | 09:59                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Cancellation              | 0B00       | rgba(0, 255, 0, 1)    | rgba(0, 255, 0, 1)     |

  @tdd
  Scenario: 33761-4 Train Activation for an active service
    Given I am on the trains list page
    And the service '0C00' is active
    And there is a Schedule for '0C00'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:59              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 10:01            | 10:02              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:14            |      |
    And that service has the cancellation status 'F'
    When the schedule is received from LINX
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0A00        | 09:59                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Origin called             | 0C00       | rgba(153, 153, 255, 1)| rgba(0, 255, 0, 1)     |

  @tdd
  Scenario: 33761-5 Train Activation for a valid service with a different origin
    Given I am on the trains list page
    And the service '0D00' is not active
    And there is a Schedule for '0D00'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | PADTON | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 10:00            | 10:01              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And that service has the cancellation status 'F'
    When the schedule is received from LINX
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0A00        | 09:58                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Origin called             | 0D00       | rgba(153, 153, 255, 1)| rgba(0, 255, 0, 1)     |

  @tdd
  Scenario: 33761-6 Train Activation for a valid service with a change of origin
    Given I am on the trains list page
    And the service '0E00' is not active
    And there is a Schedule for '0E00'
    And it has Origin Details
      | tiploc | scheduledDeparture | line |
      | FALSE  | 09:58              |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 10:00            | 10:01              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And that service has the cancellation status 'F'
    When the schedule is received from LINX
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0A00        | 09:58                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Change of origin          | 0E00       | rgba(204, 204, 0, 1)  | rgba(0, 255, 0, 1)     |

  @tdd
  Scenario: 33761-8 Train Activation for a valid service with a change of origin matching current origin
    Given I am on the trains list page
    And the service '0F00' is not active
    And there is a Schedule for '0F00'
    And it has Origin Details
      | tiploc | scheduledDeparture             | line |
      | PADTON | 10:15 SAME AS CURRENT ORIGIN   |      |
    And it has Intermediate Details
      | tiploc  | scheduledArrival | scheduledDeparture | path | line |
      | ROYAOJN | 10:00            | 10:01              |      |      |
    And it has Terminating Details
      | tiploc  | scheduledArrival | path |
      | OLDOXRS | 10:13            |      |
    And that service has the cancellation status 'F'
    When the schedule is received from LINX
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0A00        | 10:15                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Origin called             | 0A00       | rgba(153, 153, 255, 1)| rgba(0, 255, 0, 1)     |
