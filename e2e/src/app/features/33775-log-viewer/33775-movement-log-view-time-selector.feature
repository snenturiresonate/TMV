@TMVPhase2 @P2.Closeout
Feature: 33775 - TMV Log Viewer - Movement Log View - Time Selector

  As a TMV User
  I want the ability to access the TMV log viewer
  So that I can interrogate the data stored for business purposes

#  Given that I have the log viewer screen open on a Movement Log View tab
#  When I select the set timeframe option
#  Then the start and end time are displayed
#  And are defaulted to an hour in the past with a duration of an hour
#  And the start time must be before the end time
#  And the results reflects the time range

#  Comments
#  Timeframe is optional
#  Timeframe bounded by the date i.e. not crossing midnight boundary

  Background:
    Given I have not already authenticated
    And I am on the home page

  Scenario: 81041 - 1 Movement Log View - Time Selector - defaults

#  Then the start and end time are displayed
#  And are defaulted to an hour in the past with a duration of an hour

    When I am on the log viewer page
    And I navigate to the Movement log tab
    And I set the Timeframe checkbox for Berth as checked
    Then the startTime field for Berth is displayed
    And the endTime field for Berth is displayed
    And the value of the startTime field for Berth is now - 60
    And the value of the endTime field for Berth is now


  Scenario Outline: 81041 - 2 Movement Log View - Time Selector - validation through keyboard entry

#  And the start time must be before the end time

    When I am on the log viewer page
    And I navigate to the Movement log tab
    And I set the Timeframe checkbox for Berth as checked
    Then it <isPossible> possible to set the Berth startTime to <startTime> and endTime to <endTime> with the keyboard

    Examples:
      | isPossible | startTime | endTime  |
      | is         | now       | now + 1  |
      | isn't      | now       | now      |
      | is         | 01:00:00  | 23:00:00 |
      | isn't      | 23:00:00  | 01:00:00 |


  Scenario Outline: 81041 - 3 Movement Log View - Time Selector - validation through time spinners

#  And the start time must be before the end time

    When I am on the log viewer page
    And I navigate to the Movement log tab
    And I set the Timeframe checkbox for Berth as checked
    Then it <isPossible> possible to set the Berth startTime to <startTime> and endTime to <endTime> with the spinners

    Examples:
      | isPossible | startTime | endTime  |
      | is         | now       | now + 1  |
      | isn't      | now       | now      |
      | is         | 01:00:00  | 23:00:00 |
      | isn't      | 23:00:00  | 01:00:00 |


  Scenario Outline: 81041 - 4 Movement Log View - Time Selector - results only show berth messages for the time range chosen

#  And the results reflects the time range

    Given I clear the logged-berth-states Elastic Search index
    And I generate a new trainUID
    And I remove all trains from the trains list
    And I remove today's train '<planningUid>' from the trainlist
    And the train in CIF file below is updated accordingly so time at the reference point is now, and then received from LINX
      | filePath                         | refLocation | refTimingType | newTrainDescription | newPlanningUid |
      | access-plan/1D46_PADTON_OXFD.cif | PADTON      | WTT_dep       | <trainDescription1> | <planningUid>  |
    And I wait until today's train '<planningUid>' has loaded
    And the following live berth interpose message is sent from LINX (to ensure following cancel clears the berth)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth1> | <trainDescriber> | <trainDescription1> |
    And the following live berth interpose message is sent from LINX (to ensure following cancel clears the berth)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth2> | <trainDescriber> | <trainDescription2> |
    And the following live berth cancel messages are sent from LINX
      | fromBerth | trainDescriber   | trainDescription    |
      | <berth1>  | <trainDescriber> | <trainDescription1> |
    And the following live berth cancel messages are sent from LINX
      | fromBerth | trainDescriber   | trainDescription    |
      | <berth2>  | <trainDescriber> | <trainDescription2> |
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth1> | <trainDescriber> | <trainDescription1> |
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth2> | <trainDescriber> | <trainDescription2> |
    And I give the messages 2 seconds to get into elastic search
    And I refresh the Elastic Search indices
    When I am on the log viewer page
    And I navigate to the Movement log tab
    And I search for Berth logs with
      | startTime   | endTime   |
      | <startTime> | <endTime> |
    Then there are <resultsReturned> rows returned in the log results

    Examples:
      | berth1 | berth2 | trainDescriber | trainDescription1 | trainDescription2 | planningUid | startTime | endTime   | resultsReturned |
      | C007   | C008   | D3             | 2D20              | 4H19              | generated   | now - 5   | now + 5   | 6               |
      | C007   | C008   | D3             | 2D20              | 4H19              | generated   | now - 60  | now - 1   | 0               |
      | C007   | C008   | D3             | 2D20              | 4H19              | generated   | now + 5   | now + 180 | 0               |
