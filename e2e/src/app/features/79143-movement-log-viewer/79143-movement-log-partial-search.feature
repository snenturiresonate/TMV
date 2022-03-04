@TMVPhase2 @P2.S2
Feature: 79143 - TMV Movement Log Viewer - Partial Search

  As a TMV User
  I want to view, filter and search the Movement Logs
  So that I can work with the data that is of interest to me within the Movement Logs

  #  TMV User shall be able to filter a movement log search by using a data string including partial searches entered by the user.
  #  Partial text search used in the text fields presented for the logs:
  #     Train ID (any 2 consecutive characters, min of 2 characters)
  #     Planning UID (min 5 characters, if provided)
  #     Berth ID (min 4 characters, if provided)
  #  If a field has a value then the query performs an AND search

  Background:
    Given I clear the logged-berth-states Elastic Search index
    And I clear the logged-signal-states Elastic Search index
    And I clear the logged-latch-states Elastic Search index
    And I clear the logged-s-class Elastic Search index
    And I clear the logged-agreed-schedules Elastic Search index

  Scenario Outline: 81038-1 - Movement Log - Partial Search - Berth tab - valid train ID, berth and planningUid searches
    Given I generate a new trainUID
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
      | fromBerth  | trainDescriber   | trainDescription    |
      | <berth1>   | <trainDescriber> | <trainDescription1> |
    And the following live berth cancel messages are sent from LINX
      | fromBerth  | trainDescriber   | trainDescription    |
      | <berth2>   | <trainDescriber> | <trainDescription2> |
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth1> | <trainDescriber> | <trainDescription1> |
    And the following live berth interpose message is sent from LINX (to indicate train is present)
      | toBerth  | trainDescriber   | trainDescription    |
      | <berth2> | <trainDescriber> | <trainDescription2> |
    And I give the messages 2 seconds to get into elastic search
    And I refresh the Elastic Search indices
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      |                   |             |             |           |               |                 |
    Then the first berth log results are
      | trainId             | fromBerth | toBerth | planningUid   |
      | <trainDescription1> |           | D3C007  | <planningUid> |
      | <trainDescription2> |           | D3C008  |               |
      | <trainDescription1> | D3C007    |         | <planningUid> |
      | <trainDescription2> | D3C008    |         |               |
      | <trainDescription1> |           | D3C007  | <planningUid> |
      | <trainDescription2> |           | D3C008  |               |
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      | 2d                |             |             |           |               |                 |
    Then the first berth log results are
      | trainId             | fromBerth | toBerth | planningUid   |
      | <trainDescription1> |           | D3C007  | <planningUid> |
      | <trainDescription1> | D3C007    |         | <planningUid> |
      | <trainDescription1> |           | D3C007  | <planningUid> |
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      | 4h                |             |             |           |               |                 |
    Then the first berth log results are
      | trainId             | fromBerth | toBerth | planningUid   |
      | <trainDescription2> |           | D3C008  |               |
      | <trainDescription2> | D3C008    |         |               |
      | <trainDescription2> |           | D3C008  |               |
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      | 2d                |             | c007        |           |               |                 |
    Then the first berth log results are
      | trainId             | fromBerth | toBerth |
      | <trainDescription1> | D3C007    |         |
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      | 2d                |             |             | c007      |               |                 |
    Then the first berth log results are
      | trainId             | fromBerth | toBerth |
      | <trainDescription1> |           | D3C007  |
      | <trainDescription1> |           | D3C007  |
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      | 2d                |             |             |           | C007          |                 |
    Then the first berth log results are
      | trainId             | fromBerth | toBerth |
      | <trainDescription1> |           | D3C007  |
      | <trainDescription1> | D3C007    |         |
      | <trainDescription1> |           | D3C007  |
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      |                   | b1234       |             |           |               |                 |
    Then the first berth log results are
      | trainId             | fromBerth | toBerth | planningUid   |
      | <trainDescription1> |           | D3C007  | <planningUid> |
      | <trainDescription1> | D3C007    |         | <planningUid> |
      | <trainDescription1> |           | D3C007  | <planningUid> |
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      | 2d                | b1234       |             |           | c007          | d3              |
    Then the first berth log results are
      | trainId             | fromBerth | toBerth | planningUid   |
      | <trainDescription1> |           | D3C007  | <planningUid> |
      | <trainDescription1> | D3C007    |         | <planningUid> |
      | <trainDescription1> |           | D3C007  | <planningUid> |

    Examples:
      | berth1 | berth2 | trainDescriber | trainDescription1 | trainDescription2 | planningUid |
      | C007   | C008   | D3             | 2D20              | 4H19              | B12345      |


  #  TMV User shall be able to filter a movement log search by using a data string including partial searches entered by the user.
  #  A validation error to be displayed if the minimum characters are not met.

  Scenario: 81038-2 - Movement Log - Partial Search - Berth tab - invalid searches
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      | 1                 |             |             |           |               |                 |
    Then the movement logs berth tab search error message is shown * The Train ID must contain at least 2 characters
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      |                   | 1234        |             |           |               |                 |
    Then the movement logs berth tab search error message is shown * The Planning UID must contain at least 5 characters
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      |                   |             | 123        |           |               |                 |
    Then the movement logs berth tab search error message is shown * The Berth must contain at least 4 characters
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      |                   |             |             | 123      |               |                 |
    Then the movement logs berth tab search error message is shown * The Berth must contain at least 4 characters
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      |                   |             |             |           | 123          |                 |
    Then the movement logs berth tab search error message is shown * The Berth must contain at least 4 characters
    When I am on the log viewer page
    * I navigate to the Movement log tab
    * I search for Berth logs with
      | trainDescription  | planningUid | fromBerthId | toBerthId | fromToBerthId | trainDescriber  |
      |                   |             |             |           |               | 1               |
    Then the movement logs berth tab search error message is shown * The Train Describer must contain 2 characters

