@TMVPhase2 @P2.S4
Feature: 80750 - Unscheduled Trains List - Find Train Menu

  As a TMV User
  I want view a dynamic list of unscheduled trains
  So that I have a central place to determine if manual matching is required

  #  Given the user is authenticated to use TMV
  #  And the user has opened an unscheduled trains list
  #  And the user views the unscheduled trains list
  #  When the user selects a trains to find using the secondary click menu
  #  Then the user is presented with either one or more maps in which the train currently resides

  Background:
    * I generate a new train description

  @newSession
  Scenario Outline: 81292-1 - TMV Unscheduled Trains List - Find Train Menu
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

    Examples:
      | trainDescription  |
      | generated         |

