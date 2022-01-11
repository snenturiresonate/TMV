@TMVPhase2 @P2.S1
@newSession
Feature: 78858 - TMV Replay Controls & Display - Change Replay Session Start and End Time
  As a TMV User
  I want to the replay controls and view updated
  So that it is closer to CCF which I am familiar with

  #  Given a user has already started a replay session
  #  When the user changes the start and/or end date & time of the replay session
  #  Then the replay session is re-initalised displaying "Loading Data"
  #
  #  Notes:
  #    * Maximum replay session is 4 hours
  #    * The replay session can cross midnight boundary <- manual test
  #    * The start time and date are pre-populated with the initial values
  #    * The user does not have to chose a map as this action is initiated from the map
  #    * 5 second max reload time
  #    * Need to handle loading errors <- manual test

  Scenario Outline: 78869-1 - Change Replay Session Start and End Time - also check reload time
    * I reset the stopwatch
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name '<mapGroup>'
    And I select the map '<map>'
    And I wait for the buffer to fill
    And I click Play button
    When I primary click the replay time
    Then the select map page is not displayed
    And the replay start time is pre-populated with an initial value
    And the replay date is pre-populated with an initial value
    When I set the date and time for replay to
      | date  | time     | duration |
      | today | now - 5  | 5        |
    And the maximum duration possible is 240 minutes
    And I select Next
    And I start the stopwatch
    Then the select map page is not displayed
    And the replay playback time and status contains 'Loading data...'
#    @bug @bug:83244
#    When the replay playback time and status does not contain 'Loading data...'
#    And I stop the stopwatch
#    Then the stopwatch reads less than '5000' milliseconds, within a tolerance of '500' milliseconds

  Examples:
    | mapGroup               | map                   |
    | Wales & Western        | HDGW01paddington.v    |
