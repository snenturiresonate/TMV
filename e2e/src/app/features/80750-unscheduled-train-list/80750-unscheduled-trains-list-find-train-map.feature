@TMVPhase2 @P2.S4
Feature: 80750 - Unscheduled Trains List - Find Train Map

  As a TMV User
  I want to view unscheduled trains
  So that I can secondary click to view the train on associated map

#  Given the user is authenticated to use TMV
#  And the user has opened an unscheduled trains list
#  And the user views the unscheduled trains list
#  When the user selects a trains to find using the secondary click menu
#  And selects a map to display the train
#  Then a map opened in a new browser tab in which the train resides
#
#  Comments:
#    The train is not highlighted on map

  Background:
    * I generate a new train description

  @newSession
  Scenario Outline: 81293-1 - TMV Unscheduled Trains List - Find Train Map
    Given the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And I am on the unscheduled trains list
    And the following unscheduled trains list entry can be seen
      | trainId            | entryTime | entryBerth | entrySignal | entryLocation     | currentBerth | currentSignal | currentLocation   | currentTrainDescriber |
      | <trainDescription> | now       | D3A007     | SN7         | London Paddington | D3A007       | SN7           | London Paddington | D3                    |
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth | entrySignal | entryLocation     | currentBerth | currentSignal | currentLocation   | currentTrainDescriber |
      | <trainDescription> | now       | D3A007     | SN7         | London Paddington | D3A007       | SN7           | London Paddington | D3                    |
    When I hover over the trains list context menu on line 3
    Then the find train sub-menu displays the following maps
    | map    |
    | HDGW01 |
    | GW01   |
    When I click the first map on the sub-menu
    And I switch to the new tab
    Then the tab title is 'TMV Map HDGW01'
    And berth 'A007' in train describer 'D3' contains '<trainDescription>' and is visible

    Examples:
      | trainDescription  |
      | generated         |

