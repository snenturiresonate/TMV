@TMVPhase2 @P2.S3
Feature: 80183 - TMV Trains List Filtering - Config - Nominated Services

  As a TMV User
  I want the ability to config separate trains list filtering with enhanced functions
  So that I can set up different trains list for specific operational needs

#  Given the user is authenticated to use TMV
#  When the user is viewing the trains list config nominated service tab
#  Then the user has the ability to toggle on or off the nominated services
#  And view a list of results based on the nominated services defined overriding all other criteria
#    Comments
#       * The TRUST ID tab has been renamed to nominated services:
#           - TRUST IDs label to Nominated Services
#           - TRUST ID to Nominated Service
#           - Selected TRUST IDs to Nominate Services
#  Additional business logical defined:
#       * The overriding of all other criteria means the following:
#           - Columns - unaffected
#           - Punctuality - colours unaffected, but exclusions are applicable
#           - TOC/FOC -  overridden i.e. include all - none selected
#           - Locations - overridden i.e. include all - none selected
#           - Train indication - colours unaffected, but exclusions are applicable
#           - MISC
#                x Class - include all
#                x Ignore PD Cancel - includes PD cancels
#                x Include unmatched - the trains list will only display match services for phase 2 N/A
#                x Time to remain on list (min) - applied
#                                https://resonatevsts.visualstudio.com/Luminate-TMV/_testPlans/execute?planId=83054&suiteId=91962
#           - Regions/Routes - include all i.e. none selected

  Background:
    * I reset redis
    * I have cleared out all headcodes
    * I remove all trains from the trains list
    * I have not already authenticated
    * I am on the home page
    * I restore all train list configs for current user to the default
    * I generate a new trainUID
    * I generate a new train description

  Scenario Outline: 80345-1 - Both punctuality and nominated config should be applicable (And Query)
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am authenticated to use TMV
    And I restore to default train list config '1'
    And I am on the trains list page 1
    And I have navigated to the 'Punctuality' configuration tab
    And I switch on only on-time punctuality
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I navigate to train list configuration
    And I have navigated to the 'Nominated Services' configuration tab
    And the Nominated Services toggle is toggled on
    And I input '<trainDescription>' in the 'trainIdInput' input box
    And I click the add button for Nominated Services Filter
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |


  Scenario Outline: 80345-2 - Nominated config should override TOC/FOC
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am authenticated to use TMV
    And I am on the trains list page 1
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I navigate to train list configuration
    And I have navigated to the 'TOC/FOC' configuration tab
    And I set toc filters to be 'AMEY (RE)'
    When I save the trains list config
    Then there are no train entries present on the trains list
    And I navigate to train list configuration
    And I have navigated to the 'Nominated Services' configuration tab
    And the Nominated Services toggle is toggled on
    And I input '<trainDescription>' in the 'trainIdInput' input box
    And I click the add button for Nominated Services Filter
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 80345-3 - Nominated config should override locations
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am authenticated to use TMV
    And I am on the trains list page 1
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I navigate to train list configuration
    And I have navigated to the 'Locations' configuration tab
    And I choose the location filter as 'All locations, order applied'
    And I have only the following locations and stop types selected
      | locationNameValue | Originate | Stop       | Pass       | Terminate  |
      | SLOUGH            | Checked   | un-Checked | checked    | unchecked  |
      | PADTON            | Checked   | un-checked | un-checked | un-checked |
    Then there are no train entries present on the trains list
    And I navigate to train list configuration
    And I have navigated to the 'Nominated Services' configuration tab
    And I input '<trainDescription>' in the 'trainIdInput' input box
    And I click the add button for Nominated Services Filter
    And the Nominated Services toggle is toggled on
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |


  Scenario Outline: 80345-4 - Both train indication and nominated config should be applicable
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am authenticated to use TMV
    And I am on the trains list page 1
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    When the following TJM is received
        #tjmType-Cancel at origin
      | trainUid      | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <planningUid> | <trainDescription> | 12            | create | 91        | 91              | 99999       | PADTON         | 12:00:00 | 91                 | PG                |
    Then the service is displayed in the trains list with the following row colour
      | rowType                     | trainUID      | rowColour              |
      | Default Cancelled at origin | <planningUid> | rgba(255, 255, 255, 1) |
    When I navigate to train list configuration
    And I have navigated to the 'Train Indication' configuration tab
    And I update only the below train list indication config settings as
      | name         | colour | toggleValue |
      | Cancellation | #dde   | on          |
    And I save the trains list config
    Then the service is displayed in the trains list with the following row colour
      | rowType                | trainUID      | rowColour              |
      | Cancellation at origin | <planningUid> | rgba(221, 221, 238, 1) |
    And I navigate to train list configuration
    And I have navigated to the 'Nominated Services' configuration tab
    And I input '<trainDescription>' in the 'trainIdInput' input box
    And I click the add button for Nominated Services Filter
    And the Nominated Services toggle is toggled on
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And the service is displayed in the trains list with the following row colour
      | rowType                | trainUID      | rowColour              |
      | Cancellation at origin | <planningUid> | rgba(221, 221, 238, 1) |
    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 80345-5 - Nominated config should override train class config
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am authenticated to use TMV
    And I am on the trains list page 1
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I navigate to train list configuration
    And I have navigated to the 'Train Class & MISC' configuration tab
    When the following class table updates are made
      | classValue | toggleValue |
      | Class 0    | on          |
      | Class 1    | off         |
      | Class 2    | off         |
      | Class 3    | off         |
      | Class 4    | off         |
      | Class 5    | off         |
      | Class 6    | off         |
      | Class 7    | off         |
      | Class 8    | off         |
      | Class 9    | off         |
    And I save the trains list config
    Then there are no train entries present on the trains list
    And I navigate to train list configuration
    And I have navigated to the 'Nominated Services' configuration tab
    And I input '<trainDescription>' in the 'trainIdInput' input box
    And I click the add button for Nominated Services Filter
    And the Nominated Services toggle is toggled on
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 80345-6 - Nominated config should override Regions/Routes config
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am authenticated to use TMV
    And I am on the trains list page 1
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I navigate to train list configuration
    And I have navigated to the 'Region/Route' configuration tab
    And I set region filters to be 'Eastern'
    When I save the trains list config
    Then there are no train entries present on the trains list
    And I navigate to train list configuration
    And I have navigated to the 'Nominated Services' configuration tab
    And I input '<trainDescription>' in the 'trainIdInput' input box
    And I click the add button for Nominated Services Filter
    And the Nominated Services toggle is toggled on
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |

  Scenario Outline: 80345-7 - Nominated config should override Ignore PD Cancel config
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '1' minute, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am authenticated to use TMV
    And I am on the trains list page 1
    And I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    When the following TJM is received
        #tjmType-Cancel at origin
      | trainUid      | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <planningUid> | <trainDescription> | 12            | create | 91        | 91              | 99999       | PADTON         | 12:00:00 | 91                 | PD                |
    And I am authenticated to use TMV
    And I restore to default train list config '1'
    And I am on the trains list page 1
    And I have navigated to the 'Train Class & MISC' configuration tab
    And I update the following misc options
      | classValue        | toggleValue |
      | Ignore PD Cancels | on          |
    And I save the service filter changes
    And I am on the trains list page 1
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list
    And I navigate to train list configuration
    And I have navigated to the 'Nominated Services' configuration tab
    And I input '<trainDescription>' in the 'trainIdInput' input box
    And I click the add button for Nominated Services Filter
    And the Nominated Services toggle is toggled on
    When I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    Examples:
      | trainDescription          | planningUid       |
      | generatedTrainDescription | generatedTrainUId |
