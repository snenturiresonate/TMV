Feature: 33761-2 Train activation for a valid service
  As a TMV User
  I want the system process LINX train stepping messages
  So that I can view the train stepping on the schematic

  Background:
    * I am on the home page
    * I restore to default train list config '1'
    * I remove all trains from the trains list
    * I generate a new trainUID
    * I generate a new train description

  Scenario: 33761-2 Train Activation for a valid service
    * I delete 'generated:today' from hash 'schedule-modifications-today'
    * I remove today's train 'generated' from the trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I am on the trains list page 1
    And I save the trains list config
    And I wait until today's train 'generated' has loaded
    When the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | generated | generated   | now                    | 99999               | PADTON                 | today         | now                 |
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | generated     | rgba(255, 181, 120, 1) |
    # clean up
    * I restore to default train list config '1'

  Scenario: 33761-3 Train Activation for a cancelled service
      # A cancelled service that has been planned to be cancelled will not appear even when activated.
      # Only services that are cancelled via a TJM are displayed with the cancelled indication
    Given I delete 'L11001:today' from hash 'schedule-modifications-today'
    When the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/schedules_BS_type_C.cif | PADTON      | WTT_dep       | 0B00                | B10001         |
    And the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B10001   | 0B00        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page 1
    Then train '0A01' with schedule id 'L11001' for today is not visible on the trains list
    # clean up
    And I restore to default train list config '1'

  Scenario: 33761-4 Train Activation for an active service
    * I remove today's train 'generated' from the trainlist
    Given I delete 'generated:today' from hash 'schedule-modifications-today'
    When the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | generated | generated   | now                    | 99999               | PADTON                 | today         | now                 |
    And the following live berth interpose message is sent from LINX
      | toBerth | trainDescriber | trainDescription |
      | A007    | D3             | generated        |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID      | rowColour              |
      | Origin called             | generated     | rgba(255, 181, 120, 1) |
    # clean up
    And I restore to default train list config '1'

  Scenario: 33761-5 Train Activation for a valid service with a different origin
    * I remove today's train 'generated' from the trainlist
    Given I delete 'generated:today' from hash 'schedule-modifications-today'
    When the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | generated | generated   | now                    | 99999               | ROYAOJN                | today         | now                 |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType       | trainUID  | rowColour              |
      | Origin called | generated | rgba(255, 181, 120, 1) |
    # clean up
    And I restore to default train list config '1'

  Scenario: 33761-6 & 7 Train Activation for a valid service with a change of origin
    # A TJM for Change of origin will be required to bring about a Change of Origin indication
    * I remove today's train 'generated' from the trainlist
    Given I delete 'generated:today' from hash 'schedule-modifications-today'
    And I am on the trains list page 1
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name                     | colour | toggleValue |
      | Change of Origin         | #6a6   | off         |
      | Origin Departure Overdue | #6a6   | off         |
    And I save the trains list config
    When the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And the following TJM is received
        #tjmType-Change of Origin
      | trainUid  | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | generated | generated   | now           | create | 94        | 94              | 99999       | ROYAOJN        | now  | 94                 | PL                |
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | generated | generated   | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page 1
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID  | rowColour              |
      | Origin called             | generated | rgba(255, 181, 120, 1) |
    # clean up
    And I restore to default train list config '1'

  Scenario: 33761-8 Train Activation for a valid service with a change of origin matching current origin
    # A TJM for Change of origin will be required to bring about a Change of Origin indication
    * I remove today's train 'generated' from the trainlist
    Given I delete 'generated:today' from hash 'schedule-modifications-today'
    And I am on the trains list page 1
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name                     | colour | toggleValue |
      | Change of Origin         | #6a6   | off         |
      | Origin Departure Overdue | #6a6   | off         |
    And I save the trains list config
    When the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | generated           | generated      |
    And I wait until today's train 'generated' has loaded
    And the following TJM is received
        #tjmType-Change of Origin
      | trainUid  | trainNumber | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time | modificationReason | nationalDelayCode |
      | generated | generated   | now           | create | 94        | 94              | 99999       | PADTON         | now  | 94                 | PL                |
    And the following train activation message is sent from LINX
      | trainUID  | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | generated | generated   | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page 1
    And The trains list table is visible
    Then the service is displayed in the trains list with the following row colour
      | rowType                   | trainUID  | rowColour              |
      | Origin called             | generated | rgba(255, 181, 120, 1) |
    # clean up
    And I restore to default train list config '1'
