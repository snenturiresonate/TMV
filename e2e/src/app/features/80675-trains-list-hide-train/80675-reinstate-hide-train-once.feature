@TMVPhase2 @P2.S3
Feature: 80675 - TMV Trains List Hide Train - Hide Train Once - reinstate hidden once
  As a TMV User
  I want the ability to hide/unhide trains on the trains list
  So that I view trains that are relevant my business needs

  # Given the user is authenticated to use TMV
  # And the user is viewing the trains list
  # And the user has selected the train menu for a service that isn't hidden
  # And the user selects a train to hide once
  # And the train is cancelled
  # And the train is hidden from view for the scheduled day
  # When the train is reinstated
  # Then the train is displayed with the hidden constraint completely removed

  Background:
    * I remove all trains from the trains list
    * I am on the home page
    * I restore all train list configs for current user to the default
    * I generate a new train description
    * I generate a new trainUID

  Scenario Outline: 91746-1 - Hide Train Once - reinstate hidden once

    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    When the following train activation message is sent from LINX
      | trainUID      | trainNumber        | scheduledDepartureTime | locationPrimaryCode | locationSubsidiaryCode | departureDate | actualDepartureHour |
      | <planningUid> | <trainDescription> | now                    | 99999               | PADTON                 | today         | now                 |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    When I click the trains list menu button
    And the trains list toggle menu is displayed
    Then the hidden trains toggle is off
    When the following TJM is received
        #tjmType-Cancel en route
      | trainUid      | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <planningUid> | <trainDescription> | 12            | create | 92        | 92              | 99999       | PADTON         | 12:00:00 | 92                 | PG                |
    Then the service is displayed in the trains list with the following row colour
      | rowType                    | trainUID      | rowColour              |
      | Default Cancelled on route | <planningUid> | rgba(255, 255, 255, 1) |
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I hover over the trains list context menu on line 4
    And I click Hide Once from the trains list context menu
    And train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list
    When the following TJM is received
        #tjmType-Trains reinstatement - Whole train
      | trainUid      | trainNumber        | departureHour | status | indicator | statusIndicator | primaryCode | subsidiaryCode | time     | modificationReason | nationalDelayCode |
      | <planningUid> | <trainDescription> | 12            | create | 96        | 96              | 99999       | PADTON         | 12:00:00 | 96                 | PG                |
    Then the service is displayed in the trains list with the following row colour
      | rowType                  | trainUID      | rowColour              |
      | Default reinstatement    | <planningUid> | rgba(255, 255, 255, 1) |
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list

    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |
