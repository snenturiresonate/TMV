Feature: timtable-generation

  @manual
  Scenario Outline: Get me a timetable
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | <file>   | <location>  | <timing>      | <trainNum>          | <planningUid>  |
    Examples:
      | file                                | trainNum | planningUid | location | timing   |
      | access-plan/1S42_PADTON_DIDCOTP.cif | 1B01     | B00001      | CHOLSEY  | WTT_arr  |
