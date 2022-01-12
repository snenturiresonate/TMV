Feature: 46448 - TMV Trains List - access
  (From Gherkin for Feature 33764)

  As a TMV User
  I want the ability to have a tabular view of live trains that is filtered
  So that I have tailored list trains that I am interested in

  Background:
    * I am on the home page
    * I reset redis
    * I restore to default train list config '1'
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | 2P77                | B00701         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | 3J41                | B00702         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | 5G44                | B00703         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | 2C45                | B00704         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | 1M34                | B00705         |
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | 1Z27                | B00706         |
    * I wait until today's train 'B00701' has loaded
    * I wait until today's train 'B00702' has loaded
    * I wait until today's train 'B00703' has loaded
    * I wait until today's train 'B00704' has loaded
    * I wait until today's train 'B00705' has loaded
    * I wait until today's train 'B00706' has loaded
    * the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B00701   | 2P77        | now                    | 99999               | PADTON                 | today         | now                 |
    * the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B00702   | 3J41        | now                    | 99999               | PADTON                 | today         | now                 |
    * the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B00703   | 5G44        | now                    | 99999               | PADTON                 | today         | now                 |
    * the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B00704   | 2C45        | now                    | 99999               | PADTON                 | today         | now                 |

  Scenario Outline: 33764-1 Access Trains List (First Time)
    When I click the app 'trains-list-1'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the url contains 'trains-list/1'
    When I save the trains list config
    Then The trains list table is visible
    And The default trains list columns are displayed in order
    And '<filteredServices>' are then displayed
    And '<filteredOutServices>' are not displayed

    Examples:
      | filteredServices       | filteredOutServices |
      | 2P77, 3J41, 5G44, 2C45 | 1M34, 1Z27          |

  Scenario Outline: 33764-2 Access Trains List (User Configured)
    * the following train activation message is sent from LINX
      | trainUID | trainNumber | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | B00705   | 1M34        | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page 1
    And I set trains list columns to be '<columns>'
    And I have navigated to the 'TOC/FOC' configuration tab
    And I set toc filters to be '<tocs>'
    And I have navigated to the 'Train Class & MISC' configuration tab
    And I set class filters to be '<classes>'
    And I set 'Ignore PD Cancels' to be '<ignorePDCancelsFlag>'
    And I set 'Include unmatched' to be '<unmatchedFlag>'
    And I save the trains list config
    And I am on the home page
    And I click the app 'trains-list-1'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the url contains 'trains-list/1'
    And The trains list table is visible
    And The configured trains list columns are displayed in order
    And '<filteredServices>' are then displayed
    And '<filteredOutServices>' are not displayed

    Examples:
      | columns                                                                                              | tocs                       | classes          | ignorePDCancelsFlag | unmatchedFlag | filteredServices | filteredOutServices          |
      | Schedule Type, Last Reported Time, Service, Origin, Destination, Punctuality, Last Reported Location | GREAT WESTERN RAILWAY (EF) | Class 1, Class 2 | off                 | on            | 2P77, 2C45, 1M34 | 5G44, 1Z27, 3J41 |

