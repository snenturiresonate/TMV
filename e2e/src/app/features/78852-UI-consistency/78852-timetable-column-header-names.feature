@TMVPhase2 @P2.S1
Feature: 78852 - TMV UI Consistency

  Scenario Outline: 83104 - Timetable header names are consistent
    # Given a user is viewing a timetable
    # When the user the column header names
    # Then they are consistently named
    #
    # Comments:
    # TMV Timetable
    # Change field name "Train UID" to "Planning UID"
    # Change field name "Arr." to "Arr"
    # Change field name "Dep." to "Dep"
    * I generate a new trainUID
    * I generate a new train description
    * I remove all trains from the trains list
    * I remove today's train '<planningUid>' from the Redis trainlist
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | RDNGSTN     | WTT_arr       | <trainNum>          | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    When I am on the timetable view for service '<planningUid>'
    Then the tab title is '<trainNum> TMV Timetable'
    Then the timetable header train UID label is 'Planning UID:'
    Then the timetable planned 'arrival' header label is 'Arr'
    Then the timetable planned 'departure' header label is 'Dep'

    Examples:
      | trainNum  | planningUid |
      | generated | generated   |
