Feature: 46461 - Replay Controls - NFR testing (page load)
  As a TMV dev team member
  I want to have automated test to monitor the performance of the replay controls
  So that I can have early sight of any performance issues

  Background:
    * I am on the home page
    * I reset the stopwatch

  Scenario Outline: 16 Replay - Performance (Open Replay Map) - <mapGroup> - <map>
    # Given the user has selected the replay icon
    # And has is viewing the time range selection
    # When the user selects a time range
    # Then the map view is opened ready for replay within 5 seconds
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name '<mapGroup>'
    And I start the stopwatch
    When I select the map '<map>'
    And I wait for the buffer to fill
    Then the stopwatch reads less than '5000' milliseconds, within a tolerance of '1000' milliseconds

    Examples:
    | mapGroup               | map                   |
    | Wales & Western        | HDGW01paddington.v    |
    | Wales & Western        | GW22heartofwales.v    |
    | North West and Central | MD01euston.v          |
    | North West and Central | NW22mpsccsig.v        |
    | Southern               | SO01charingcross.v    |
    | Southern               | HS1Shighspeed1south.v |

  Scenario: 17 Replay - Performance (Start Replay)
    # Given the user has selected a map to start the replay
    # And has selected a timeframe
    # When the user presses play
    # Then the stepping and signalling objects are replayed at normal speed within 5 seconds
    * I set up all signals for address 80 in D3 to be not-proceed
    Given I am on the replay page
    And I select Next
    And I expand the replay group of maps with name 'Wales & Western'
    And I select the map 'HDGW01paddington.v'
    And I wait for the buffer to fill
    And I click Skip forward button '4' times
    And I increase the replay speed at position 15
    When I start the stopwatch
    And I click Play button
    And the signal roundel for signal 'SN128' is red
    And I stop the stopwatch
    Then the stopwatch reads less than '5000' milliseconds, within a tolerance of '1000' milliseconds
