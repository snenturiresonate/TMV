@TMVPhase2 @P2.S4
Feature: 80750 - Unscheduled Trains List - Match Train Menu

  As a TMV User
  I want view a dynamic list of unscheduled trains
  So that I have a central place to determine if manual matching is required

  #  Given the user is authenticated to use TMV
  #  And the user has the schedule matching role
  #  And the user has opened an unscheduled trains list
  #  And the user views the unscheduled trains list
  #  When the user selects a trains to match using the secondary click menu
  #  And selects the match option
  #  Then the matching view is opened in a new browser tab

  Background:
    * I generate a new train description

  Scenario Outline: 81299-1 - unscheduled trains list - the matching view is opened in a new browser tab
    Given I am on the unscheduled trains list
    And the following live berth interpose message is sent from LINX (to create an unmatched service)
      | toBerth | trainDescriber | trainDescription   |
      | A007    | D3             | <trainDescription> |
    And the following unscheduled trains list entry can be seen
      | trainId            | entryTime | entryBerth | entrySignal | entryLocation     | currentBerth | currentSignal | currentLocation    | currentTrainDescriber |
      | <trainDescription> | now       | D3A007     | SN7         | London Paddington | D3A007       | SN7           | London Paddington  | D3                    |
    And I right click on the following unscheduled train
      | trainId            | entryTime | entryBerth | entrySignal | entryLocation     | currentBerth | currentSignal | currentLocation    | currentTrainDescriber |
      | <trainDescription> | now       | D3A007     | SN7         | London Paddington | D3A007       | SN7           | London Paddington  | D3                    |
    When I click match on the unscheduled trains list context menu
    And I switch to the new tab
    Then the tab title is 'TMV Schedule Matching <trainDescription>'

    Examples:
      | trainDescription  |
      | generated         |
