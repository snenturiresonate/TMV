Feature: 33761-2 Train activation for a valid service
  As a TMV User
  I want the system process LINX train stepping messages
  So that I can view the train stepping on the schematic

  Background:
    * I am on the home page
    * I restore to default train list config
    * I remove all trains from the trains list

  Scenario: 33761-2 Train Activation for a valid service
    * I delete 'L11001:today' from hash 'schedule-modifications'
    * I remove today's train 'L11001' from the Redis trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 0A01                | L11001         |
    And I am on the trains list page
    And I wait until today's train 'L11001' has loaded
    When the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | L11001   | 0A01        | now                    | 99999               | PADTON                 | today         | now                 |
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | L11001        | rgba(255, 181, 120, 1) |
    # clean up
    * I restore to default train list config

  Scenario: 33761-3 Train Activation for a cancelled service
      # A cancelled service that has been planned to be cancelled will not appear even when activated.
      # Only services that are cancelled via a TJM are displayed with the cancelled indication
    Given I delete 'L11001:today' from hash 'schedule-modifications'
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/schedules_BS_type_C.cif | PADTON      | WTT_dep       | 0B00                | B10001         |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B10001   | 0B00        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    Then train '0A01' with schedule id 'L11001' for today is not visible on the trains list
    # clean up
    And I restore to default train list config

  Scenario: 33761-4 Train Activation for an active service
    * I remove today's train 'C10001' from the Redis trainlist
    Given I delete 'C10001:today' from hash 'schedule-modifications'
    When the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1C01                | C10001         |
    And I wait until today's train 'C10001' has loaded
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | C10001   | 1C01        | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | 1C01             |
    And I am on the trains list page
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | C10001        | rgba(255, 181, 120, 1) |
    # clean up
    And I restore to default train list config

  Scenario: 33761-5 Train Activation for a valid service with a different origin
    * I remove today's train 'D10001' from the Redis trainlist
    Given I delete 'D10001:today' from hash 'schedule-modifications'
    When the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 1D01                | D10001         |
    And I wait until today's train 'D10001' has loaded
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | D10001   | 1D01        | now                    | 99999               | ROYAOJN                | today         | now                 |
    And I am on the trains list page
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | D10001        | rgba(255, 181, 120, 1) |
    # clean up
    And I restore to default train list config

  Scenario: 33761-6 & 7 Train Activation for a valid service with a change of origin
    # A TJM for Change of origin will be required to bring about a Change of Origin indication
    * I remove today's train 'W15214' from the Redis trainlist
    Given I delete 'W15214:today' from hash 'schedule-modifications'
    And I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name                     | colour | toggleValue |
      | Change of Origin         | #6a6   | off         |
      | Origin Departure Overdue | #6a6   | off         |
    And I save the trains list config
    When the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 0E00                | W15214         |
    And I wait until today's train 'W15214' has loaded
    And the following TJM is received
        #tjmType-Change of Origin
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | W15214   | 0E00        | now           | create | 94        | 94              | 99999       | ROYAOJN        | now  | 94                 | PL                |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | W15214   | 0E00        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | W15214        | rgba(255, 181, 120, 1) |
    # clean up
    And I restore to default train list config

  Scenario: 33761-8 Train Activation for a valid service with a change of origin matching current origin
    # A TJM for Change of origin will be required to bring about a Change of Origin indication
    * I remove today's train 'W15216' from the Redis trainlist
    Given I delete 'W15216:today' from hash 'schedule-modifications'
    And I am on the trains list Config page
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name                     | colour | toggleValue |
      | Change of Origin         | #6a6   | off         |
      | Origin Departure Overdue | #6a6   | off         |
    And I save the trains list config
    When the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | 0E01                | W15216         |
    And I wait until today's train 'W15216' has loaded
    And the following TJM is received
        #tjmType-Change of Origin
      | trainUid | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | W15216   | 0E01        | now           | create | 94        | 94              | 99999       | PADTON         | now  | 94                 | PL                |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | W15216   | 0E01        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | W15216        | rgba(255, 181, 120, 1) |
    # clean up
    And I restore to default train list config
