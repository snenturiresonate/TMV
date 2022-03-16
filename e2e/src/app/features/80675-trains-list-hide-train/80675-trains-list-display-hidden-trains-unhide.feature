@TMVPhase2 @P2.S3
Feature: 80675 - TMV Trains List - Hide Train

  As a TMV User
  I want the ability to hide/unhide trains on the trains list
  So that I view trains that are relevant my business needs

  Background:
    * I remove all trains from the trains list
    * I am on the home page
    * I restore all train list configs for current user to the default
    * I generate a new train description
    * I generate a new trainUID

  Scenario Outline: 81287-1 - TMV Trains List - Display Hidden Trains - Unhide All Trains
    # Given the user is authenticated to use TMV
    # And the user is viewing the trains list
    # And the user opted to display hidden trains
    # And the trains list has entries which have been hidden by the user (always or once)
    # When the user selects unhide all trains in one operation
    # Then all hide trains are displayed without any hidden symbols
    #
    # The hidden trains are applicable for each trains list
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from Origin |
    And I am on the trains list page <configId>
    And I save the trains list config
    And The trains list table is visible
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu contains 'Hide Train' on line 4
    When I hover over the trains list context menu on line 4
    And I click the Hide Once menu item
    Then The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is not visible on the trains list
    And I click on the trains list toggle menu
    And the trains list toggle menu is displayed
    And I click Unhide All Trains
    Then The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And the hidden icons are displayed
      | scheduleId    | icon |
      | <planningUid> |      |

    Examples:
      | planningUid  | trainDescription | configId |
      | generated    | generated        | 1        |
      | generated    | generated        | 2        |
      | generated    | generated        | 3        |

  Scenario Outline: 81286-1 - TMV Trains List - TMV Trains List Hide Train - Unhide Individual Train (context menu)
    # Given the user is authenticated to use TMV
    # And the user is viewing the trains list
    # And the user opted to display hidden trains
    # And the trains list has entries which have been hidden by the user (always or once)
    # When the user selects a train to unhide (always or once)
    # Then the train is displayed without any hidden symbols
    # And displayed even if the hidden trains toggle is off
    #
    # The hidden trains are applicable for each trains list
    Given the train in CIF file below is updated accordingly so time at the reference point is now + '2' minutes, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following train running information message is sent from LINX
      | trainUID      | trainNumber        | scheduledStartDate | locationPrimaryCode | locationSubsidiaryCode | messageType           |
      | <planningUid> | <trainDescription> | today              | 73000               | PADTON                 | Departure from Origin |
    And I am on the trains list page <configId>
    And I save the trains list config
    And The trains list table is visible
    When I click on the trains list toggle menu
    And the trains list toggle menu is displayed
    And the hidden trains toggle is off
    Then I toggle the hidden trains to on
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu contains 'Hide Train' on line 4
    When I hover over the trains list context menu on line 4
    And I click the Hide Once menu item
    Then The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And the hidden icons are displayed
      | scheduleId    | icon              |
      | <planningUid> | eye-off-black.png |
    When I invoke the context menu for todays train '<trainDescription>' schedule uid '<planningUid>' from the trains list
    And I wait for the trains list context menu to display
    Then the trains list context menu contains 'Unhide Train' on line 4
    When I click the Unhide menu item
    Then The trains list table is visible
    And train '<trainDescription>' with schedule id '<planningUid>' for today is visible on the trains list
    And the hidden icons are displayed
      | scheduleId         | icon |
      | <planningUid>      |      |

    Examples:
      | planningUid  | trainDescription | configId |
      | generated    | generated        | 1        |
      | generated    | generated        | 2        |
      | generated    | generated        | 3        |


