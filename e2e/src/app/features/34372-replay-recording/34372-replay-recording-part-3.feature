@newSession @TMVPhase2
Feature: 33753 - Replay Recording (part 3)

  As a TMV User
  I want the system to record the live railway events
  So that I can replay the railway for replay purposes

  Background:
    * I have not already authenticated
    * I have cleared out all headcodes
    * I generate a new train description
    * I generate a new trainUID

  Scenario Outline: 55985-9 Replay - View Associations in the timetable
#    Given has started a replay session
#    And are viewing a map with trains present
#    When they open and timetable
#    Then the Actual/Predicted are displayed for the day corresponding to the date and time of the replay
    Given I am on the home page
    And the access plan located in CIF file 'access-plan/associations_test.cif' is received from LINX
    And I give the timetable an extra 2 seconds to load
    And I wait until today's train '<trainUid>' has loaded
    And I refresh the Elastic Search indices
    When I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I search Timetable for '<trainDesc>' and wait for result
      | PlanningUid |
      | <trainUid>  |
    And the search table is shown
    And I open the timetable for the next train with UID <trainUid> from the search results
    And I switch to the new tab
    When I switch to the timetable details tab
    Then the tab title is '<trainDesc> TMV Replay Timetable'
    And The timetable details tab is visible
    Then The timetable associations table contains the following entries
      | location   | type        | trainDescription |
      | <assocLoc> | <assocType> | <assocTrainDesc> |

    Examples:
      | trainDesc | trainUid | assocType | assocLoc       | assocTrainDesc |
      | 2M39      | L78729   | NP Next   | Westbury       | 2F97           |
      | 2G13      | L04499   | JJ Join   | Purley         | 2P13           |
      | 1H63      | G46338   | VV Divide | Haywards Heath | 1H65           |
