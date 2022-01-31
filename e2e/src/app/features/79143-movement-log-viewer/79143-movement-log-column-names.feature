@TMVPhase2 @P2.S2
Feature: 79143 - TMV Movement Log Viewer - Update Column Names

  As a TMV User
  I want to view, filter and search the Movement Logs
  So that I can work with the data that is of interest to me within the Movement Logs

  Scenario Outline: 80271 - Movement Log - Updated Column Names
#  Given the user is authenticated to use TMV
#  And the user is viewing the Movement Logs
#  When the search results are loaded
#  Then the columns are displayed in a specific order with updated column names.
    Given I am on the log viewer page
    And I generate a new trainUID
    And I generate a new train description
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription   |
      | <berth1> | <trainDescriber> | <trainDescription> |
    And the following live berth step message is sent from LINX (adding a further movement)
      | fromBerth | toBerth  | trainDescriber   | trainDescription   |
      | <berth1>  | <berth2> | <trainDescriber> | <trainDescription> |
    And I navigate to the Movement log tab
    When I search for Berth logs for planningUid '<planningUid>'
    Then the log results table has columns in the following order
      | colName                         |
      | Train ID                        |
      | From Berth                      |
      | To Berth                        |
      | Previous Train ID               |
      | Date Time                       |
      | Punctuality Status              |
      | Planning UID                    |
      | Scheduled Origin Departure Date |

    Examples:
      | berth1 | berth2 | trainDescriber | trainDescription | planningUid |
      | C007   | A007   | D3             | generated        | generated   |
