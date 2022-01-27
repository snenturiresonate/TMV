@TMVPhase2 @P2.S2
Feature: 79593 - TMV Timetable Log Viewer - Timetable View

  As a TMV User
  I want to search & view timetables in user-readable format from the timetable log viewer
  So that I have familiar representation of the timetable that makes it easier for me to understand and search for

#  Given the user is authenticated to use TMV
#  And the user is viewing the Timetable Logs
#  And is viewing a list of results
#  And has a timetable selected
#  When the user opts to open the timetable
#  Then the timetable is opened in a timetable tab

  Scenario Outline: 80298 - Timetable Logs - Timetable View
    Given I generate a new trainUID
    And I generate a new train description
    And I remove all trains from the trains list
    And I remove today's train '<planningUid>' from the Redis trainlist
    And I am on the log viewer page
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    When I give the train 2 seconds to get into elastic search
    And I refresh the Elastic Search indices
    And I navigate to the Timetable log tab
    And I search for Timetable logs with
      | trainDescription   | planningUid   |
      | <trainDescription> | <planningUid> |
    And there is 1 row returned in the log results
    And the first movement log timetable results are
      | trainId            | scheduleType | planningUid   |
      | <trainDescription> | LTP          | <planningUid> |
    When I primary click for the record for '<trainDescription>' schedule uid '<planningUid>' from the timetable results
    And the number of tabs open is 2
    And I switch to the new tab
    Then the tab title is 'TMV Logged Timetable'
    And the timetable tab is titled '<trainDescription> TMV Timetable'
    And The values for the cutdown header properties are as follows
      | schedType | trainUid      |
      | LTP       | <planningUid> |


    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |
