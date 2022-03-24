@newSession
Feature: 46448 - TMV Trains List - access
  (From Gherkin for Feature 33764)

  As a TMV User
  I want the ability to have a tabular view of live trains that is filtered
  So that I have tailored list trains that I am interested in

  Background:
    * I have not already authenticated
    * I have cleared out all headcodes
    * I generate a new train description
    * I generate a new trainUID

  Scenario Outline: 33764-1a Access Trains List (First Time) - service displayed
    * I am on the home page
    * I reset redis
    * I restore to default train list config '1'
    * I delete '<planningUid>:today' from hash 'schedule-modifications-today'
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    * the following train activation message is sent from LINX
      | trainUID      | trainNumber          | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription>   | now                    | 99999               | PADTON                 | today         | now                 |
    When I click the app 'trains-list-1'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the url contains 'trains-list/1'
    When I save the trains list config
    Then The trains list table is visible
    And The default trains list columns are displayed in order
    And '<trainDescription>' are then displayed

    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |

  Scenario Outline: 33764-1b Access Trains List (First Time) - service not displayed
    * I am on the home page
    * I reset redis
    * I restore to default train list config '1'
    * I delete '<planningUid>:today' from hash 'schedule-modifications-today'
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    * I wait until today's train '<planningUid>' has loaded
    When I click the app 'trains-list-1'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the url contains 'trains-list/1'
    When I save the trains list config
    Then The trains list table is visible
    And The default trains list columns are displayed in order
    And '<trainDescription>' are not displayed

    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |

  Scenario Outline: 33764-2a Access Trains List (User Configured) - service displayed
    * I am on the home page
    * I reset redis
    * I restore to default train list config '1'
    * I delete '<planningUid>:today' from hash 'schedule-modifications-today'
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid  |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>   |
    * I wait until today's train '<planningUid>' has loaded
    * the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page 1
    And I set trains list columns to be '<columns>'
    And I have navigated to the 'TOC/FOC' configuration tab
    And I set toc filters to be '<tocs>'
    And I have navigated to the 'Train Class & MISC' configuration tab
    And I set 'Ignore PD Cancels' to be '<ignorePDCancelsFlag>'
    And I save the trains list config
    And I am on the home page
    And I click the app 'trains-list-1'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the url contains 'trains-list/1'
    And The trains list table is visible
    And The configured trains list columns are displayed in order
    And '<trainDescription>' are then displayed

    Examples:
      | columns                                                                                              | tocs                       | ignorePDCancelsFlag | trainDescription | planningUid |
      | Schedule Type, Last Reported Time, Service, Origin, Destination, Punctuality, Last Reported Location | GREAT WESTERN RAILWAY (EF) | off                 | generated        | generated   |

  Scenario Outline: 33764-2b Access Trains List (User Configured) - service not displayed
    * I am on the home page
    * I reset redis
    * I restore to default train list config '1'
    * I delete '<planningUid>:today' from hash 'schedule-modifications-today'
    * the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                            | refLocation | refTimingType | newTrainDescription | newPlanningUid  |
      | access-plan/1S42_PADTON_DIDCOTP.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>   |
    * I wait until today's train '<planningUid>' has loaded
    And I am on the trains list page 1
    And I set trains list columns to be '<columns>'
    And I have navigated to the 'TOC/FOC' configuration tab
    And I set toc filters to be '<tocs>'
    And I have navigated to the 'Train Class & MISC' configuration tab
    And I set 'Ignore PD Cancels' to be '<ignorePDCancelsFlag>'
    And I save the trains list config
    And I am on the home page
    And I click the app 'trains-list-1'
    Then the number of tabs open is 2
    When I switch to the new tab
    Then the url contains 'trains-list/1'
    And The trains list table is visible
    And The configured trains list columns are displayed in order
    And '<trainDescription>' are not displayed

    Examples:
      | columns                                                                                              | tocs                       | ignorePDCancelsFlag | trainDescription | planningUid |
      | Schedule Type, Last Reported Time, Service, Origin, Destination, Punctuality, Last Reported Location | GREAT WESTERN RAILWAY (EF) | off                 | generated        | generated   |
