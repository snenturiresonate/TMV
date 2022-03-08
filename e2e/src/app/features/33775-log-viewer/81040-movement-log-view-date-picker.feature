@TMVPhase2 @P2.Closeout
Feature: 33775 - TMV Log Viewer - Movement Log View - Date Picker

  As a TMV User
  I want the ability to access the TMV log viewer
  So that I can interrogate the data stored for business purposes

#  Given that I have the log viewer screen open on a Movement Log View tab
#  When I select the date entry
#  Then the date selector is displayed
#  And defaulted to today's date
#  And restricted to 90 days in the past and today's date
#  And the results reflects the date

#  Comments
#  Default to today's date
#  Can select a date 90 days in the past

  Background:
    Given I have not already authenticated
    And I am on the home page

  Scenario: 81040 - 1 Movement Log View - Date Picker - defaults

# Default to today's date

    When I am on the log viewer page
    And  I navigate to the Movement log tab
    Then the date field for Berth is displayed
    And the value of the date field for Berth is today
    When I open the date picker for Berth logs
    Then the date picker for Berth is displayed
    And the value of the date picker for Berth is today


  Scenario Outline: 81040 - 2 Movement Log View - Date Picker - validation through keyboard entry

# restricted to 90 days in the past and today's date
# Can select a date 90 days in the past

    When I am on the log viewer page
    And I navigate to the Movement log tab
    Then it <isPossible> possible to set the Berth date field to <date> with the keyboard

    Examples:
      | isPossible | date       |
      | is         | today - 90 |
      | isn't      | today - 91 |
      | isn't      | today + 1  |

  Scenario Outline: 81040 - 3 Movement Log View - Date Picker - validation through date picker

# restricted to 90 days in the past and today's date
# Can select a date 90 days in the past

    When I am on the log viewer page
    And I navigate to the Movement log tab
    Then it <isPossible> possible to set the Berth date field to <date> with the picker

    Examples:
      | isPossible | date       |
      | is         | today - 90 |
      | isn't      | today - 91 |
      | isn't      | today + 1  |

  Scenario Outline: 81040 - 4 Movement Log View - Date Picker - results only show movements running on date chosen

#  And the results reflects the date

    Given I clear the logged-berth-states Elastic Search index
    And I generate a new trainUID
    * I generate a new train description
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
    And I search for Berth logs for date 'today'
    Then there are 6 rows returned in the log results
    And I search for Berth logs for date 'yesterday'
    Then there are 0 rows returned in the log results

    Examples:
      | berth1 | berth2 | trainDescriber | trainDescription1 | trainDescription2 | planningUid |
      | C007   | C008   | D3             | 2D20              | 4H19              | generated   |

