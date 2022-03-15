@TMVPhase2 @P2.S3
Feature: 80675 - TMV Trains List Hide Train - Hide Train Once
  As a TMV User
  I want the ability to hide/unhide trains on the trains list
  So that I view trains that are relevant my business needs

  #  Given the user is authenticated to use TMV
  #  And the user is viewing the trains list
  #  And the user has selected the train menu for a service that isn't hidden
  #  When the user selects a train to hide once
  #  Then the train is hidden from view for the scheduled day
  #
  #  Comments:
  #    * The hidden trains are applicable for each trains list
  #    * A user may display all hidden trains and decide to unhide a train
  #    * If a user wishes to change a once hidden train to always hidden then they must first unhide the train
  #    * Applicable to trains that have started today and may finish past midnight
  #
  #  Solution Design:
  #    * If the max limit of hide once or hide always is reached the option to hide is disabled

  Background:
    * I remove all trains from the trains list
    * I am on the home page
    * I restore all train list configs for current user to the default
    * I generate a new train description
    * I generate a new trainUID

  Scenario Outline: 81282-1 - Hide Train Once - train is hidden
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from Origin |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I hover over the trains list context menu on line 4
    And I click Hide Once from the trains list context menu
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list

    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |


  Scenario Outline: 81282-2 - Hide Train Once - train is hidden on current trains list but not on the other two trains lists
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from Origin |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I hover over the trains list context menu on line 4
    And I click Hide Once from the trains list context menu
    And train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list
    When I am on the trains list page 2
    And I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    When I am on the trains list page 3
    And I save the trains list config
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list

    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |


  Scenario Outline: 81282-3 - Hide Train Once - all hidden trains can be displayed
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from Origin |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I hover over the trains list context menu on line 4
    And I click Hide Once from the trains list context menu
    And train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list
    When I click the trains list menu button
    And I click the display all hidden trains slider
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list

    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |


  Scenario Outline: 81282-4 - Hide Train Once - a hidden train can be unhidden
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from Origin |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I hover over the trains list context menu on line 4
    And I click Hide Once from the trains list context menu
    And train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list
    And I click the trains list menu button
    And I click the display all hidden trains slider
    And I click the trains list menu button
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I click Unhide Train from the trains list context menu
    And I click the trains list menu button
    And I click the display all hidden trains slider
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list

    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |


  Scenario Outline: 81282-5 - Hide Train Once - a hidden once train can become an unhidden and then an always hidden train
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from Origin |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I hover over the trains list context menu on line 4
    And I click Hide Once from the trains list context menu
    And train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list
    And I click the trains list menu button
    And I click the display all hidden trains slider
    And I click the trains list menu button
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I click Unhide Train from the trains list context menu
    And I click the trains list menu button
    And I click the display all hidden trains slider
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I hover over the trains list context menu on line 4
    And I click Hide Always from the trains list context menu
    And train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list

    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |


  Scenario Outline: 81282-6 - Hide Train Once - a train that finishes past midnight can be hidden
    Given the access plan located in CIF file 'access-plan/51586-schedules/51586-22.cif' is received from LINX with the new uid
    And I wait until today's train '<planningUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 99999               | BHAMNWS                | Departure from Origin |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I hover over the trains list context menu on line 4
    And I click Hide Once from the trains list context menu
    Then train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list

    Examples:
      | trainDescription | planningUid |
      | 5A22             | generated   |


  @bug @bug:91582 @bug:91584
  # this is a slow test and needs manual intervention
  @manual
  Scenario Outline: 81282-7 - Hide Train Once - once the max hide limit is reached, the option to hide is disabled
    * I am on the trains list page 1
    * I save the trains list config
    * The trains list table is visible
    Given there are 49 trains displayed on the trains list
    And the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from Origin |
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I hover over the trains list context menu on line 4
    And I click Hide Once from the trains list context menu
    And train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list
    * I generate a new train description
    * I generate a new trainUID
    And the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    When the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from Origin |
    And I am on the trains list page 1
    And I save the trains list config
    And The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    And I hover over the trains list context menu on line 4
    Then the Hide Once item on the trains list context menu is greyed out

    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |
