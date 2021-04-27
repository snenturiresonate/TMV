Feature: 33761-2 Train activation for a valid service
  As a TMV User
  I want the system process LINX train stepping messages
  So that I can view the train stepping on the schematic

  Background:
    Given I am on the trains list Config page
    And I restore to default train list config
  @bug @bug_60104
  Scenario: 33761-2 Train Activation for a valid service
    Given I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name          | colour | toggleValue |
      | Origin Called | #dde   | on          |
    And I save the trains list config
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1A01                | L10001         |
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 1A01    | L10001   |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | L10001   | 1A01        | now                    | 99999               | PADTON                 | today         | now                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType       | trainUID | rowColFill             | trainDescriptionFill |
      | Origin called | L10001   | rgba(221, 221, 238, 1) | rgba(0, 255, 0, 1)   |
    And I restore to default train list config

  Scenario: 33761-3 Train Activation for a cancelled service
      # A cancelled service that has been planned to be cancelled will not appear even when activated.
      # Only services that are cancelled via a TJM are displayed with the cancelled indication
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/schedules_BS_type_C.cif | PADTON      | WTT_dep       | 0B00                | B10001         |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B10001   | 0B00        | now                    | 99999               | PADTON                 | today         | now                 |
    And the following service is not displayed on the trains list
      | trainId | trainUId |
      | 0B00    | B10001   |
    And I restore to default train list config
  @bug @bug_60104
  Scenario: 33761-4 Train Activation for an active service
    Given I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name          | colour | toggleValue |
      | Origin Called | #dde   | on          |
    And I save the trains list config
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1C01                | C10001         |
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 1C01    | C10001   |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | C10001   | 1C01        | now                    | 99999               | PADTON                 | today         | now                 |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType       | trainUID | rowColFill             | trainDescriptionFill |
      | Origin called | C10001   | rgba(221, 221, 238, 1) | rgba(0, 255, 0, 1)   |
    And I restore to default train list config
  @bug @bug_60104
  Scenario: 33761-5 Train Activation for a valid service with a different origin
    Given I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name          | colour | toggleValue |
      | Origin Called | #55f   | on          |
    And I save the trains list config
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1D01                | D10001         |
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 1D01    | D10001   |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | D10001   | 1D01        | now                    | 99999               | ROYAOJN                | today         | now                 |
    Then the following service is displayed on the trains list
      | trainId | trainUId |
      | 1D01    | D10001   |
    And the service is displayed in the trains list with the following indication
      | rowType       | trainUID | rowColFill           | trainDescriptionFill |
      | Origin called | D10001   | rgba(85, 85, 255, 1) | rgba(0, 255, 0, 1)   |
    And I restore to default train list config
  @bug @bug_60104
  Scenario: 33761-6 Train Activation for a valid service with a change of origin
    Given I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name             | colour | toggleValue |
      | Change of Origin | #6a6   | on          |
    And I save the trains list config
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 0E00                | W15214         |
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 0E00    | W15214   |
    And the following TJM is received
        #tjmType-Change of Origin
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | W15214   | 0E00        | now           | create | 94        | 94              | 99999       | ROYAOJN        | now  | 94                 | PL                |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | W15214   | 0E00        | now                    | 99999               | PADTON                 | today         | now                 |
    Then the following service is displayed on the trains list
      | trainId | trainUId |
      | 0E00    | W15214   |
    And the service is displayed in the trains list with the following indication
      | rowType          | trainUID | rowColFill             | trainDescriptionFill |
      | Change of origin | W15214   | rgba(102, 170, 102, 1) | rgba(0, 255, 0, 1)   |
    And I restore to default train list config
  @bug @bug_60104
  Scenario: 33761-8 Train Activation for a valid service with a change of origin matching current origin
    Given I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name          | colour | toggleValue |
      | Origin Called | #833   | on          |
    And I save the trains list config
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1F01                | F15214         |
    And the following service is displayed on the trains list
      | trainId | trainUId |
      | 1F01    | F15214   |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour | asm |
      | F15214   | 1F01        | now                    | 99999               | ROYAOJN                | today         | now                 | 1   |
    Then The trains list table is visible
    And the service is displayed in the trains list with the following indication
      | rowType       | trainUID | rowColFill           | trainDescriptionFill |
      | Origin called | F15214   | rgba(136, 51, 51, 1) | rgba(0, 255, 0, 1)   |
    And I restore to default train list config
