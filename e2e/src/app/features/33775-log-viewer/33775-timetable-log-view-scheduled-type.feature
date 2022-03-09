@TMVPhase2 @P2.Closeout
Feature: 33775 - TMV Timetable Log View (Scheduled Type)

  As a TMV User
  I want to search & view timetables in user-readable format from the timetable log viewer
  So that I have familiar representation of the timetable that makes it easier for me to understand and search for

#  Given that I have the log viewer screen open on a Timetable tab
#  When I select the schedule type filter
#  And choose a one or more schedule types
#  And submits the search
#  Then the results are filter based on my schedule type selection

  Scenario Outline: 84154 - TMV Timetable Log View (Scheduled Type)
    Given I generate a new trainUID
    And I generate a new train description
    And I remove all trains from the trains list
    And I remove today's train '<planningUid>' from the trainlist
    And I am on the log viewer page
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription>  | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And I give the train 2 seconds to get into elastic search
    And I refresh the Elastic Search indices
    And I navigate to the Timetable log tab
    When I search for Timetable logs with
      | trainDescription   | planningUid   | schedule-type-LTP |
      | <trainDescription> | <planningUid> | checked           |
    Then there is 1 row returned in the log results
    And the first timetable log results are
      | trainId            | scheduleType | planningUid   |
      | <trainDescription> | LTP          | <planningUid> |
    When I search for Timetable logs with
      | trainDescription   | planningUid   | schedule-type-LTP |
      | <trainDescription> | <planningUid> | unchecked         |
    Then there are 0 rows returned in the log results


    Examples:
      | trainDescription | planningUid |
      | generated        | generated   |
