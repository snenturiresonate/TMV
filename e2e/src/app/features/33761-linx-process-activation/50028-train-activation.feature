Feature: 33761-2 Train activation for a valid service
  As a TMV User
  I want the system process LINX train stepping messages
  So that I can view the train stepping on the schematic

  Background:
    Given I am on the trains list Config page
    And I restore to default train list config
    #And I have navigated to the 'Train Indication' configuration tab
    #And I wait for the indication config data to be retrieved
    #And the following can be seen on the trains list indication table
    #  | name                     | colour  | minutes | toggleValue |
    #  | Change of Origin         | #ffffff |         | on          |
    #  | Change of Identity       | #ffffff |         | on          |
    #  | Cancellation             | #ffffff |         | on          |
    #  | Reinstatement            | #ffffff |         | on          |
    #  | Off-route                | #ffffff |         | on          |
    #  | Next report overdue      | #0000ff | 15      | off         |
    #  | Origin Called            | #ffb578 | 15      | on          |
    #  | Origin Departure Overdue | #ffffff | 1       | on          |

  Scenario: 33761-2 Train Activation for a valid service
    Given I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name      | colour |  toggleValue |
      | Origin Called | #dde   |  on          |
    And I save the trains list config
    #And the service '0A00' is not active
    #And the following service is not displayed on the trains list
    #  | trainId | trainUId |
    #  | 1D46    | W15214   |
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON     | WTT_dep       | 1A01                | L10001         |
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 1A01    | L10001   |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |departureDate|actualDepartureHour|
      | L10001   | 1A01        | now                  | 99999               | PADTON                 | today         |now                   |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | trainUID      | rowColFill            | trainDescriptionFill   |
      | Origin called             | L10001        | rgba(221, 221, 238, 1)| rgba(0, 255, 0, 1)     |
    And I restore to default train list config

  Scenario: 33761-3 Train Activation for a cancelled service
    Given I am on the trains list page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name      | colour |  toggleValue |
      | Cancellation | #dde   |  on          |
    #And the service '0B00' is not active
    #And the following service is not displayed on the trains list
    #  | trainId | trainUId |
    #  | 0B00    | W15214   |
    #And there is a Schedule for '0B00'
    #And it has Origin Details
    #  | tiploc | scheduledDeparture | line |
    #  | PADTON | 09:59              |      |
    #And it has Intermediate Details
    #  | tiploc  | scheduledArrival | scheduledDeparture | path | line |
    #  | ROYAOJN | 10:01            | 10:02              |      |      |
    #And it has Terminating Details
    #  | tiploc  | scheduledArrival | path |
    #  | OLDOXRS | 10:14            |      |
    #And that service has the cancellation status 'C'
    #When the schedule is received from LINX
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/schedules_BS_type_C.cif | PADTON     | WTT_dep       | 0B00                | B10001         |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | B10001   | 0B00        | now                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 0B00    | B10001   |
    And the service is displayed in the trains list with the following indication
      | rowType                   | trainUID      | rowColFill            | trainDescriptionFill   |
      | Cancellation              | B10001       | rgba(0, 255, 0, 1)    | rgba(0, 255, 0, 1)     |

  Scenario: 33761-4 Train Activation for an active service
    Given I am on the trains list page
    #And the service '0C00' is active
    #And the following service is not displayed on the trains list
    #  | trainId | trainUId |
    #  | 0C00    | W15214   |
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
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 0C00    | W15214   |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0C00        | 09:59                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Origin called             | 0C00       | rgba(153, 153, 255, 1)| rgba(0, 255, 0, 1)     |

  Scenario: 33761-5 Train Activation for a valid service with a different origin
    Given I am on the trains list page
    #And the service '0D00' is not active
    #And the following service is not displayed on the trains list
    #  | trainId | trainUId |
    #  | 0D00    | W15214   |
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
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 0D00    | W15214   |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0D00        | 09:58                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Origin called             | 0D00       | rgba(153, 153, 255, 1)| rgba(0, 255, 0, 1)     |

  Scenario: 33761-6 Train Activation for a valid service with a change of origin
    Given I am on the trains list page
    #And the service '0E00' is not active
    #And the following service is not displayed on the trains list
    #  | trainId | trainUId |
    #  | 0E00    | W15214   |
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
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 0E00    | W15214   |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0E00        | 09:58                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Change of origin          | 0E00       | rgba(204, 204, 0, 1)  | rgba(0, 255, 0, 1)     |

  Scenario: 33761-8 Train Activation for a valid service with a change of origin matching current origin
    Given I am on the trains list page
    #And the service '0F00' is not active
    #And the following service is not displayed on the trains list
    #  | trainId | trainUId |
    #  | 0F00    | W15214   |
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
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 0F00    | W15214   |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode |
      | W15214   | 0F00        | 10:15                  | 99999               | PADTON                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType                   | rowId      | rowColFill            | trainDescriptionFill   |
      | Origin called             | 0A00       | rgba(153, 153, 255, 1)| rgba(0, 255, 0, 1)     |
