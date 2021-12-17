@newSession
Feature: 78858 - TMV Replay Controls & Display - Manual Replay Speed
  As a TMV User
  I want to the replay controls and view updated
  So that it is closer to CCF which I am familiar with

  Scenario Outline: 78870-1 - Manual Replay Speed
    # Given a replay session is open
    # When the user wishes to change the speed using a manual input
    # Then the replay speed is changed accordingly
    #
    # Notes:
    #   * Speed range 1 to 30
    #   * The slider is in-sync with the manually inputted value
    Given I am on the replay page
    And I select Next
    And I get the replay map configuration map groupings
    And I expand the replay group of maps with name '<mapGroup>'
    And I select the map '<map>'
    And I wait for the buffer to fill
    And I click Play button
    And the replay playback speed is 'Normal'
    When I increase the replay speed to <manuallyInputtedSpeed>, using the manual input
    Then the replay playback speed is '<expectedReplaySpeed>'

    Examples:
    | mapGroup               | map                   | manuallyInputtedSpeed | expectedReplaySpeed |
    | Wales & Western        | HDGW01paddington.v    |  5                    | x 5                 |
    | Wales & Western        | GW22heartofwales.v    | 10                    | x 10                |
    | North West and Central | MD01euston.v          | 15                    | x 15                |
    | North West and Central | NW22mpsccsig.v        | 20                    | x 20                |
    | Southern               | SO01charingcross.v    | 25                    | x 25                |
    | Southern               | HS1Shighspeed1south.v | 30                    | x 30                |
