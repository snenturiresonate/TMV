Feature: 34080 - Manually Clear Train Description
  The system shall allow a user to clear the track section facility on a map when a Train ID is left behind

  Background:
    * I am viewing the map HDGW01paddington.v
    * I have cleared out all headcodes
    * The admin setting defaults are as originally shipped

  Scenario Outline: 62775-1 Manually Clear Train Description
    # Given a TD update with the type interpose has been received
    # And the berth included  matches a single schedule
    # And the user is viewing the map that contains that berth
    # When the user opens the context menu for the train description
    # And the user selects Clear Berth
    # Then the train description is removed from the map
    Given the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <origTrainDesc>     | <trainUid>     |
    And I am on the trains list page
    And train '<origTrainDesc>' with schedule id '<trainUid>' for today is visible on the trains list
    And the following live berth interpose message is sent from LINX (creating a match)
      | toBerth | trainDescriber   | trainDescription |
      | <berth> | <trainDescriber> | <origTrainDesc>  |
    And the following live berth step message is sent from LINX (creating a match)
      | fromBerth | toBerth | trainDescriber   | trainDescription |
      | 0105      | 0125    | <trainDescriber> | <origTrainDesc>  |
    And I am viewing the map HDGW01paddington.v
    Then berth '<berth>' in train describer '<trainDescriber>' contains '<origTrainDesc>' and is visible
    When I wait for the Open timetable option for train description <origTrainDesc> in berth <berth>, describer <trainDescriber> to be available
    And I invoke the context menu on the map for train <origTrainDesc>
    Then the Matched version of the map context menu is displayed
    When I click on the clear berth option
    Then berth '<berth>' in train describer '<trainDescriber>' does not contain '<origTrainDesc>'

    Examples:
      | trainDescriber | berth | origTrainDesc | trainUid | location | subdivision | matchLevel |
      | D3             | A007  | 7B75          | B62775   | PADTON   | 401         | berth      |
